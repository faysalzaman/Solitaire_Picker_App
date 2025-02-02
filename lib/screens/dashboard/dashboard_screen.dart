import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/cubit/picker_profile/profile_cubit.dart';
import 'package:solitaire_picker/screens/dashboard_screen/home_screen.dart';
import 'package:solitaire_picker/screens/history/history_screen.dart';
import 'package:solitaire_picker/screens/pickers/available_pickers_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of pages/widgets to display
  final List<Widget> _pages = [
    HomeScreen(),
    const AvailablePickersScreen(),
    const HistoryScreen(),
    Container(child: const Center(child: Text('Settings'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getCustomerProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: AppColors.primaryColor,
      //   title: _pages[_selectedIndex] == _pages[0]
      //       ? const Text('Dashboard')
      //       : _pages[_selectedIndex] == _pages[1]
      //           ? const Text('Pickers')
      //           : _pages[_selectedIndex] == _pages[2]
      //               ? const Text('History')
      //               : const Text('Settings'),
      //   // profile button
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: Image.network(
      //         'https://via.placeholder.com/150',
      //         width: 30,
      //         height: 30,
      //         fit: BoxFit.cover,
      //         errorBuilder: (context, error, stackTrace) {
      //           return const Icon(Icons.person);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        iconSize: 24,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal,
        ),
        elevation: 10,
        type: BottomNavigationBarType.fixed, // Required when more than 3 items
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
            backgroundColor: AppColors.primaryColor,
            activeIcon: Icon(
              Icons.dashboard,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page_outlined),
            label: 'Request',
            backgroundColor: AppColors.primaryColor,
            activeIcon: Icon(
              Icons.request_page,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: 'History',
            backgroundColor: AppColors.primaryColor,
            activeIcon: Icon(
              Icons.history,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
            backgroundColor: AppColors.primaryColor,
            activeIcon: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
