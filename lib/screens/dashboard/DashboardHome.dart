import 'dart:async';
import 'package:cbfapp/models/user_model.dart';
import 'package:cbfapp/screens/HomeTabPages/HomeOngoing.dart';
import 'package:cbfapp/screens/HomeTabPages/HomeUpcoming.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class DashboardHome extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const DashboardHome({super.key, this.userDetailsFuture});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int selectedIndex = 0;
  final List<String> tabs = ["Ongoing", "Upcoming"];
  final tabPages = [HomeOngoing(), HomeUpcoming()];

  // Banner carousel
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> bannerImages = [
    "assets/images/thankyou.jpg",
    "assets/images/sponsors.jpg",
    "assets/images/partners.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % bannerImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfoModel>(
      future: widget.userDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(
            body: Center(child: Text('No user data found.')),
          );
        }

        final userDetails = snapshot.data!.data;

        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/profile", arguments: userDetails);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.25),
                  child: MainText(
                    text: userDetails.lastName[0].toUpperCase(),
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            centerTitle: true,
            title: MainText(text: "Welcome, ${userDetails.lastName}"),
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/announcement");
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Image.asset("assets/images/megaphone.png", scale: 1.2),
                ),
              )
            ],
          ),
          backgroundColor: AppColors.primaryBackground,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // 🖼️ Auto-Swiping Banner
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: PageView.builder(

                        controller: _pageController,
                        itemCount: bannerImages.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            color: Colors.white,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                bannerImages[index],
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(bannerImages.length, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? AppColors.primaryColor
                                : Colors.grey,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // 📌 Ongoing / Upcoming Tabs
                    Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: List.generate(tabs.length, (index) {
                          final bool isSelected = selectedIndex == index;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primaryColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: selectedIndex == 0
                                      ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      topLeft: Radius.circular(50))
                                      : const BorderRadius.only(
                                      bottomRight: Radius.circular(50),
                                      topRight: Radius.circular(50)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        if (isSelected)
                                          Icon(Icons.check,
                                              color: AppColors.primaryColor),
                                        const SizedBox(width: 10),
                                        MainText(
                                          text: tabs[index],
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.primaryColor
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    const SizedBox(height: 20),
                    tabPages[selectedIndex],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
