import 'package:flutter_test/flutter_test.dart';

import 'package:mpesadaraja/mpesadaraja.dart';

Future<void> main() async {
  final stk = MpesaDaraja(
    consumerKey: 'Dm4oJgziMyOT7WTmJzQfEZS6jjzg1Frd',
    consumerSecret: 'RGRvsUGkO4jc3NuW',
    passKey: 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919',
    amount: 1.toString(),
    businessShortCode: 174379.toString(),
  );
  print(await stk.lipaNaMpesaStk());
}
