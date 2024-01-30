import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthenticator {
  Future<void> login(context, _usernameController, _passwordController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);
      print(userCredential.user!.email);

      Navigator.pushNamed(context, '/home', arguments: {
        'userName': userCredential.user!.email,
      });
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Wrong username or password'),
        ),
      );
    }
  }

  Future<void> signUp(context, _emailController, _passwordController) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      Navigator.pushNamed(context, '/home',
          arguments: userCredential.user!.email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('The password provided is too weak.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            elevation: 10,
            backgroundColor: Colors.red,
            content: Text("ID/Password not accepted. Please change it."),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }
}
