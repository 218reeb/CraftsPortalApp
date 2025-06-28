import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crafts_portal/providers/auth_provider.dart';
import 'package:crafts_portal/models/user_model.dart';
import 'package:crafts_portal/screens/craftsman/craftsman_home_screen.dart';
import 'package:crafts_portal/screens/craftsman/craftsman_projects_screen.dart';
import 'package:crafts_portal/screens/craftsman/craftsman_chats_screen.dart';
import 'package:crafts_portal/screens/craftsman/craftsman_profile_screen.dart';
import 'package:crafts_portal/screens/customer/customer_home_screen.dart';
import 'package:crafts_portal/screens/customer/customer_search_screen.dart';
import 'package:crafts_portal/screens/customer/customer_chats_screen.dart';
import 'package:crafts_portal/screens/customer/customer_profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userModel = authProvider.userModel;
        
        if (userModel == null) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          body: _buildBody(userModel),
          bottomNavigationBar: _buildBottomNavigationBar(userModel),
        );
      },
    );
  }

  Widget _buildBody(UserModel userModel) {
    if (userModel.userType == UserType.craftsman) {
      return _buildCraftsmanBody();
    } else {
      return _buildCustomerBody();
    }
  }

  Widget _buildCraftsmanBody() {
    switch (_currentIndex) {
      case 0:
        return const CraftsmanHomeScreen();
      case 1:
        return const CraftsmanProjectsScreen();
      case 2:
        return const CraftsmanChatsScreen();
      case 3:
        return const CraftsmanProfileScreen();
      default:
        return const CraftsmanHomeScreen();
    }
  }

  Widget _buildCustomerBody() {
    switch (_currentIndex) {
      case 0:
        return const CustomerHomeScreen();
      case 1:
        return const CustomerSearchScreen();
      case 2:
        return const CustomerChatsScreen();
      case 3:
        return const CustomerProfileScreen();
      default:
        return const CustomerHomeScreen();
    }
  }

  Widget _buildBottomNavigationBar(UserModel userModel) {
    if (userModel.userType == UserType.craftsman) {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    } else {
      return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      );
    }
  }
} 