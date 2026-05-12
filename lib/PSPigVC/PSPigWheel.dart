import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSTool/PigWheelPage.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:provider/provider.dart';
import '../PSBase/PSTbaBar.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSTool/PSNumberHelpers.dart';
import '../PSTool/ps_GradientNumber.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';
import 'PSPigCash.dart';
import 'PSPigHome.dart';

class PSPigWheel extends StatefulWidget {
  const PSPigWheel({super.key});

  @override
  State<PSPigWheel> createState() => _PSPigWheelState();
}

class _PSPigWheelState extends State<PSPigWheel> with SingleTickerProviderStateMixin {
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
            decoration: BoxDecoration(image: PSDImg('ps_wheel_bg2')),
            child: Column(
              children: [
                SizedBox(height: 44.h),
                Consumer<PSLocalProvider>(
                    builder: (context, provider, child) {
                      if (provider.ps_pig_level == 0) {
                        return PigblancePage();
                      } else {
                        return PigblancePage2();
                      }
                    }
                ),
                SizedBox(height: 20.h),
                Container(
                  width: 364.w,
                  height: 367.w,
                  decoration: BoxDecoration(image: PSDImg('ps_wheel_wai_iocn')),
                  child: Stack(
                    children: [
                      Consumer<PSLocalProvider>(
                        builder: (context, provider, child) {
                          return Center(
                            child: SizedBox(
                              width: 340.w,
                              height: 340.w,
                              child: PigWheelPage(
                                imagePath: 'ps_wheel_center_bg0',
                              ),
                            ),
                          );
                        },
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
                      Consumer<PSLocalProvider>(
                        builder: (context, provider, child) {
                          return Center(
                            child: ParticleButton(
                              onTap: () {
                                tapWheel();
                              },
                              child: Container(
                                width: 125,
                                height: 125,
                                decoration: BoxDecoration(
                                    image: PSDImg('ps_wheel_spin_iocn')
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      right: 20,
                                      top: 10,
                                      child: Container(
                                        width: 27,
                                        height: 27,
                                        decoration: BoxDecoration(
                                            image: PSDImg('ps_wheel_number_bg')
                                        ),
                                        child: Center(
                                          child: PSStrokeText(text: '${provider.ps_wheel_number}', size: 12, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#085F1D'.color()),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(right: 20.w,top: 160.h,child: ParticleButton(child: PSBouncyImage(
               imagePath: 'ps_quzi_btn_pop',
               width: 69,
               height: 66,
               enableAnimation: true,
            ), onTap: (){
            PigTabController.switchTo(1);
          }))
        ],
      ),
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

  Future<void> tapWheel() async {
    if (is_tap_wheel) {
      return;
    }
    is_tap_wheel = true;
    if (PSLocalProvider.instance.ps_wheel_number <= 0) {
      context.tipShowAdvanced(PSPopWheelOldDog());
      is_tap_wheel = false;
      return;
    }
    await setTxProgress();
    await PSLocalProvider.instance.updateint(
      PSLocalProvider.instance.ps_wheel_numberName,
      PSLocalProvider.instance.ps_wheel_number - 1,
    );
    int row = getRandomNumber();
    // 6 不中奖
    if (PSLocalProvider.instance.ps_pig_level == 0) {
      WheelStartNotificationService.sendToStartIndexNotification(3);
    } else {
      WheelStartNotificationService.sendToStartIndexNotification(4);
    }
    // if (row != 6) {
      Future.delayed(Duration(milliseconds: 1000), () async {
        is_tap_wheel = false;
        if (!mounted) return;
        if (PSLocalProvider.instance.ps_pig_level == 0) {
          int code = await context.tipShow(PSPopAwardToolDialog(type: .wheel, isGuide: false, award: PSNumberHelpers().getPrizeWithWheelNum()));
          // 到达80%提现确认
          if (code >= 0 && PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first * 0.8 && PSLocalProvider.instance.ps_show_80_pop == false) {
            context.tipShow(PSAboutTXDialog(isConfim: true));
            PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_show_80_popName, true);
          }
        } else {
          int code = await context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .wheel, is_rv: false, award: PSNumberHelpers().getPrizeWithDomandGoldNum(), is_wheel: false));
          // 到达80%提现确认
          if (code >= 0 && PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first * 0.8 && PSLocalProvider.instance.ps_show_80_pop == false) {
            context.tipShow(PSAboutTXDialog(isConfim: true));
            PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_show_80_popName, true);
          }
        }
      });
    // }
    // else {
    //   is_tap_wheel = false;
    // }
  }

  int getRandomNumber() {
    final numbers = [2, 5, 4, 8, 6];
    final random = Random();
    return numbers[random.nextInt(numbers.length)];
  }

  Future<void> setTxProgress() async {
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, PSLocalProvider.instance.ps_tx_wheel_index + 1);
    if (PSLocalProvider.instance.ps_tx_wheel_index >= PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data) {
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, PSLocalProvider.instance.ps_tx_task_index + 1);
      // 重置任务
      if (PSLocalProvider.instance.ps_tx_task_index >= PSNumberHelpers().intModel!.tixianTask.length){
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, 0);
      }
    }
    PSPigCashNotificationService.sendToQuizProgressNotification(0);
  }
}
