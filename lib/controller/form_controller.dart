import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  //static const String URL = "https://script.google.com/macros/s/AKfycbyDx85t9SqSiwFNPbYRqJ6hR4Uc2bHtx3GduchbnqtmhRiFgCfGJuTMMMBM5rF5hEqk/exec";
  static const String URL =
      "https://script.google.com/macros/s/AKfycbyK0wDEzGsLCw3bPf-N4bjUwFJMjLZKMvBNdjH9xIkE6-G4c9Mon5H6GY3HZFkHHjbFaA/exec";
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  String strBack = "";
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        if (response.statusCode == 302) {
          var url = response.headers['location'];
          await http.get(url).then((response) {
            Map<String, dynamic> jdata =
                convert.jsonDecode(response.body)['status'];
            print('Howdy, ${jdata['status']}!');
            //var strBack = callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
      print(strBack);
    }
  }
}
