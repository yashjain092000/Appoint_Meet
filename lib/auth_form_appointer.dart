import 'package:flutter/material.dart';

class AuthFormAppointer extends StatefulWidget {
  AuthFormAppointer(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;

  final void Function(
    String email,
    String password,
    String userName,
    String phn,
    String address,
    String specialisation,
    String fee,
    String emFee,
    int morTime1,
    int morTime2,
    int eveTime1,
    int eveTime2,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _AuthFormAppointerState createState() => _AuthFormAppointerState();
}

class _AuthFormAppointerState extends State<AuthFormAppointer> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _phn = '';
  String _address = '';
  String _specialisation = '';
  String _fee = '';
  String _emFee = '';
  int _morTime1 = 0;
  int _morTime2 = 0;
  int _eveTime1 = 0;
  int _eveTime2 = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
