import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../api/api_service.dart';
import '../../model/profile.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isTitleValid;

  TextEditingController _controllerTitle = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isTitleValid = true;
      _controllerTitle.text = widget.profile.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Color(0XFFEFF3F6),
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Color(0XFFEFF3F6),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.profile == null ? "Add List" : "Update List",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Stay productive',
                  style: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _buildTextFieldName(),
                SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color(0XFFEFF3F6),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          offset: Offset(5, 5),
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.9),
                          offset: Offset(-5, -5),
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                        )
                      ],
                    ),
                    child: FlatButton(
                      padding: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text(
                        widget.profile == null
                            ? "Submit".toUpperCase()
                            : "Update".toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {
                        if (_isTitleValid == null || !_isTitleValid) {
                          _scaffoldState.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Please fill all field"),
                            ),
                          );
                          return;
                        }
                        setState(() => _isLoading = true);
                        String content = _controllerTitle.text.toString();

                        Profile profile = Profile(content: content);
                        if (widget.profile == null) {
                          _apiService.createProfile(profile).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(
                                  _scaffoldState.currentState.context, true);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Pull down to refresh"),
                              ));
                            }
                          });
                        } else {
                          profile.id = widget.profile.id;
                          _apiService.updateProfile(profile).then((isSuccess) {
                            setState(() => _isLoading = false);
                            if (isSuccess) {
                              Navigator.pop(
                                  _scaffoldState.currentState.context, true);
                            } else {
                              _scaffoldState.currentState.showSnackBar(SnackBar(
                                content: Text("Pull down to refresh"),
                              ));
                            }
                          });
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextField(
      controller: _controllerTitle,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Title",
        errorText: _isTitleValid == null || _isTitleValid
            ? null
            : "Title is requiered",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isTitleValid) {
          setState(() => _isTitleValid = isFieldValid);
        }
      },
    );
  }
}
