<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->
# mpesa-daraja-plugin-flutter-dart

dart wrapper for mpesa daraja api by safaricom 


## Features

1. [Done]Lipa na mpesa [x]
2. [inprogress] C2B
3. [inprogress] B2B
4. [inprogress] C2B
5. [inprogress] B2C
6. [inprogress] TRANSACTION STATUS
7. [inprogress] ACCOUNT BALANCE
8. [inprogress] REVERSAL
## Getting started

You Will need a few things from Safaricom before development.

1. Consumer Key
2. Consumer Secret
3. Test Credentials for Development/Sanbox environment
  - Login or Register as a Safaricom developer here if you haven't.
  - Add a new App [here](https://developer.safaricom.co.ke/MyApps)
  - You will be issued with a ``Consumer Key`` and ``Consumer Secret``. You will use these to initiate an Mpesa Instance.
  - Obtain Test Credentials [here](https://developer.safaricom.co.ke/TestCredentials).
  - The Test Credentials Obtained Are only valid in Sandbox/Development environment. Take note of them.
  - To run in Production Environment you will need real Credentials.
  - To go Live and be issued with real credentials,please refer to this guide

4. Add dependancy in pubspec.yaml
```dart
dependencies:
  mpesadaraja: ^0.1.2
```  



## Lipa Na MPesa Online 
1. creat ``MpesaDaraja`` object and pass the following parameters:
 ```dart 
  MpesaDaraja stkpush = MpesaDaraja(
    consumerKey:<>
    consumerSecret:<>
    passKey:<>
  )
```
or make it a ``final`` as shown below:

```dart 
  final  stkpush = MpesaDaraja(
    consumerKey:<>
    consumerSecret:<>
    passKey:<>
  )

```  
  1. cosumerKey:
  2. consumerSecret
  3. passKey 
  - The keys are generated when you create an app at [Daraja 2.0] website 
    [Click here](https://developer.safaricom.co.ke/MyApps) to create your keys 

  - The keys are a secret, so be sure to use them as environment variables in production code 

2. Use the object created to call ``lipaNaMpesaStk()`` function to initialize the process
    -  if the function is inside anaother be sure to use a ``Future`` with ``await`` when caloing the function 
    - pass the required parameters in the function as shwon below 
```dart
 await stk.lipaNaMpesaStk(
    <BusinnessShortCode>,
    <Amount>,
    <PartyA>,
    <PartB>,
    <PhoneNumber>,
    <CallBackUrl>,
    <AccountReference>,
    <TransactionDescription>,
  );

```    
#### Parameters passed in lipaNaMpesaStk() function
``BusinessShortCode``
``Amount``
``PartyA``
``PartyB``
``PhoneNUmber``
``CallBackUrl``
``AccountReference``
``TransactionDescription``



```dart
Future<void> main() async {
  final stk = MpesaDaraja(
    consumerKey: 'Dm4oJgziMyOT7WTmJzQfEZS6jjzg1Frd',
    consumerSecret: 'RGRvsUGkO4jc3NuW',
    passKey: 'bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919',
  );

  await stk.lipaNaMpesaStk(
    "174379",
    1,
    "254798071520",
    "174379",
    "254798071520",
    "https://mydomain.com/path",
    "accountReference",
    "transactionDesc",
  );
}

```



## Demo
-  coming soon ....


