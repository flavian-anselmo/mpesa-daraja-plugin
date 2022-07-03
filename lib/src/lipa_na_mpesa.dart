import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mpesadaraja/src/endpoints.dart';

class MpesaDaraja {
  late String consumerKey;
  late String consumerSecret;
  late String passKey;

  /// the keys are required fields
  MpesaDaraja({
    required this.consumerKey,
    required this.consumerSecret,
    required this.passKey,
  });

  late String _accessToken;
  //late String _expiresIN;

  String _generateAuth() {
    /// authorization
    /// --- Basic Auth Over https this is a base64 encoded string
    ///     of apps consumerKey and consumer secret
    ///
    /// grant_type
    ///    client_credentials grant_type is supported (under query parameters)
    //String consumerKey = "Dm4oJgziMyOT7WTmJzQfEZS6jjzg1Frd";
    //String consumerSecret = "RGRvsUGkO4jc3NuW";

    ///
    /// MTc0Mzc5K2JmYjI3OWY5YWE5YmRiY2YxNThlOTdkZDcxYTQ2N2NkMmUwYzg5MzA1OWIxMGY3OGU2YjcyYWRhMWVkMmM5MTkrMjAyMjA2MjAyMzUzMjY=
    /// MTc0Mzc5YmZiMjc5ZjlhYTliZGJjZjE1OGU5N2RkNzFhNDY3Y2QyZTBjODkzMDU5YjEwZjc4ZTZiNzJhZGExZWQyYzkxOTIwMjIwNjIxMDAwOTQ1

    String b64secret = base64Url.encode(
      ("$consumerKey:$consumerSecret").codeUnits,
    );

    return b64secret;
  }

  Future<dynamic> _validateTimeBoundedAceessToken() async {
    /***
     * the access key will be used to make requests when making a stk push 
     * 
     */
    String b64secret = _generateAuth();
    var response = await http.get(
      Uri.parse(Endpoint.authorization),
      headers: {"Authorization": "Basic $b64secret"},
    );

    if (response.statusCode == 200) {
      var jsonresponse = jsonDecode(response.body);
      //pick the access key to be used in other requets
      _accessToken = jsonresponse["access_token"];
      // _expiresIN = jsonresponse["expires_in"];
      return await jsonresponse;
    } else {
      return throw Exception("Error");
    }
  }

  String _getTimeStamp() {
    /**
     * timestamp is the ime the transaction is taking place 
     * The time stamp is usually in a particular order yyyymmddhhmmss
     * 
     */
    DateTime now = DateTime.now();
    final tmstmp =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
    return tmstmp;
  }

  String _generatePassword(String shortcode) {
    /// base64.encode(Shortcode+Passkey+Timestamp)
    /***
     * the password is combination btwn the business short code, passkey and timestamp 
     * 
     */
    String shortCode = shortcode; // busimess short code
    String timeStamp = _getTimeStamp();
    //before encoding
    String raw = shortCode + passKey + timeStamp;
    final bytespswd = utf8.encode(raw);
    //base64 encoded password
    return base64Encode(bytespswd);
  }

  Future<dynamic> lipaNaMpesaStk(
    String businessShortCode,
    int amount,
    String partyA,
    String partyB,
    String phoneNumber,
    String callbackUrl,
    String accountReference,
    String transactionDesc,
  ) async {
    await _validateTimeBoundedAceessToken();
    String password = _generatePassword(businessShortCode);
    String timestamp = _getTimeStamp();
    var body = {
      "BusinessShortCode": businessShortCode,
      "Password": password,
      "Timestamp": timestamp,
      "TransactionType": "CustomerPayBillOnline",
      "Amount": amount.toString(),
      "PartyA": partyA,
      "PartyB": businessShortCode,
      "PhoneNumber": phoneNumber,
      "CallBackURL": callbackUrl,
      "AccountReference": accountReference,
      "TransactionDesc": transactionDesc,
    };

    var response = await http.post(
      Uri.parse(Endpoint.mpesaExpresSandbox),
      headers: {
        "Authorization": "Bearer $_accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    return response.body;
  }
}
