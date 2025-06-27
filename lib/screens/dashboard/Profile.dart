import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../models/user_model.dart';
import 'WebViewScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _showLoadingAndNavigate() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Loading..."),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 300)); // Optional delay

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WebViewScreen(
          url: 'https://carisca.knust.edu.gh/about-us/about-us/',
          title: 'About Carisca',
        ),
      ),
    );

    if (mounted) Navigator.pop(context); // Close the loading dialog
  }

  @override
  Widget build(BuildContext context) {
    final loginResponse = ModalRoute.of(context)?.settings.arguments as UserData;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: _logout,
              child: Icon(Icons.exit_to_app, size: 30, color: AppColors.primaryRed),
            ),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            alignment: Alignment.bottomLeft,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage("assets/images/user.jpg"),
              ),
            ),
            Center(
              child: MainText(
                text:
                "${loginResponse.prefix} ${loginResponse.firstName} ${loginResponse.lastName} ${loginResponse.suffix ?? ""}",
                fontSize: 18,
              ),
            ),
            Center(child: MainText(text: loginResponse.email, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  text: loginResponse.category,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                MainText(
                  text: loginResponse.organization,
                  fontSize: 18,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: const BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MainText(text: "Country"),
                      MainText(text: loginResponse.country),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/sponsors-partners");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(text: "Partners & Sponsors"),
                        Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: _showLoadingAndNavigate,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(text: "About Carisca"),
                        Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(text: "Invite a friend"),
                        Icon(Icons.chevron_right_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const Button(label: "Join the CARISCA community"),
            const Spacer(),
            Image.asset("assets/images/dilogo.png"),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
