import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/Constants/routes.dart';
import 'package:mynotes/Utilities/show_error_dialoge.dart';
import 'package:mynotes/firebase_options.dart';
import 'dart:developer' as devtools show log;

class LogInView extends StatefulWidget {
  const LogInView({Key? key}) : super(key: key);

  @override
  State<LogInView> createState() => _LogInViewState();
}

class _LogInViewState extends State<LogInView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Enter your email ',
            ),
            controller: _email,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter your password '),
            controller: _password,
          ),
          TextButton(
              onPressed: () async {
                try {
                  final email = _email.text;
                  final password = _password.text;
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    await showErrorDialog(context, 'user not found');
                    devtools.log('User not found');
                  } else if (e.code == 'wornd-password') {
                    await showErrorDialog(context, 'Wornd credentials');
                    devtools.log('Incorect password');
                  } else {
                    await showErrorDialog(context, 'Error ${e.code}');
                  }
                  // TODO
                } catch (e) {
                  await showErrorDialog(context, 'Error: $e');
                }
              },
              child: Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: Text('Not register yet? Regisdter here!'))
        ],
      ),
    );
  }
}
