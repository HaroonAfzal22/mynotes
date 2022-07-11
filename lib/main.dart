import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/Constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login-view.dart';
import 'package:mynotes/views/rigester_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomeView(),
    // initialRoute: '/',
    routes: {
      loginRoute: (context) => const LogInView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
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
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return NotesView();
              } else {
                return const RegisterView();
              }
            } else {
              return const LogInView();
            }
            return const Text('Done');

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}

enum MenueAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Ui'),
        actions: [
          PopupMenuButton<MenueAction>(onSelected: (value) async {
            switch (value) {
              case MenueAction.logout:
                final shouldLogout = await ShowLogOutDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }
                // TODO: Handle this case.
                break;
            }
          },
              // child: Text('Logout'),
              itemBuilder: (context) {
            return const [
              PopupMenuItem<MenueAction>(
                child: Text('Logout'),
                value: MenueAction.logout,
              )
            ];
          })
        ],
      ),
      body: Center(child: Text('Notes Screen')),
    );
  }
}

Future<bool> ShowLogOutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      }).then((value) => value ?? false);
}
