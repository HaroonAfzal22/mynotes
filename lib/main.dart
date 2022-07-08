import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login-view.dart';
import 'package:mynotes/views/rigester_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomeView(),
    // initialRoute: '/',
    routes: {
      '/login/': (context) => const LogInView(),
      '/register/': (context) => const RegisterView(),
    },
  ));
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return LogInView();
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print('Emial is verified');
              } else {
                return const RegisterView();
              }
            } else {
              return LogInView();
            }
            return const Text('Done');

          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
