import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CommonLogo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('img/mydiary.png',width:250,),
        "Buat Sebuah List Untuk Pekerjaan Anda".text.black.black.wider.lg.make(),
      ],
    );
  }
}