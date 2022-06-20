import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mpesadaraja/src/endpoints.dart';

class MpesaDaraja {
  // ignore: non_constant_identifier_names
  String ENDPOINT =
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest";
  late String consumerKey;
  late String consumerSecret;
  late String passKey;
  late String businessShortCode;
  late String amount;

  /// the keys are required fields
  MpesaDaraja({
    required this.consumerKey,
    required this.consumerSecret,
    required this.passKey,
    required this.businessShortCode,
    required this.amount,
  });

  late String accessToken;
  late String expiresIN;

  String _generateAuth() {
    /// authorization
    /// --- Basic Auth Over https this is a base64 encoded string
    ///     of apps consumerKey and consumer secret
    ///
    /// grant_type
    ///    client_credentials grant_type is supported (under query parameters)
    //String consumerKey = "Dm4oJgziMyOT7WTmJzQfEZS6jjzg1Frd";
    //String consumerSecret = "RGRvsUGkO4jc3NuW";
    String b64secret = base64Url.encode(
      ("$consumerKey:$consumerSecret").codeUnits,
    );

    return b64secret;
  }

  Future<dynamic> _validateTimeBoundedAceessToken() async {
    String b64secret = _generateAuth();
    var response = await http.get(
      Uri.parse(Endpoint.AUTHORIZATION),
      headers: {"Authorization": "Basic $b64secret"},
    );

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(response.body);
      accessToken = jsonresponse["access_token"];
      expiresIN = jsonresponse["expires_in"];
      return await jsonresponse;
    } else {
      return throw Exception("Error::check internet Connection");
    }
  }

  String _getTimeStamp() {
    // get the current time stamp

    ///
    /// yy mm dd hh mm ss
    /// 20220620105547
    /// 20220620120157000

    ///2022-06-20 11:53:39.000
    ///20220620115950000

    var timeList = [];
    DateTime now = DateTime.now();
    DateTime timestamp = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    String formarttime = timestamp.toString();
    for (int i = 0; i < formarttime.length; i++) {
      var char = formarttime[i];
      if (char != "-" && char != ":" && char != "." && char != " ") {
        timeList.add(char);
      } else {}
    }
    String tStamp = timeList.join();

    /// remove the last three digits
    tStamp = tStamp.substring(0, tStamp.length - 3);
    return tStamp;
  }

  String _generatePassword() {
    /// base64.encode(Shortcode+Passkey+Timestamp)
    String till = businessShortCode;
    String timeStamp = _getTimeStamp();

    String rawPassword = "$till+$passKey+$timeStamp";

    final pswdBytes = utf8.encode(rawPassword);
    String password = base64.encode(pswdBytes);

    /// remove the equal sign
    ///
    password = password.substring(0, password.length - 1);
    print(password);
    return password;
  }

  Future<dynamic> lipaNaMpesaStk() async {
    await _validateTimeBoundedAceessToken();
    String password = _generatePassword();

    String timestamp = _getTimeStamp();
    var body = {
      "BusinessShortCode": businessShortCode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount,
      "PartyA": "254798071510",
      "PartyB": businessShortCode,
      "PhoneNumber": "254798071510",
      "CallBackURL": "https://mydomain.com/path",
      "AccountReference": "CompanyXLTD",
      "TransactionDesc": "Payment of X"
    };

    var response = await http.post(
      Uri.parse(ENDPOINT),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return response.body;
  }
}
