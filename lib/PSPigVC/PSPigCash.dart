import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSTool/PigWheelPage.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:provider/provider.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';

class PSPigCash extends StatefulWidget {
  const PSPigCash({super.key});

  @override
  State<PSPigCash> createState() => _PSPigCashState();
}

class _PSPigCashState extends State<PSPigCash> with SingleTickerProviderStateMixin {
  bool is_tap_wheel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 0.width(context),
            height: 0.height(context),
            decoration: BoxDecoration(image: PSDImg('ps_wheel_bg')),
          ),
        ],
      ),
    );
  }

}
