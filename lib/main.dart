import 'dart:convert';
import 'dart:html';
import 'dart:io';

//import 'package:ecbox_ggsheet_toto/report_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gsheet_gmap/report_data.dart';
import 'package:http/http.dart';
import 'controller/form_controller.dart';
import 'model/form.dart';
import 'model/resdata.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

Timer timer;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings parameters',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'VRU EC Box control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String tDisplay = "";

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
    String _sReturn = "";
    const apiUrl = FormController.URLApiByOne;
    final response = await http.get(Uri.parse(apiUrl));
    final data = jsonDecode(response.body);
    for (dynamic res_data in data) {
      _sReturn += res_data.toString() + ", ";
    }
    _sReturn = _sReturn.replaceAll('[', '').replaceAll(']', '');
    print(_sReturn);
    setState(() {
      tDisplay = _sReturn;
    });
  }

  void autoPress() {
    timer = new Timer(const Duration(seconds: 3), () {
      _fetchData();
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

  @override
  Widget build(BuildContext context) {
    autoPress();
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
                      //----Start Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: min_humidController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Min Humidity'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: max_humidController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Max Humidity'),
                            ),
                          ),
                        ],
                      ),
                      //----Start Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: min_tempController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Min Temp'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: max_tempController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Max Temp'),
                            ),
                          ),
                        ],
                      ),
                      //----Start Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: min_ecController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Min Electrin Conductor'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black.withOpacity(0.6)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: max_ecController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Max Electric Conductor'),
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
                                Text(""),
                                Text(""),
                                Text(
                                  "Update current data",
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
                      //----Start Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cur_humController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  labelText: 'Humidity current'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromRGBO(247, 48, 13, 1)
                                      .withOpacity(0.6)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: cur_tempController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'Temp current'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 20, 160, 2)
                                      .withOpacity(0.6)),
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: cur_ecController,
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'EC current'),
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Color.fromARGB(255, 10, 109, 240)
                                      .withOpacity(0.6)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),

            //----Start Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(100, 34, 29, 1)),
                        ),
                        child: Text('Send'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _launchURL,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: Text('Open Google'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _fetchData();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.green),
                        ),
                        child: Text('Get data'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //----Start Horizoltal line
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
            //----Start Row for button menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Report()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(100, 34, 29, 1)),
                        ),
                        child: Text('Report'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
