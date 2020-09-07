import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;

  final void Function(
    String typeUser,
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _typeUser = 'Appointee';
  var _userEmail = '';
  var _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
          _typeUser.trim(), _userEmail.trim(), _userPassword.trim(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 60.0),
        TypewriterAnimatedTextKit(
            speed: Duration(milliseconds: 300),
            totalRepeatCount: 0,
            // repeatForever: false,
            text: ["Welcome Back!"],
            textStyle: TextStyle(
                fontSize: 30, fontFamily: "Agne", fontWeight: FontWeight.w500),
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart),
        SizedBox(height: 60.0),
        Center(
          child: Card(
            shadowColor: Colors.deepPurple,
            elevation: 20.0,
            margin: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                            labelText: 'Email address',
                            labelStyle: TextStyle(color: Colors.grey[600])),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 7) {
                            return 'Password must be at least 7 characters long.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.grey[600])),
                        obscureText: true,
                        onSaved: (value) {
                          _userPassword = value;
                        },
                      ),
                      SizedBox(height: 12),
                      if (widget.isLoading) CircularProgressIndicator(),
                      if (!widget.isLoading)
                        RaisedButton(
                          elevation: 6.0,
                          color: Colors.deepPurple,
                          textColor: Colors.white,
                          child: Text('Login'),
                          onPressed: _trySubmit,
                        ),
                      if (!widget.isLoading)
                        FlatButton(
                          textColor: Colors.deepPurple,
                          child: Text("Forgot Password?"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ));
                          },
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
