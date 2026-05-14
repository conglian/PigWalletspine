import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/PigWheelPage.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:provider/provider.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSTool/ps_GradientNumber.dart';
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

  int atc_selecd_index = PSLocalProvider.instance.ps_tx_ing_account;

  List<int> tx_list = PSNumberHelpers().intModel!.eqRange;
  // 每个 cell 高度数组
  List<double> cellHeights = [PSLocalProvider.instance.ps_tx_ing_number == 0 && PSLocalProvider.instance.ps_pig_level >= 1 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 1 && PSLocalProvider.instance.ps_pig_level >= 1  ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 2 && PSLocalProvider.instance.ps_pig_level >= 1  ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 3 && PSLocalProvider.instance.ps_pig_level >= 1  ? 159 : 78];

  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    // Subscribe to the stream
    _subscription = PSPigCashNotificationService.stream.listen((value) {
      if (!mounted) return; // <-- make sure widget is still in tree
      setState(() {
        cellHeights = [
          PSLocalProvider.instance.ps_tx_ing_number == 0 &&
              PSLocalProvider.instance.ps_pig_level >= 1
              ? 159
              : 78,
          PSLocalProvider.instance.ps_tx_ing_number == 1 &&
              PSLocalProvider.instance.ps_pig_level >= 1
              ? 159
              : 78,
          PSLocalProvider.instance.ps_tx_ing_number == 2 &&
              PSLocalProvider.instance.ps_pig_level >= 1
              ? 159
              : 78,
          PSLocalProvider.instance.ps_tx_ing_number == 3 &&
              PSLocalProvider.instance.ps_pig_level >= 1
              ? 159
              : 78
        ];
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        atc_selecd_index = PSLocalProvider.instance.ps_tx_ing_account;
      });
    });

  }

  @override
  void dispose() {
    _subscription.cancel(); // <-- important to prevent memory leaks
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
            decoration: BoxDecoration(image: PSDImg('ps_cash_bg')),
            child: Column(
              children: [
                SizedBox(height: 48.h),
                Consumer<PSLocalProvider>(
                    builder: (context, provider, child) {
                       return Container(
                         width: 349,
                         height: 164,
                         decoration: BoxDecoration(
                             image: PSDImg('ps_cash_top_wtd')
                         ),
                         child: Stack(
                           children: [
                             Positioned(
                               left: 24,
                               top: 34,
                               child: RichText(
                                 textAlign: TextAlign.center,
                                 text: TextSpan(
                                   style: TextStyle(
                                       fontSize: 12.0,
                                       fontWeight: FontWeight.w500,
                                       fontFamily: 'Black_mianfeiziti',
                                       color: '#873709'.color()
                                   ),
                                   children: <TextSpan>[
                                     TextSpan(
                                       text: 'My Account: ',
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             Positioned(
                                 left: 104,
                                 top: 30,child: PSGradientNumberRoller(
                               value: provider.ps_dolas_number,
                               duration: 800,
                               fontSize: 14.0,
                               gradientColors: ['#0BA408'.color(), '#0BA408'.color()],
                               borderColor: Colors.transparent,
                               borderWidth: 0.0,
                               decimalPlaces: 2,
                             )),
                             Positioned(right: 22,top: 18,child: PSImg(name: 'ps_cash_tip', width: 126, height: 32)),
                             Positioned(
                               left: 30,
                               top: 52,
                               child: SizedBox(
                                 width: 292,
                                 height: 30,
                                 child: Stack(
                                   alignment: Alignment.centerLeft,
                                   children: [
                                     Container(
                                       width: 292,
                                       height: 30,
                                       decoration: BoxDecoration(image: PSDImg('ps_pro_bg_t')),
                                     ),
                                     Positioned(
                                       left: 7,
                                       child: Container(
                                         width: 278 * (provider.ps_dolas_number / 100), // Use provider data
                                         height: 18,
                                         decoration: BoxDecoration(
                                           color: '#39B101'.color(),
                                           borderRadius: BorderRadius.circular(10),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             Positioned(
                               right: 20,
                               top: 50,
                               child: Container(
                                 width: 39,
                                 height: 29,
                                 decoration: BoxDecoration(image: PSDImg('ps_dolas_1')),
                                 child: Column(
                                   children: [
                                     Spacer(),
                                     PSStrokeText(
                                       text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}', // Static or dynamic value based on provider data
                                       size: 12,
                                       color: '#FFE711'.color(),
                                       weight: FontWeight.w900,
                                       skWidth: 1,
                                       skColor: '#04226'.color(),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                             Positioned(
                               bottom: 60.5,
                               left: 32,
                               child: Stack(
                                 children: [
                                   // 👇 First Layer: Stroke
                                   RichText(
                                     textAlign: TextAlign.center,
                                     text: TextSpan(
                                       style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         fontFamily: 'Black_mianfeiziti',
                                         foreground: Paint()
                                           ..style = PaintingStyle.stroke
                                           ..strokeWidth = 1
                                           ..color = '#042267'.color(),
                                       ),
                                       children: [
                                         TextSpan(text: 'Only '),
                                         TextSpan(text: '${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first ? 0 : PSNumberHelpers().intModel!.eqRange.first - provider.ps_dolas_number)}'), // Static or dynamic based on provider
                                         TextSpan(text: ' Left To Withdraw '),
                                         TextSpan(text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}'), // Static or dynamic based on provider
                                       ],
                                     ),
                                   ),
                                   // 👇 Second Layer: Normal Fill
                                   RichText(
                                     textAlign: TextAlign.center,
                                     text: TextSpan(
                                       style: TextStyle(
                                         fontSize: 12,
                                         fontWeight: FontWeight.w500,
                                         fontFamily: 'Black_mianfeiziti',
                                         color: '#FFFFFF'.color(),
                                       ),
                                       children: [
                                         TextSpan(text: 'Only '),
                                         TextSpan(
                                           text: '${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first ? 0 : PSNumberHelpers().intModel!.eqRange.first - provider.ps_dolas_number)}', // Static or dynamic based on provider
                                           style: TextStyle(color: '#FFE711'.color(), fontSize: 12),
                                         ),
                                         TextSpan(text: ' Left To Withdraw '),
                                         TextSpan(
                                           text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}', // Static or dynamic based on provider
                                           style: TextStyle(color: '#FFE711'.color(), fontSize: 12),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                             Positioned(left: (0.width(context) - 172) * 0.5,bottom: 24,child: ParticleButton(
                               onTap: (){
                                 if (PSLocalProvider.instance.ps_dolas_number < PSNumberHelpers().intModel!.eqRange.first){
                                   context.tipShow(PSTXOutDialog(seletcd_row: atc_selecd_index));
                                 } else if (PSLocalProvider.instance.ps_pig_level == 1){
                                   context.tipShow(PSReviewingDialog());
                                 } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
                                   context.tipShow(PSGuide4Dialog());
                                 } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
                                   context.tipShow(PSTXRankDialog());
                                 } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
                                   context.tipShow(PSTXLastDialog(type: PSLocalProvider.instance.ps_tx_task_index));
                                 }

                               },
                               child: Container(
                                 width: 172,
                                 height: 34,
                                 decoration: BoxDecoration(
                                     image: PSDImg('ps_wtd_btn')
                                 ),
                                 child: Center(
                                   child: PSStrokeText(text: 'Cash Out', size: 12, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#025003'.color()),
                                 ),
                               ),
                             ),
                             )
                           ],
                         ),
                       );
                    }
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    ParticleButton(child: Container(
                      width: 153,
                      height: 58,
                      decoration: BoxDecoration(
                        image: PSDImg('ps_act_${0}${isBrazilianPortuguese(context) == true ? 'pt' : ''}'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: atc_selecd_index == 0 ? '#0077B3'.color() : Colors.transparent
                        )
                      ),
                    ), onTap: (){
                       setState(() {
                         atc_selecd_index  = 0;
                         if (PSLocalProvider.instance.ps_tx_ing_account == 0 && PSLocalProvider.instance.ps_pig_level >= 1) {
                           cellHeights = [PSLocalProvider.instance.ps_tx_ing_number == 0 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 1 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 2 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 3 ? 159 : 78];
                         } else {
                           cellHeights = [78, 78, 78, 78];
                         }
                       });
                    }),
                    SizedBox(width: 13.w),
                    ParticleButton(child: Container(
                      width: 153,
                      height: 58,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_act_${1}${isBrazilianPortuguese(context) == true ? 'pt' : ''}'),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: atc_selecd_index == 1 ? '#0077B3'.color() : Colors.transparent
                          )
                      ),
                    ), onTap: (){
                      setState(() {
                        atc_selecd_index  = 1;
                        if (PSLocalProvider.instance.ps_tx_ing_account == 1 && PSLocalProvider.instance.ps_pig_level >= 1) {
                          cellHeights = [PSLocalProvider.instance.ps_tx_ing_number == 0 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 1 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 2 ? 159 : 78, PSLocalProvider.instance.ps_tx_ing_number == 3 ? 159 : 78];
                        } else {
                          cellHeights = [78, 78, 78, 78];
                        }
                      });
                    }),
                  ],
                ),
                SizedBox(height: 17.h),
                PSText(text: 'Choose Withdraw Amount', size: 14, color: '#3B5588'.color(), weight: FontWeight.w900),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 370.h,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: cellHeights.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: cellHeights[index],
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: getCashListtype(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(left: 28.w,top: 44.h,child: PSImg(name: 'ps_act_cash_${PSLocalProvider.instance.ps_account_seled_index}${isBrazilianPortuguese(context) == true ? 'pt' : ''}', width: 136, height: 33)),
        ]
       )
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }


  Widget getCashListtype(int row) {
    if (row == PSLocalProvider.instance.ps_tx_ing_number && PSLocalProvider.instance.ps_tx_ing_account == atc_selecd_index && PSLocalProvider.instance.ps_pig_level >= 1){
      return getCashTypeTwo(row);
    } else {
      return getCashTypeOne(row);
    }
  }

  Widget getCashTypeTwo(int row){
    return Container(
      width: 333,
      height: 142,
      decoration: BoxDecoration(
        image: PSDImg('ps_cash_bg_1')
      ),
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 11),
              Row(
                children: [
                  SizedBox(width: 14),
                  PSText(text: '${0.dolasType()}${tx_list[row]}', size: 32, color: '#0BA408'.color(), weight: FontWeight.w900),
                  Spacer(),
                  Visibility(
                    visible: PSLocalProvider.instance.ps_current_ranking != 1,
                    child: ParticleButton(
                      child: Container(
                        width: 111,
                        height: 28,
                        decoration: BoxDecoration(
                            image: PSDImg(getCashbtnName(row))
                        ),
                      ),
                      onTap: (){
                        if (PSLocalProvider.instance.ps_dolas_number < PSNumberHelpers().intModel!.eqRange.first){
                          context.tipShow(PSTXOutDialog(seletcd_row: atc_selecd_index));
                        } else if (PSLocalProvider.instance.ps_pig_level == 1){
                          context.tipShow(PSReviewingDialog());
                        } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
                          context.tipShow(PSGuide4Dialog());
                        } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
                          context.tipShow(PSTXRankDialog());
                        } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
                          context.tipShow(PSTXLastDialog(type: PSLocalProvider.instance.ps_tx_task_index));
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 14),
                ],
              ),
              SizedBox(height: 9),
              PSText(text: 'Security Check In Progress To Protect Your Payout', size: 12, color: '#AF7C1E'.color(), weight: FontWeight.w900),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 16),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Black_mianfeiziti',
                          color: '#733A1B'.color()
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Verification task：',
                        ),
                        TextSpan(
                          text: getTaskString(),
                          style: TextStyle(color: '#104AC5'.color(), fontSize: 12),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: .center,
                children: [
                  Container(
                    width: 189,
                    height: 23,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_cash_pro_bg')
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 4,
                          left: 5,
                          child: Container(
                            width: 179 * getTaskProgress(),
                            height: 11,
                            decoration: BoxDecoration(
                              color: '#E6F207'.color(),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5,
                          left: (189 - 45) * 0.55,
                          child: PSStrokeText(text: getTaskSize(), size: 10, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#084207'.color(), align: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  ParticleButton(child: Container(
                    width: 98,
                    height: 28,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_cah_green_s')
                    ),
                    child: Center(
                      child: PSStrokeText(text: 'Go', size: 12, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#025003'.color()),
                    ),
                  ), onTap: (){
                    if (PSLocalProvider.instance.ps_pig_level == 1){
                      PigTabController.switchTo(Random().nextInt(2) + 1);
                    } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
                      PigTabController.switchTo(Random().nextInt(2) + 1);
                    } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
                      context.tipShow(PSTXRankDialog());
                    } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
                      context.tipShow(PSTXLastDialog(type: PSLocalProvider.instance.ps_tx_task_index));
                    }

                  })
                ],
              )
            ],
          ),
          // Positioned(right: 6,bottom: 34,child: PSImg(name: 'ps_ad_icon', width: 27, height: 29))
        ],
      )
    );
  }

  String getCashbtnName(int row){
    if (PSLocalProvider.instance.ps_pig_level == 1){
      return 'ps_unlock_payout';
    } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
      return 'ps_pro_btn';
    } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_show_rank && PSLocalProvider.instance.ps_current_ranking != 1) {
      return 'ps_inqueue_btn';
    }
    return 'ps_unlock_payout';
  }

  String getTaskSize(){
    if (PSLocalProvider.instance.ps_pig_level == 1){
      return '${0.to2Double(PSLocalProvider.instance.ps_pig_level_index)}/20';
    } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
      return '${0.to2Double(PSLocalProvider.instance.ps_pig_level_index)}/10';
    } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
      return '${PSLocalProvider.instance.ps_current_ranking}/${PSLocalProvider.instance.ps_all_ranking}';
    } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
      if (PSLocalProvider.instance.ps_tx_task_index == 0){
        return '${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 1){
        return '${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 2){
        return '${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 3){
        return '${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 4){
        return '${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 5){
        return '${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 6){
        return '${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 7){
        return '${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 8){
        return '${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data}';
      }
    }
    return '';
  }

  double getTaskProgress(){
    if (PSLocalProvider.instance.ps_pig_level == 1){
      return PSLocalProvider.instance.ps_pig_level_index / 20;
    } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
      return PSLocalProvider.instance.ps_pig_level_index / 10;
    } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
      return PSLocalProvider.instance.ps_current_ranking / PSLocalProvider.instance.ps_current_ranking;
    } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
      if (PSLocalProvider.instance.ps_tx_task_index == 0){
        return PSLocalProvider.instance.ps_tx_quiz_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 1){
        return PSLocalProvider.instance.ps_tx_wheel_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 2){
        return PSLocalProvider.instance.ps_tx_bubble_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 3){
        return PSLocalProvider.instance.ps_tx_quiz_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 4){
        return PSLocalProvider.instance.ps_tx_wheel_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 5){
        return PSLocalProvider.instance.ps_tx_bubble_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 6){
        return PSLocalProvider.instance.ps_tx_quiz_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 7){
        return PSLocalProvider.instance.ps_tx_wheel_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      } else if (PSLocalProvider.instance.ps_tx_task_index == 8){
        return PSLocalProvider.instance.ps_tx_bubble_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      }
    }
    return 0;
  }

  String getTaskString(){
    if (PSLocalProvider.instance.ps_pig_level == 1){
      return 'Collect 20 diamonds.';
    } else if (PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_tx_ing_status == false) {
      return 'Collect 10 Gold Bricks.';
    } else if (PSLocalProvider.instance.ps_pig_level_index >= 10 && PSLocalProvider.instance.ps_pig_level == 2 && PSLocalProvider.instance.ps_current_ranking != 1) {
      return 'Queued all the way to the front';
    } else if (PSLocalProvider.instance.ps_current_ranking <= 1) {
      if (PSLocalProvider.instance.ps_tx_task_index == 0){
        return 'Answer ${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Question Right';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 1){
        return 'Spin ${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Times';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 2){
        return 'Watch ${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Ad Video';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 3){
        return 'Answer ${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Question Right';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 4){
        return 'Spin ${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Times';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 5){
        return 'Watch ${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Ad Video';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 6){
        return 'Answer ${PSLocalProvider.instance.ps_tx_quiz_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Question Right';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 7){
        return 'Spin ${PSLocalProvider.instance.ps_tx_wheel_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Times';
      } else if (PSLocalProvider.instance.ps_tx_task_index == 8){
        return 'Watch ${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Ad Video';
      }
    }
    return '';
  }

  Widget getCashTypeOne(int row){
    return Container(
      width: 331,
      height: 61,
      decoration: BoxDecoration(
        image: PSDImg('ps_cash_bg_0')
      ),
      child: Row(
        children: [
          SizedBox(width: 14),
          PSText(text: '${0.dolasType()}${tx_list[row]}', size: 32, color: '#0BA408'.color(), weight: FontWeight.w900),          Spacer(),
          ParticleButton(
            child: Container(
              width: 115,
              height: 36,
              decoration: BoxDecoration(
                image: PSDImg('ps_cah_green_b')
              ),
              child: PSStrokeText(text: 'Withdraw', size: 12, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#025003'.color()),
            ),
            onTap: (){
              if (PSLocalProvider.instance.ps_tx_ing_status == true) {
                PSDialogTool.toast(context, 'Withdrawal in progress—hurry up and complete the tasks!');
              } else {
                if (PSLocalProvider.instance.ps_dolas_number < PSNumberHelpers().intModel!.eqRange[row]){
                  context.tipShow(PSTXOutDialog(seletcd_row: row));
                } else {
                  if (PSLocalProvider.instance.ps_pig_level == 1){
                    PSDialogTool.toast(context, 'Collect 20 Diamonds to complete the withdrawal.');
                  } else {
                    PSDialogTool.toast(context, 'Collect 10 Gold Bricks to complete the withdrawal.');
                  }
                }
              }
            },
          ),
          SizedBox(width: 14),
        ],
      ),
    );
  }

}


class PSPigCashNotificationService {
  static final StreamController<int> _streamController =
  StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToQuizProgressNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}