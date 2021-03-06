import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gogrocy/core/services/navigation_service.dart';
import 'package:gogrocy/service_locator.dart';

final NavigationService _navigationService = locator<NavigationService>();


Widget offlineSnackBar() => Flushbar(
      messageText: Text(
        "No Internet",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      isDismissible: false,
      icon: Icon(
        Icons.error,
        color: Colors.red,
      ),
      barBlur: 0.9,
      margin: EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 0.0),
          blurRadius: 5.0,
        )
      ],
    );

Widget onlineSnackBar() => Flushbar(
      messageText: Text(
        "Back Online",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 2),
      icon: Icon(
        Icons.check_circle,
        color: Colors.green,
      ),
      barBlur: 0.9,
      margin: EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 0.0),
          blurRadius: 5.0,
        )
      ],
    );

Widget infoSnackBar(
    {@required String message,
    @required IconData iconData,
    @required iconColor,
    @required bool goToCart}) {
  return Flushbar(
      messageText: Text(
        message,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      duration: Duration(seconds: 2),
      flushbarStyle: FlushbarStyle.FLOATING,
      icon: Icon(
        iconData,
        color: iconColor,
      ),
      barBlur: 0.9,
      margin: EdgeInsets.all(8.0),
      borderRadius: 8.0,
      backgroundColor: Colors.white,
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 0.0),
          blurRadius: 5.0,
        )
      ],
      mainButton: goToCart
          ? FlatButton(
              onPressed: () {
                _navigationService.pushCart();
              },
              child: Text("Go to cart", style: TextStyle(color: Colors.green)),
            )
          : FlatButton());
}
