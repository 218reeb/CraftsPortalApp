import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafts_portal/models/user_model.dart';
import 'package:crafts_portal/models/project_model.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  List<UserModel> _craftsmen = [];
  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get craftsmen => _craftsmen;
  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCraftsmen({String? category, String? location}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Query query = _firestore
          .collection('users')
          .where('userType', isEqualTo: 'craftsman');

      if (category != null && category.isNotEmpty) {
        query = query.where('craftCategory', isEqualTo: category);
      }

      final snapshot = await query.get();
      _craftsmen = snapshot.docs
          .map((doc) => UserModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      // Filter by location if provided
      if (location != null && location.isNotEmpty) {
        _craftsmen = _craftsmen.where((craftsman) {
          return craftsman.location?.toLowerCase().contains(location.toLowerCase()) ?? false;
        }).toList();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load craftsmen: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProjects({String? craftsmanId, String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Query query = _firestore.collection('projects').where('isActive', isEqualTo: true);

      if (craftsmanId != null) {
        query = query.where('craftsmanId', isEqualTo: craftsmanId);
      }

      if (category != null && category.isNotEmpty) {
        query = query.where('craftCategory', isEqualTo: category);
      }

      final snapshot = await query.orderBy('createdAt', descending: true).get();
      _projects = snapshot.docs
          .map((doc) => ProjectModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load projects: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> getCraftsmanById(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        return UserModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      _error = 'Failed to load craftsman: $e';
      notifyListeners();
      return null;
    }
  }

  Future<List<ProjectModel>> getProjectsByCraftsman(String craftsmanId) async {
    try {
      final snapshot = await _firestore
          .collection('projects')
          .where('craftsmanId', isEqualTo: craftsmanId)
          .where('isActive', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProjectModel.fromMap({...doc.data() as Map<String, dynamic>, 'id': doc.id}))
          .toList();
    } catch (e) {
      _error = 'Failed to load craftsman projects: $e';
      notifyListeners();
      return [];
    }
  }

  Future<bool> addProject({
    required String title,
    required String description,
    required List<String> imageUrls,
    required String craftCategory,
    required String craftsmanId,
  }) async {
    try {
      final project = ProjectModel(
        id: '', // Will be set by Firestore
        craftsmanId: craftsmanId,
        title: title,
        description: description,
        imageUrls: imageUrls,
        craftCategory: craftCategory,
        createdAt: DateTime.now(),
      );

      final docRef = await _firestore.collection('projects').add(project.toMap());
      
      // Add the project to the local list
      final newProject = project.copyWith(id: docRef.id);
      _projects.insert(0, newProject);
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to add project: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProject({
    required String projectId,
    String? title,
    String? description,
    List<String>? imageUrls,
    String? craftCategory,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (imageUrls != null) updates['imageUrls'] = imageUrls;
      if (craftCategory != null) updates['craftCategory'] = craftCategory;

      await _firestore.collection('projects').doc(projectId).update(updates);

      // Update local project
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index != -1) {
        _projects[index] = _projects[index].copyWith(
          title: title,
          description: description,
          imageUrls: imageUrls,
          craftCategory: craftCategory,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _error = 'Failed to update project: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProject(String projectId) async {
    try {
      await _firestore.collection('projects').doc(projectId).update({'isActive': false});
      
      // Remove from local list
      _projects.removeWhere((p) => p.id == projectId);
      notifyListeners();
      
      return true;
    } catch (e) {
      _error = 'Failed to delete project: $e';
      notifyListeners();
      return false;
    }
  }

  List<String> getCraftCategories() {
    return [
      'Woodworking',
      'Metalworking',
      'Pottery',
      'Textiles',
      'Jewelry',
      'Glassblowing',
      'Leatherworking',
      'Carpentry',
      'Blacksmithing',
      'Ceramics',
      'Basket Weaving',
      'Other',
    ];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 