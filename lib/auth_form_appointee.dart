import 'package:flutter/material.dart';

class AuthFormAppointee extends StatefulWidget {
  AuthFormAppointee(
    this.submitFn,
    this.isLoading,
  );
  final bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    String phn,
    String age,
    String city,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormAppointeeState createState() => _AuthFormAppointeeState();
}

class _AuthFormAppointeeState extends State<AuthFormAppointee> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _phn = '';
  var _age = '';
  var _city = '';

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
