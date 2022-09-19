class FeedbackForm {
  String min_humid;
  String max_humid;
  String min_temp;
  String max_temp;
  String min_ec;
  String max_ec;
  String flag;
  String cur_ec;
  String cur_temp;
  String cur_hum;
  String res_data;

  //min_humid, max_humid, min_temp, max_temp, min_ec, max_ec
  FeedbackForm(
      this.min_humid,
      this.max_humid,
      this.min_temp,
      this.max_temp,
      this.min_ec,
      this.max_ec,
      this.flag,
      this.cur_ec,
      this.cur_temp,
      this.cur_hum,
      this.res_data);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm(
        "${json['min_humid']}",
        "${json['max_humid']}",
        "${json['min_temp']}",
        "${json['max_temp']}",
        "${json['min_ec']}",
        "${json['max_ec']}",
        "${json['flag']}",
        "${json['cur_ec']}",
        "${json['cur_temp']}",
        "${json['cur_hum']}",
        "${json['res_data']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
        'min_humid': min_humid,
        'max_humid': max_humid,
        'min_temp': min_temp,
        'max_temp': max_temp,
        'min_ec': min_ec,
        'max_ec': max_ec,
        'flag': flag,
        'cur_ec': cur_ec,
        'cur_temp': cur_temp,
        'cur_hum': cur_hum,
        'res_data': res_data
      };
}
