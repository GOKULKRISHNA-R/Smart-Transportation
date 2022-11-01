import 'dart:developer';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pay/pay.dart';
import 'package:smart_transportation/Services/db.dart';
import '../Shared/constants.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int balance = ;
  DbService dbService = DbService();
  @override
  void initState() {
    dbService.readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _paymentItems = <PaymentItem>[
      const PaymentItem(
        label: 'Total',
        amount: '102.99',
        status: PaymentItemStatus.final_price,
        type: PaymentItemType.total,
      )
    ];
    return Scaffold(
      // backgroundColor: kPrimaryLightColor,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Welcome...Gokul !",
                style: TextStyle(color: kPrimaryDarkColor, fontSize: 21),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.fromLTRB(21, 30, 21, 0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  border: Border.all(
                      color: kPrimaryColor,
                      width: 4.0,
                      style: BorderStyle.solid),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total Balance",
                      style: TextStyle(
                        color: kPrimaryLightColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Text(
                          "₹ ${dbService.readBalance()}",
                          style: const TextStyle(
                              color: kPrimaryLightColor, fontSize: 30),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryLightColor,
                          ),
                          child: GooglePayButton(
                            paymentConfigurationAsset: 'google_pay.json',
                            paymentItems: _paymentItems,
                            type: GooglePayButtonType.pay,
                            margin: const EdgeInsets.only(top: 15.0),
                            onPaymentResult: (data) {
                              log(data.toString());
                            },
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          // IconButton(
                          //     iconSize: 30,
                          //     onPressed: () {

                          //     },
                          //     icon: const Icon(
                          //       Icons.add,
                          //       color: kPrimaryColor,
                          //     )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      String cameraScanResult =
                          await FlutterBarcodeScanner.scanBarcode(
                              "#6c5971", "Cancel", true, ScanMode.DEFAULT);
                      log(cameraScanResult.toString());
                    },
                    child: DottedBorder(
                      color: kPrimaryDarkColor,
                      dashPattern: const [10, 5],
                      strokeWidth: 2,
                      child: const Padding(
                        padding: EdgeInsets.all(21),
                        child: Icon(
                          Icons.qr_code_2,
                          size: 90,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Row(
                children: const [
                  Spacer(),
                  Text(
                    "Scan QR Code On The Bus",
                    style: TextStyle(color: kPrimaryDarkColor, fontSize: 12),
                  ),
                  Spacer(),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// *#*#4636#*#*