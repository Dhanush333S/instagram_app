import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/providers/user_providers.dart';
import 'package:instagram_app/responisve/mobile_screen_layout.dart';
import 'package:instagram_app/responisve/responsive_layout_screen.dart';
import 'package:instagram_app/responisve/web_screen_layout.dart';
import 'package:instagram_app/screens/login_screen.dart';
import 'package:instagram_app/screens/signup_screen.dart';
import 'package:instagram_app/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAhk40cmM_ii4-SbZ8kyrSEsHe1IPq8Y_w',
          appId: "1:777512847924:web:84e80f25e4ff0bf8a9d861",
          messagingSenderId: "777512847924",
          projectId: "instagram-744f5",
          storageBucket: "instagram-744f5.appspot.com"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: const ResponsiveLayout(
        //     mobileScreenLayout: MobileScreenLayout(),
        //     webScreenLayout: WebScreenLayout()),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
