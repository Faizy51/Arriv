import 'dart:io';
import 'package:Arriv/models/wallet.dart';
import 'package:Arriv/views/CustomBoxShadow.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../constants.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({
    Key key,
    @required this.userWallet,
  }) : super(key: key);

  final Wallet userWallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: QRCODE_DIMENSION,
      width: QRCODE_DIMENSION,
      // margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(
            width: 6,
            color: purple,
          ),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            // HACK: solve ios black patch issue
            Platform.isAndroid
                ? CustomBoxShadow(
                    color: Colors.black.withOpacity(1),
                    blurRadius: 5.0,
                    blurStyle: BlurStyle.outer)
                : BoxShadow(
                    color: Colors.white,
                  ),
          ]),
      child: Center(
        child: RepaintBoundary(
          // key: globalKey,
          child: QrImage(
            data: "${userWallet.walletId}",
            size: QRCODE_DIMENSION,
            version: QrVersions.auto,
          ),
        ),
      ),
    );
  }
}
