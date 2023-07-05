import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import 'package:screenshot/screenshot.dart';



class PrepareOrderDesign extends StatelessWidget {
  PrepareOrderDesign({Key? key,}) : super(key: key);
  ScreenshotController screenshotController = ScreenshotController();



  TextStyle headText = const TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight:   FontWeight.bold,
  );
  TextStyle bodyText = const TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Container(color: Colors.black,
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Center(child: FittedBox(fit: BoxFit.scaleDown,child: Text('تجربة الطباعة باللغة العربية',style: headText,))),


            ],
          ),
        )
    );
  }
}
