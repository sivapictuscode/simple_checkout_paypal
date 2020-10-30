import 'package:flutter/material.dart';
import './paypal_lib.dart';
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  void showAlert(String text, scaffoldKey) {
    if (text != "") {
      scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.red,
          title: const Text('Paypal Simple Checkout'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: FlatButton(
                    child: Text(
                      "Sandbox Checkout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "MontserratBold",
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaypalSimpleCheckout(
                                  "siva.pictuscode@gmail.com",
                                  "USD",
                                  "Buying Ternmet script from Pictuscode",
                                  "1",
                                  "250",
                                  '0'))).then((value) {
                        if (value != "" && value != null) {
                          List<String> list = value;
                          var status = list[0];
                          var transactionId = list[1];
                          if (status == "success" && transactionId != "") {
                            showAlert(
                                "Successfully transaction completed. TransactionId:" +
                                    transactionId,
                                scaffoldKey);
                          } else if (status == "cancel") {
                            showAlert("Payment Cancelled", scaffoldKey);
                          }
                        }
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  margin: EdgeInsets.only(top: 25, left: 25, right: 25),
                  child: FlatButton(
                    child: Text(
                      "Live Checkout",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "MontserratBold",
                          fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaypalSimpleCheckout(
                                  "info@pictuscode.com",
                                  "USD",
                                  "Buying Ternmet script from Pictuscode",
                                  "1",
                                  "250",
                                  '1'))).then((value) {
                        if (value != "" && value == true) {}
                      });
                    },
                    textColor: Colors.white,
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
