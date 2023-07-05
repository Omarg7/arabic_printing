import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:arabic_printing/features/test_printing/presentation/widgets/custom_button.dart';
import 'package:arabic_printing/features/test_printing/presentation/widgets/input_form_field.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart';
import 'package:screenshot/screenshot.dart';
import 'package:string_validator/string_validator.dart';

import '../widgets/printing_design.dart';
  class TestPrintingScreen extends StatefulWidget {
  const TestPrintingScreen({Key? key}) : super(key: key);

  @override
  State<TestPrintingScreen> createState() => _TestPrintingScreenState();
}

class _TestPrintingScreenState extends State<TestPrintingScreen> {
late final TextEditingController printerIP;
late final TextEditingController printerPort;
final _formKey = GlobalKey<FormState>();
late final  ScreenshotController screenshotController;

@override
  void initState() {
  screenshotController=ScreenshotController();
  printerIP=TextEditingController();
  printerPort=TextEditingController(text: '9100');
    super.initState();
  }
Future<void> printOrder( NetworkPrinter printer, Uint8List theimageThatComesfr) async {


    final Image? image = decodeImage(theimageThatComesfr);

    printer.setStyles(PosStyles.defaults(reverse: false));
    printer.imageRaster(
      image!,
      align: PosAlign.center,
    );

    printer.cut();

}
_connectToPrinter(int printerPort,Uint8List theimageThatComesfr,String printerIp) async {
  const PaperSize paper = PaperSize.mm80;
  final profile = await CapabilityProfile.load();
  final printer = NetworkPrinter(paper, profile);
//TODO: Change printer ip and port
  print('inside connection b4 success');
  print(printerIp+printerPort.toString());
  final PosPrintResult res = await printer.connect(
    printerIp,
    port:printerPort,
    timeout: Duration(seconds: 10),
  );

  if (res == PosPrintResult.success) {
    print('inside connection success');
    await printOrder(printer, theimageThatComesfr);

    printer.disconnect();
    print('after disconnect');
  }else{

  }
}
  printTest(String printerIP,int printerPort){
    screenshotController.captureFromWidget(PrepareOrderDesign()).then((image) {
  print(image);
      return _connectToPrinter(printerPort,image,printerIP);
    });
  }

@override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('تهيئة الطباعة',style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.white),),centerTitle: true,backgroundColor: Colors.blueGrey,),
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Center(
              child: Form(key: _formKey,child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomFormField(contentPadding:15,
title: 'IP الطابعة',
                      validator: (value) {
                    if ( printerIP.text.isEmpty  ) {
                      return 'لم يتم تحديد ال IP';
                    }else if(isIP(printerIP.text,4)==false){
                      return 'صيغة ال IP غير صحيحة';
                    }else{
                      return null;
                    }

                  },hintText: 'IP الطابعة', obscureText:false, textEditingController: printerIP, textInputType: TextInputType.text),
                  SizedBox(height: 20,),
                  CustomFormField(contentPadding: 15,
                      title: 'Port الطابعة',
                  hintText: 'Port الطابعة', obscureText:false, textEditingController: printerPort, textInputType: TextInputType.text),
                  SizedBox(height: 20,),
                  CustomElevatedButton(onPressed: (){
      if (_formKey.currentState!.validate()) {

        printTest(printerIP.text,int.tryParse(printerPort.text)??9100);
      }

                  }, text: 'طباعة', width: MediaQuery.of(context).size.width * .8),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
