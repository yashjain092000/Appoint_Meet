import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'auth_form_appointee.dart';

class AuthScreenAppointee extends StatefulWidget {
  @override
  _AuthScreenAppointeeState createState() => _AuthScreenAppointeeState();
}

class _AuthScreenAppointeeState extends State<AuthScreenAppointee> {
  //final _auth = FirebaseAuth.instance;

  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String username,
    String phn,
    String age,
    String city,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // authResult = await _auth.signInWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );
      } else {
        // authResult = await _auth.createUserWithEmailAndPassword(
        //   email: email,
        //   password: password,
        // );
        // await Firestore.instance
        //     .collection('users')
        //     .document(authResult.user.uid)
        //     .setData({
        //   'username': username,
        //   'email': email,
        // });
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
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthFormAppointee(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
