import 'package:flutter/material.dart';

class ErrorRetryMessage {

  static Widget build(BuildContext context, Function reloadFunc, String errorMessage) {
    errorMessage = errorMessage ?? 'An error has occurred please try again later';

    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Icon(Icons.sentiment_dissatisfied, size: 70),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              child: Text(errorMessage,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            RaisedButton(
              onPressed: reloadFunc,
              child: Text('RETRY'),
            ),
          ],
        ),
      ),
    );
  }
}