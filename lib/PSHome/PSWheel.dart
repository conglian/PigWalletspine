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

class PSWheel extends StatefulWidget {
  const PSWheel({super.key});

  @override
  State<PSWheel> createState() => _PSWheelState();
}

class _PSWheelState extends State<PSWheel> with SingleTickerProviderStateMixin {
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
            child: Column(
              children: [
                SizedBox(height: 44.h),
                Consumer<PSLocalProvider>(
                  builder: (context, provider, child) {
                    return // 中心进度条区域
                    Container(
                      width: 349,
                      height: 119,
                      decoration: BoxDecoration(
                        image: PSDImg('ps_t_center_bg'),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: 16,
                            top: 18,
                            child: PSImg(
                              name: 'ps_domand_b',
                              width: 26.7,
                              height: 23.27,
                            ),
                          ),
                          Positioned(
                            left: 48,
                            top: 20,
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w900,
                                  color: '#873709'.color(),
                                  fontFamily: text_fontName,
                                ),
                                children: <TextSpan>[
                                  const TextSpan(text: 'Energy Point: '),
                                  TextSpan(
                                    text: provider.ps_pig_level == 0
                                        ? '20'
                                        : '10',
                                    style: TextStyle(color: '#006AFF'.color()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 30,
                            top: 50,
                            child: SizedBox(
                              width: 292,
                              height: 34,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    width: 292,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      image: PSDImg('ps_pro_bg_t'),
                                    ),
                                  ),
                                  Positioned(
                                    left: 7,
                                    child: Container(
                                      width:
                                          278 *
                                          (provider.ps_pig_level_index /
                                              (provider.ps_pig_level == 0
                                                  ? 20
                                                  : 10)),
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: '#80F207'.color(),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 150,
                            top: 56,
                            child: PSStrokeText(
                              text:
                                  '${provider.ps_pig_level_index}/${provider.ps_pig_level == 0 ? '20' : '10'}',
                              size: 18,
                              color: '#FFFFFF'.color(),
                              weight: FontWeight.w900,
                              skWidth: 1,
                              skColor: '#042267'.color(),
                            ),
                          ),
                          Positioned(
                            left: 200,
                            top: provider.ps_pig_level == 0 ? 58 : 62,
                            child: PSImg(
                              name: provider.ps_pig_level == 0 ? 'ps_domand_s' : 'ps_zhuan_smail',
                              width: provider.ps_pig_level == 0 ? 18 : 13,
                              height: provider.ps_pig_level == 0 ? 17 : 11,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 40,
                            child: PSImg(
                              name: provider.ps_pig_level == 0
                                  ? 'ps_pig_1'
                                  : 'ps_pig_3',
                              width: 47,
                              height: 47,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 40,
                            child: PSImg(
                              name: provider.ps_pig_level == 0
                                  ? 'ps_pig_3'
                                  : 'ps_pig_2',
                              width: 47,
                              height: 47,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 364.w,
                  height: 367.w,
                  decoration: BoxDecoration(image: PSDImg('ps_wheel_wai_iocn')),
                  child: Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: 340.w,
                          height: 340.w,
                          child: PigWheelPage(
                            imagePath: 'ps_wheel_center_iocn'.image(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: (0.width(context) - 47) * 0.48,
                        top: -8,
                        child: PSImg(
                          name: 'ps_wheel_zhi_iocn',
                          width: 47,
                          height: 75,
                        ),
                      ),
                      Center(
                        child: ParticleButton(
                          onTap: () {
                            tapWheel();
                          },
                          child: PSImg(
                            name: 'ps_wheel_spin_iocn',
                            width: 125,
                            height: 125,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> tapWheel() async {
    if (is_tap_wheel) {
      return;
    }
    is_tap_wheel = true;
    if (PSLocalProvider.instance.ps_wheel_number <= 0) {
      context.tipShowAdvanced(PSPopMoreChanceDialog());
      is_tap_wheel = false;
      return;
    }
    await PSLocalProvider.instance.updateint(
      PSLocalProvider.instance.ps_wheel_numberName,
      PSLocalProvider.instance.ps_wheel_number - 1,
    );
    int row = getRandomNumber();
    // 6 不中奖
    WheelStartNotificationService.sendToStartIndexNotification(row);
    if (row != 6) {
      Future.delayed(Duration(milliseconds: 1000), () {
        is_tap_wheel = false;
        if (!mounted) return;
        context.tipShowAdvanced(PSPopDomandAwardADialog());
      });
    } else {
      is_tap_wheel = false;
    }
  }

  int getRandomNumber() {
    final numbers = [2, 5, 4, 8, 6];
    final random = Random();
    return numbers[random.nextInt(numbers.length)];
  }
}
