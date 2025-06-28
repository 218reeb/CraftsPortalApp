import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crafts_portal/providers/user_provider.dart';
import 'package:crafts_portal/models/user_model.dart';
import 'package:crafts_portal/widgets/craftsman_card.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _selectedLocation;
  List<UserModel> _filteredCraftsmen = [];

  @override
  void initState() {
    super.initState();
    _loadCraftsmen();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCraftsmen() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadCraftsmen();
    _filterCraftsmen();
  }

  void _filterCraftsmen() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allCraftsmen = userProvider.craftsmen;

    _filteredCraftsmen = allCraftsmen.where((craftsman) {
      // Filter by search text
      final searchText = _searchController.text.toLowerCase();
      final matchesSearch = searchText.isEmpty ||
          craftsman.name.toLowerCase().contains(searchText) ||
          (craftsman.bio?.toLowerCase().contains(searchText) ?? false) ||
          (craftsman.craftCategory?.toLowerCase().contains(searchText) ?? false);

      // Filter by category
      final matchesCategory = _selectedCategory == null ||
          _selectedCategory!.isEmpty ||
          craftsman.craftCategory == _selectedCategory;

      // Filter by location
      final matchesLocation = _selectedLocation == null ||
          _selectedLocation!.isEmpty ||
          (craftsman.location?.toLowerCase().contains(_selectedLocation!.toLowerCase()) ?? false);

      return matchesSearch && matchesCategory && matchesLocation;
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final craftCategories = userProvider.getCraftCategories();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Craftsmen'),
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search craftsmen...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _filterCraftsmen();
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    _filterCraftsmen();
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Filter Row
                Row(
                  children: [
                    // Category Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ...craftCategories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                          _filterCraftsmen();
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Location Filter
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedLocation = value;
                          });
                          _filterCraftsmen();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Results Section
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCraftsmen,
              child: Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  if (userProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (userProvider.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading craftsmen',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            userProvider.error!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadCraftsmen,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (_filteredCraftsmen.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No craftsmen found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search criteria',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCraftsmen.length,
                    itemBuilder: (context, index) {
                      final craftsman = _filteredCraftsmen[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CraftsmanCard(
                          craftsman: craftsman,
                          onTap: () {
                            // TODO: Navigate to craftsman profile
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 