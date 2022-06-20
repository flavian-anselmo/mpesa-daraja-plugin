import 'package:flutter_test/flutter_test.dart';

import 'package:mpesadaraja/mpesadaraja.dart';

Future<void> main() async {
  // test('adds one to input values', () {
  //   final calculator = Calculator();
  //   expect(calculator.addOne(2), 3);
  //   expect(calculator.addOne(-7), -6);
  //   expect(calculator.addOne(0), 1);
  // });
  //final calculator = Calculator();

  //print(calculator.addOne(6));
  ///
  ///bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919

  final stk = MpesaDaraja(
    consumerKey: 'Dm4oJgziMyOT7WTmJzQfEZS6jjzg1Frd',
    consumerSecret: 'RGRvsUGkO4jc3NuW',
    passKey: 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919',
    amount: 1.toString(),
    businessShortCode: 174379.toString(),
  );

  /// test generation of Basic Auth
  /// combine the consumerKey and consumerSecret and encode
  //print(stk.generateAuth());
  print(await stk.lipaNaMpesaStk());
}
