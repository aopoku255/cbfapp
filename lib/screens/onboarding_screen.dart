import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_pageIndex);
    print(_pages.length);
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
          toolbarHeight: 80,

        title:  _pageIndex + 1 == _pages.length
            ? InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Proceed",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                  color: AppColors.primaryGold,
                  borderRadius: BorderRadius.circular(10)),
            ))
            : Row(
          children: [
            ...List.generate(
                _pages.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: DotIndicator(
                      isActive: index == _pageIndex),
                )),
            Spacer(),
            InkWell(
              onTap: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(color: AppColors.primaryGold, borderRadius: BorderRadius.circular(100)),
                child: Center(child: Icon(Icons.arrow_forward, color: Colors.white,)),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: PageView.builder(
          itemCount: _pages.length,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _pageIndex = index;
            });
          },
          itemBuilder: (context, index) => OnboardingContent(
            image: _pages[index].image,
            title: _pages[index].title,
            description: _pages[index].description,
          ),

        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      width: isActive ? 30 : 10,
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> _pages = [
  Onboard(
    image: "assets/images/onboarding1.jpg",
    title: "CARISCA'S 2025 Supply Chain Research Summit!",
    description:
        "Dive into groundbreaking research, connect with global scholars, and explore Africa’s academic pulse, right here in Nigeria. Let’s show you around.",
  ),
  Onboard(
    image: "assets/images/onboarding2.jpg",
    title: "Reimagining Africa's Supply Chains for a Sustainable Future",
    description:
        "Browse sessions by topic, speaker, or day. Tap ★ to save your must-attend panels and get reminders before they start. Start exploring the agenda.",
  ),
  Onboard(
      image: "assets/images/onboarding3.jpg",
      title: "In-Person or Virtual, Connect with Supply Chain experts",
      description:
          "Browse sessions by topic, speaker, or day. Tap ★ to save your must-attend panels and get reminders before they start. Start exploring the agenda."),
];

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: Column(
        children: [
          // Image.asset(
          //   image,
          //   height: 500,
          // ),
          // const Spacer(),
          // SizedBox(
          //   height: 10,
          // ),
          Spacer(),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              MainText(
                text: title,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.primaryColor,
              ),
              SizedBox(
                height: 10,
              ),

              // MainText(text: description),
            ],
            ),
          ),

        ],
      ),
    );
  }
}
