import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/resources/auth_methods.dart';
import 'package:instagram_app/screens/signup_screen.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/utils.dart';
import 'package:instagram_app/widgets/text_input_field.dart';
import 'package:instagram_app/responisve/responsive_layout_screen.dart';
import 'package:instagram_app/responisve/mobile_screen_layout.dart';
import 'package:instagram_app/responisve/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailContoller.dispose();
    _passwordContoller.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailContoller.text,
      password: _passwordContoller.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != "Success") {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout()),
        ),
      );
      }
  }

  navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),

              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 24,
              ),

              const SizedBox(
                height: 24,
              ),

              TextInputField(
                textEditingController: _emailContoller,
                hintText: 'Enter Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _passwordContoller,
                hintText: 'Enter Password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),

              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Log In'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              // const SizedBox(height: 20,),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              GestureDetector(
                onTap: navigateToSignup,
                child: Container(
                  child: RichText(
                      text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(color: primaryColor)),
                    TextSpan(
                        text: 'Sign Up.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryColor)),
                  ])),
                ),
              ),
            ]),
      )),
    );
  }
}
