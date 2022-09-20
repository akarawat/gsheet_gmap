import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../model/form.dart';

/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
  //static const String URL = "https://script.google.com/macros/s/AKfycbyDx85t9SqSiwFNPbYRqJ6hR4Uc2bHtx3GduchbnqtmhRiFgCfGJuTMMMBM5rF5hEqk/exec";
  static const String URLApi =
      "https://script.google.com/macros/s/AKfycbxATSOHjAwHc5Gp19RFkP3YUVKWHtQwSIUhDxiR8nJSpoHPm7em0SeyPrPDVCXSBT3_Ng/exec"; // เปลี่ยนทุกครั้งที่มีการ Deploy
  static const String URLApiByOne =
      "https://script.google.com/macros/s/AKfycbyyGro2a4e_gVAJUcZzEWBEYjhl74-6spe0gMi_fyvq2_znw1Uu4STY7XSFUO0m4LkqMQ/exec"; // เปลี่ยนทุกครั้งที่มีการ Deploy
  static const String URLGoogle =
      'https://docs.google.com/spreadsheets/d/1WppZGyljxOVo8J00ajHHhS312ArzQLzTTDPMvhXAjxA/'; //ไม่ต้องเปลี่ยน
  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  String strBack = "";
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      await http
          .post(URLApi, body: feedbackForm.toJson())
          .then((response) async {
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
