import 'package:cbfapp/models/register_model.dart';
import 'package:cbfapp/services/register_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override

  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  // _logout();
  }

  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      // Token exists, navigate to home
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }
  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');


  }

  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    bool _isLoading = false;
    RegisterService _registerService = RegisterService();

    void _handleSignIn() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });

        try {
          RegisterModel user = await _registerService.registerUser(_emailController.text.trim());
          // Proceed to next page, e.g.:
          Navigator.pushNamed(context, "/password", arguments: user);
        } catch (e) {
          print(e);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          );
          // Navigator.pushNamed(context, "/password", arguments: _emailController.text);
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/gold.png"), fit: BoxFit.cover)
          ),
        ),
      ),
      bottomSheet: Container(
        height: 50,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/dilogo.png"))
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/paperback.png"), fit: BoxFit.cover, opacity: 0.2)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            // margin: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/africa.png"), alignment: Alignment.center)),
                ),

                SizedBox(height: 20,),
                MainText(text: "Sign in", fontWeight: FontWeight.bold, fontSize: 28, color: AppColors.primaryGray,),
                SizedBox(height: 60,),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainText(
                        text: "Enter email address used for registration",
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGray,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "example@email.com",
                          fillColor: AppColors.primaryBlue,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, "/password");
                        },
                          child: MainText(text: "Already have a password? Login", color: AppColors.primaryColor,)),
                      SizedBox(height: 40),
                      Center(
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Button(
                          label: "Sign in",
                          backgroundColor: AppColors.primaryColor,
                          onTap: _handleSignIn,
                        ),
                      )
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
