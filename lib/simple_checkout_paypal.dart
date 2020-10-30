library simple_checkout_paypal;

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';
class PaypalSimpleCheckout extends StatefulWidget {
  /*String email = "siva.gmtechindia@gmail.com";
  String currencyCode = 'USD';
  String description = "Buying script from Pictuscode Pvt Ltd";
  String quantity = "1";
  String amount = "333";
  String mode = "0";
  Function successCallBack;
  Function cancelCallBack;*/

  final String email;
  final String currencyCode;
  final String description;
  final String quantity;
  final String amount;
  final String mode;

  PaypalSimpleCheckout(this.email, this.currencyCode, this.description,
      this.quantity, this.amount, this.mode);

  @override
  WebviewState createState() => WebviewState();
}

class WebviewState extends State<PaypalSimpleCheckout> {
  String paypalUrl = '';
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  String transactionId = '';
  int intcount = 0;
  StreamSubscription<String> _onUrlChanged;
  @override
  void initState() {
    super.initState();

    if (widget.mode == "0") {
      setState(() {
        paypalUrl = "https://www.sandbox.paypal.com/cgi-bin/webscr";
      });
    } else {
      setState(() {
        paypalUrl = "https://www.paypal.com/cgi-bin/webscr";
      });
    }
    _onUrlChanged =flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (intcount > 0) {
        url = url.replaceAll("~", "_");
      }

      intcount = intcount + 1;
      if (url.contains("payment_success")) {
        var uri = Uri.dataFromString(url);
        setState(() {
          transactionId = uri.queryParameters['tx'];
        });
        Navigator.pop(context, ["success", transactionId]);
      } else if (url.contains("payment_failure")) {
        Navigator.pop(context, ["cancel", '']);
      }
    });
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
  

    super.dispose();
  }

  String _loadHTML() {
    return r'''
      <html><head><title>Processing Payment...</title></head>
<body onload="document.forms['paypal_form'].submit();">
<center><h4>Please wait, your order is being processed and you will be redirected to the paypal website.</h4></center>
<form method="post" name="paypal_form" action="''' +
        paypalUrl +
        '''">
<input type="hidden" name="rm" value="2">
<input type="hidden" name="cmd" value="_xclick">
<input type="hidden" name="currency_code" value="''' +
        widget.currencyCode +
        '''">
<input type="hidden" name="business" value="''' +
        widget.email +
        '''">
<input type="hidden" name="return" value="http://ternmet.pictuscode.com/payment~success">
<input type="hidden" name="cancel_return" value="http://ternmet.pictuscode.com/payment~failure">
<input type="hidden" name="custom" value="Product|24|74">
<input type="hidden" name="item_name" value="''' +
        widget.description +
        '''">
<input type="hidden" name="user_id" value="33">
<input type="hidden" name="quantity" value="''' +
        widget.quantity +
        '''">
<input type="hidden" name="amount" value="''' +
        widget.amount +
        '''">
<center><br><br>If you are not automatically redirected to paypal within 5 seconds...<br><br>
<input type="submit" value="Click Here"></center>
</form></body></html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (_) => new WebviewScaffold(
              url: new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                  .toString(),
              appBar: new AppBar(
                backgroundColor: Colors.red,
                centerTitle: true,
                leading: InkWell(
                  child: Center(
                    child: Icon(Icons.arrow_back),
                  ),
                  onTap: () {
                    Navigator.pop(context, '');
                  },
                ),
                title: Text(
                  "Paypal Checkout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "MontserratBold",
                  ),
                ),
              ),
            ),
      },
    );
  }
}

