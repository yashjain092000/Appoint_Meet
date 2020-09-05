import 'package:flutter/material.dart';
//import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
    int age,
    String address,
    String specialisation,
    int fee,
    int emFee,
    dynamic morTime1,
    int morTime2,
    int eveTime1,
    int eveTime2,
    int eachTime,
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
  int _age = 0;
  String _address = '';
  String _specialisation = '';
  int _fee = 0;
  int _emFee = 0;
  dynamic _morTime1;
  dynamic _morTime2;
  dynamic _eveTime1;
  dynamic _eveTime2;
  int _eachTime = 0;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
          _userEmail.trim(),
          _userPassword.trim(),
          _userName.trim(),
          _phn.trim(),
          _age,
          _address.trim(),
          _specialisation.trim(),
          _fee,
          _emFee,
          _morTime1,
          _morTime2,
          _eveTime1,
          _eveTime2,
          _eachTime,
          _isLogin,
          context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    cursorColor: Colors.deepPurple,
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
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.grey[600])),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('phn'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        labelText: 'Phone No.',
                        labelStyle: TextStyle(color: Colors.grey[600])),
                    onSaved: (value) {
                      _phn = value;
                    },
                  ),
                  TextFormField(
                    key: ValueKey('age'),
                    validator: (value) {
                      if (value.isEmpty || value == '0') {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        labelText: 'Age',
                        labelStyle: TextStyle(color: Colors.grey[600])),
                    onSaved: (value) {
                      _age = int.parse(value);
                    },
                  ),
                  TextFormField(
                    key: ValueKey('address'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter a valid address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        labelText: 'Address',
                        labelStyle: TextStyle(color: Colors.grey[600])),
                    onSaved: (value) {
                      _address = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('specialisation'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 4) {
                          return 'Please enter a valid specialisation';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          labelText: 'Your Specialisation',
                          labelStyle: TextStyle(color: Colors.grey[600])),
                      onSaved: (value) {
                        _specialisation = value;
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('fee'),
                      validator: (value) {
                        if (value.isEmpty || value.length > 4) {
                          return 'Please enter a valid consultation fee';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          labelText: 'Consultation Fee',
                          labelStyle: TextStyle(color: Colors.grey[600])),
                      onSaved: (value) {
                        _fee = int.parse(value);
                      },
                    ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('emFee'),
                      validator: (value) {
                        if (value.isEmpty || value.length > 4) {
                          return 'Please enter a valid emergency fee';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          labelText: 'Emergency Fee',
                          labelStyle: TextStyle(color: Colors.grey[600])),
                      onSaved: (value) {
                        _emFee = int.parse(value);
                      },
                    ),
                  if (!_isLogin)
                    Column(children: <Widget>[
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              _morTime1 = DateFormat("HH:mm a").format(date);
                              print(_morTime1);
                              // _morTime1 = date;
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Enter Shift-I start time',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey[500]),
                          )),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 1.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              _morTime2 = DateFormat("HH:mm a").format(date);
                              print(_morTime2);
                              // _morTime1 = date;
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Enter Shift-I end time',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey[500]),
                          )),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 1.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              _eveTime1 = DateFormat("HH:mm a").format(date);
                              print(_eveTime1);
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Enter Shift-II start time',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey[500]),
                          )),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 1.0,
                      ),
                      FlatButton(
                          onPressed: () {
                            DatePicker.showTime12hPicker(context,
                                showTitleActions: true, onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            }, onConfirm: (date) {
                              _eveTime2 = DateFormat("HH:mm a").format(date);
                              print(_eveTime2);
                            }, currentTime: DateTime.now());
                          },
                          child: Text(
                            'Enter Shift-II end time',
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey[500]),
                          )),
                      Divider(
                        color: Colors.grey[500],
                        thickness: 1.0,
                      ),
                    ]),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('eachTime'),
                      validator: (value) {
                        if (value.isEmpty || int.parse(value) == 0) {
                          return 'Please enter a valid value';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                          labelText: 'Time given to each appointee(in mins)',
                          labelStyle: TextStyle(color: Colors.grey[600])),
                      onSaved: (value) {
                        _eachTime = int.parse(value);
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
                        labelStyle: TextStyle(color: Colors.grey[500])),
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
                      child: Text('Signup'),
                      onPressed: _trySubmit,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Colors.deepPurple,
                      child: Text(
                        _isLogin
                            ? "Appointer's sign up"
                            : "Appointee's sign up",
                      ),
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
// class BasicTimeField extends StatelessWidget {
//   String displayText = '';
//   BasicTimeField(this.displayText);
//   final format = DateFormat("hh:mm a");
//   @override
//   Widget build(BuildContext context) {
//     return Column(children: <Widget>[
//       Text(
//         '$displayText (${format.pattern})',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: Colors.grey[600],
//         ),
//       ),
//       DateTimeField(
//         format: format,
//         onShowPicker: (context, currentValue) async {
//           final time = await showTimePicker(
//             context: context,
//             initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
//           );
//           return DateTimeField.convert(time);
//         },
//       ),
//     ]);
//   }
// }
