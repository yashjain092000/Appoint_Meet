import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'signup_form.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    String phn,
    int age,
    String address,
    String specialisation,
    String fee,
    String emFee,
    dynamic morTime1,
    dynamic morTime2,
    dynamic eveTime1,
    dynamic eveTime2,
    int eachTime,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        print("Appointee's signup");
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'typeUser': 'Appointee'
        });
        await Firestore.instance
            .collection('Appointees')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'age': age,
          'phone no.': phn,
          'address': address
        });
      } else {
        print("Appointer's signup");
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'email': email,
          'typeUser': 'Appointer'
        });
        await Firestore.instance
            .collection('Appointers')
            .document(authResult.user.uid)
            .setData({
          'username': username,
          'specialisation': specialisation,
          'phone_no': phn,
          'address': address,
          'normal_fee': fee,
          'emergency_fee': emFee,
          'morning_start_time': morTime1,
          'morning_end_time': morTime2,
          'evening_start_time': eveTime1,
          'evening_end_time': eveTime2,
          'patient_time': eachTime
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthFormAppointer(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
