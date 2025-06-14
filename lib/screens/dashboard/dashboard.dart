import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/screens/dashboard/DashboardAgenda.dart';
import 'package:cbfapp/screens/dashboard/DashboardHome.dart';
import 'package:cbfapp/screens/dashboard/DashboardResources.dart';
import 'package:cbfapp/screens/dashboard/DashboardSpeakers.dart';
import 'package:cbfapp/screens/dashboard/QRScannerScreen.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../services/user_service.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  late Future<UserInfoModel> _userdetailsFuture;

  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _userdetailsFuture = UserService().fetchUserDetails(1);
    _pages = [
      DashboardHome(userDetailsFuture: _userdetailsFuture),
      DashboardAgenda(),
      DashboardSpeakers(),
      DashboardResources(),
    ];
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primaryColor.withOpacity(0.9),
        selectedFontSize: 14,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: AppColors.primaryBackground,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedIndex == 0
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                "assets/images/homeicon.png",
                height: 24,
                width: 24,
                color:
                    _selectedIndex == 0 ? AppColors.primaryColor : Colors.black,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedIndex == 1
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                "assets/images/agenda.png",
                height: 24,
                width: 24,
                color:
                    _selectedIndex == 1 ? AppColors.primaryColor : Color(0xFF374957),
              ),
            ),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedIndex == 2
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                "assets/images/microphone.png",
                height: 24,
                width: 24,
                color:
                    _selectedIndex == 2 ? AppColors.primaryColor : Color(0xFF374957),
              ),
            ),
            label: 'Speakers',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: _selectedIndex == 3
                    ? AppColors.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Image.asset(
                "assets/images/resources.png",
                height: 24,
                width: 24,
                color:
                    _selectedIndex == 3 ? AppColors.primaryColor : Color(0xFF374957),
              ),
            ),
            label: 'Resources',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
      backgroundColor: AppColors.primaryBackground,
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        highlightElevation: 0,
        backgroundColor: AppColors.primaryColor.withOpacity(0.1),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const QRScannerScreen(),
            ),
          );

          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Scanned: $result')),
            );
            // TODO: Use the result (e.g., open a page, search, etc.)
          }
        },
        child: const Icon(Icons.qr_code_scanner, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
