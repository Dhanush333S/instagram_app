import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_app/resources/auth_methods.dart';
import 'package:instagram_app/screens/login_screen.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:instagram_app/utils/utils.dart';
import 'package:instagram_app/widgets/text_input_field.dart';
import 'package:instagram_app/responisve/responsive_layout_screen.dart';
import 'package:instagram_app/responisve/mobile_screen_layout.dart';
import 'package:instagram_app/responisve/web_screen_layout.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailContoller = TextEditingController();
  final TextEditingController _passwordContoller = TextEditingController();
  final TextEditingController _bioContoller = TextEditingController();
  final TextEditingController _usernameContoller = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailContoller.dispose();
    _passwordContoller.dispose();
    _bioContoller.dispose();
    _usernameContoller.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        bio: _bioContoller.text,
        email: _emailContoller.text,
        username: _usernameContoller.text,
        password: _passwordContoller.text,
        file: _image!);
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

  navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
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
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'http://www.psdgraphics.com/file/user-icon.jpg'),
                        ),
                  Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo),
                      ))
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                height: 24,
              ),
              TextInputField(
                textEditingController: _usernameContoller,
                hintText: 'Enter Username',
                textInputType: TextInputType.text,
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
              TextInputField(
                textEditingController: _bioContoller,
                hintText: 'Enter Bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign Up'),
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
                onTap: navigateToLogin,
                child: Container(
                  child: RichText(
                      text: const TextSpan(children: <TextSpan>[
                    TextSpan(text: "Have an account?",style: TextStyle(color: primaryColor)),
                    TextSpan(
                        text: 'Log in.',
                        style: TextStyle(fontWeight: FontWeight.bold,color: primaryColor)),
                  ])),
                ),
              ),
            ]),
      )),
    );
  }
}
