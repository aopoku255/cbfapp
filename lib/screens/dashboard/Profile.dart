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
    await prefs.remove('token'); // replace 'token' with your actual key if different

    // Optionally navigate to login or welcome screen
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login'); // adjust route name accordingly
  }

  @override
  Widget build(BuildContext context) {
    final loginResponse = ModalRoute.of(context)?.settings.arguments as UserData;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        actions: [
          Padding(padding: EdgeInsets.only(right: 20),child: InkWell(
            onTap: _logout,
              child: Icon(Icons.exit_to_app,size: 30, color: AppColors.primaryRed,)),)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), alignment: Alignment.bottomLeft)),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage("assets/images/user.jpg"),
                ),
              ),

              Center(child: MainText(text: "${loginResponse?.prefix} ${loginResponse?.firstName} ${loginResponse?.lastName} ${loginResponse?.suffix ?? ""}", fontSize: 18,)),
              Center(child: MainText(text: loginResponse!.email, fontSize: 12,)),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainText(text: loginResponse.category, fontSize: 18, fontWeight: FontWeight.bold,),
                  MainText(text: loginResponse.organization, fontSize: 18,),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MainText(text: "Country"),
                        MainText(text: loginResponse.country)
                      ],
                    ),
                    SizedBox(height:20,),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, "/sponsors-partners");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MainText(text: "Partners & Sponsors"),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),
                    SizedBox(height:20,),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WebViewScreen(
                              url: 'https://carisca.knust.edu.gh/about-us/about-us/',
                              title: 'About Carisca',

                            ),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          MainText(text: "About Carisca"),
                          Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),

                    SizedBox(height:20,),

                  ],
                ),
              ),
              Button(label: "Join the CARISCA community"),
              SizedBox(height: 10,),
              Image.asset("assets/images/dilogo.png")
            ],
          ),
        ),
      ),
    );
  }
}
