import 'dart:convert';
import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'model/resdata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

//void main() => runApp(Report());

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings parameters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyReportPage(title: 'REPORT EC Box control'),
    );
  }
}

class MyReportPage extends StatefulWidget {
  MyReportPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyReportPageState createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String tDisplay = "";
  List<String> _listData = [];

  // TextField Controllers
  //min_humid, max_humid, min_temp, max_temp, min_ec, max_ec
  TextEditingController min_humidController = TextEditingController();
  TextEditingController max_humidController = TextEditingController();
  TextEditingController min_tempController = TextEditingController();
  TextEditingController max_tempController = TextEditingController();
  TextEditingController min_ecController = TextEditingController();
  TextEditingController max_ecController = TextEditingController();

  TextEditingController flagController = TextEditingController();
  TextEditingController cur_ecController = TextEditingController();
  TextEditingController cur_tempController = TextEditingController();
  TextEditingController cur_humController = TextEditingController();
  TextEditingController resDataController = TextEditingController();

  Future<void> _fetchData() async {
    const apiUrl = FormController.URLApiByOne;

    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);
    String _sReturn = "";
    for (dynamic res_data in data) {
      _sReturn += res_data.toString() + ", ";
    }
    _sReturn = _sReturn.replaceAll('[', '').replaceAll(']', '');
    print(_sReturn);
    setState(() {
      tDisplay = _sReturn;
    });
  }

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      FeedbackForm feedbackForm = FeedbackForm(
          min_humidController.text,
          max_humidController.text,
          min_tempController.text,
          max_tempController.text,
          min_ecController.text,
          max_ecController.text,
          flagController.text,
          cur_ecController.text,
          cur_tempController.text,
          cur_humController.text,
          resDataController.text);

      FormController formController = FormController();
      _showSnackbar("Submitting Feedback");
      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Feedback Submitted");
        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  void _launchURL() async {
    // Open Google Sheet in default browser
    const url = FormController.URLGoogle;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Future<String> fetch() async {
  //   final response = await http.get('url');
  //   String conteggio = response.body;
  //   return conteggio;
  // }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(
      content: const Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {},
      ),
    );
    //_scaffoldKey.currentState.showSnackBar(snackBar);
  }

  String strData = "";
  @override
  Widget build(BuildContext context) {
    //String _loadedPhotos = "-";

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[Divider(color: Colors.black)],
                            ),
                          ),
                        ],
                      ),

                      //----Start Row For get Data
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(""),
                                ElevatedButton(
                                  onPressed: () {
                                    _fetchData();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green),
                                  ),
                                  child: Text('Get data'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //----Start Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  tDisplay,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                                Divider(color: Colors.black)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
