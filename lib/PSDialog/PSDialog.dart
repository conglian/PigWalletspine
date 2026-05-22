import 'dart:async';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart' hide Size;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_GradientNumber.dart';
import 'package:piggywalletspinearn/PSTool/ps_GradientText.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:provider/provider.dart';
import 'package:spine_flutter/spine_widget.dart' as spine;
import '../PSPigVC/PSPigCash.dart';
import '../PSTool/PSAdAManger.dart';
import '../PSTool/PSMarqueeText.dart';
import '../PSTool/PSRankData.dart';
import '../PSTool/PSTBAEventTool.dart';
import '../PSTool/ps_LocalProvider.dart';
import '../PSTool/ps_extension_help.dart';
import 'PSGuideDialog.dart';

enum AdStatus {
  adLoadfaild,
  notWifi,
  adLimit,
  noticeOpen,
  notWheel
}

enum AwardType {
  quiz,
  wheel,
  other,
  apple,
  buble
}
// 信息确认
class PSConfirmInformationDialog extends StatefulWidget {
  const PSConfirmInformationDialog({super.key});

  @override
  State<PSConfirmInformationDialog> createState() => PSConfirmInformationDialogState();
}

class PSConfirmInformationDialogState extends State<PSConfirmInformationDialog>
    with SingleTickerProviderStateMixin {
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
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 309.w,
          height: 341.h,
          decoration: BoxDecoration(
            image: PSDImg('ps_confim_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 22.h),
              PSText(text: 'Confirm payment Information', size: 18, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 28.h),
              Container(
                width: 283.w,
                height: 123.h,
                decoration: BoxDecoration(
                  image: PSDImg('ps_confim_center_bg')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 33.h),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        PSText(text: 'Account Name：${PSLocalProvider.instance.ps_account_id}', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        PSText(text: 'Payment Method:', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                        SizedBox(width: 14.w),
                        PSImg(name: 'ps_act_${PSLocalProvider.instance.ps_tx_ing_account}${isBrazilianPortuguese(context) == true ? 'pt' : ''}', width: 116, height: 40)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 27.h),
              Row(
                children: [
                  SizedBox(width: 8.w),
                  PSImg(name: 'ps_Sectiy_icon', width: 29, height: 29),
                  SizedBox(width: 5.w),
                  PSText(text: 'We’ll only use this for sending your withdrawal', size: 10, color: '#566D7E'.color(), weight: FontWeight.w900)
                ],
              ),
              SizedBox(height: 10.h),
              ParticleButton(
                onTap: (){
                   Navigator.pop(context);
                   ps_event_fire('confirm_account_toast', {});
                   context.tipShow(PSConfimOneDialog(isConfim: true, contentStr: 'Payout details confirmed.\nQuiz to release your ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} cash out.',));
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: '#0E79C6'.color(),
                    borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Apply For Payout', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              Navigator.pop(context, 0);
              context.tipShow(PSConfimOneDialog(isConfim: true, contentStr: 'Payout details confirmed.\nQuiz to release your ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} cash out.',));
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

}
// 准备提现
class PSAboutTXDialog extends StatefulWidget {
  final bool isConfim;
  const PSAboutTXDialog({super.key, required this.isConfim});

  @override
  State<PSAboutTXDialog> createState() => PSAboutTXDialogState();
}

class PSAboutTXDialogState extends State<PSAboutTXDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('process_confirm_account_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        SizedBox(width: 292, height: 52,
          child: RichText(
            textAlign: TextAlign.center,
            maxLines: 2,
            text: TextSpan(
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w900,
                color: '#FFFFFF'.color(),
                fontFamily: 'Black_mianfeiziti',
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Congratulations! ',
                  style: TextStyle(color: '#F3B307'.color()),
                ),
                TextSpan(text: "You're About To Withdraw ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}! "),
              ],
            ),
          ),
        ),
        SizedBox(height: 19),
        Container(
          width: 309.w,
          height: 296.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_about_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              PSText(text: 'Pending Balance', size: 24, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 20.h),
              Container(
                width: 167.w,
                height: 103.h,
                decoration: BoxDecoration(
                    image: PSDImg('ps_act_bg_0')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 26.h),
              ParticleButton(
                onTap: (){
                  Navigator.pop(context, 0);
                  ps_event_fire('process_confirm_account_pop_c', {'type' : PSLocalProvider.instance.ps_account_id.length <= 0 ? 'no' : 'yes'});
                  if (PSLocalProvider.instance.ps_account_id.length != 0){
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => PSConfirmInformationDialog(),
                        )
                    );
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (_) => PSInfoSubmitDialog(),
                        )
                    );
                  }
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Confirm Account', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              Navigator.pop(context, 0);
              if (PSLocalProvider.instance.ps_account_id.length != 0){
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => PSConfirmInformationDialog(),
                    )
                );
              } else {
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (_) => PSInfoSubmitDialog(),
                    )
                );
              }
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}

// 信息提交确认
class PSInfoSubmitDialog extends StatefulWidget {
  const PSInfoSubmitDialog({super.key});

  @override
  State<PSInfoSubmitDialog> createState() => PSInfoSubmitDialogState();
}

class PSInfoSubmitDialogState extends State<PSInfoSubmitDialog>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  var seletecd = 0;
  @override
  void initState() {
    super.initState();
    setState(() {
      seletecd = PSLocalProvider.instance.ps_tx_ing_account;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsetsGeometry.only(left: (0.width(context) - 317.w) * 0.5),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            Container(
              width: 317.w,
              height: 422.h,
              decoration: BoxDecoration(
                  image: PSDImg('ps_tx_info_bg')
              ),
              child: Column(
                children: [
                  SizedBox(height: 22.h),
                  PSText(text: 'Confirm payment Information', size: 18, color: '#264077'.color(), weight: FontWeight.w900),
                  SizedBox(height: 35.h),
                  Row(
                    children: [
                      SizedBox(width: 24.w),
                      PSText(text: 'Payment Method:', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      SizedBox(width: 28.w),
                      ParticleButton(
                        onTap: (){
                          setState(() {
                            seletecd = 0;
                            PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_ing_accountName, 0);
                          });
                        },
                        child: Container(
                          width: 116.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                              image: PSDImg('ps_act_0${isBrazilianPortuguese(context) == true ? 'pt' : ''}'),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                width: 1,
                                color: seletecd == 0 ? Colors.cyan : Colors.transparent
                              )
                          ),
                        ),
                      ),
                      SizedBox(width: 22.w),
                      ParticleButton(
                        onTap: (){
                          setState(() {
                            seletecd = 1;
                            PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_ing_accountName, 1);
                          });
                        },
                        child: Container(
                          width: 116.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                              image: PSDImg('ps_act_1${isBrazilianPortuguese(context) == true ? 'pt' : ''}'),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                 width: 1,
                                 color: seletecd == 1 ? Colors.cyan : Colors.transparent
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 22.h),
                  Row(
                    children: [
                      SizedBox(width: 24.w),
                      PSText(text: 'Email/Phone number:', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: 259.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: '#F0F8FA'.color(),
                      borderRadius: BorderRadius.circular(8.h),
                      border: Border.all(
                        color: '#ACC4C8'.color(),  // 边框颜色
                        width: 1,            // 边框宽度
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Please Input Your Account ID', // 占位符文案
                        hintStyle: TextStyle(
                          color: Color(0xFF949DA2), // 占位符文案颜色
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold
                        ),
                        border: InputBorder.none, // 移除默认边框
                      ),
                      style: TextStyle(
                        color: Color(0xFF000000), // 输入文字颜色
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 33.h),
                  Row(
                    children: [
                      SizedBox(width: 10.w),
                      PSImg(name: 'ps_Sectiy_icon', width: 29, height: 29),
                      SizedBox(width: 5.w),
                      PSText(text: 'We’ll only use this for sending your withdrawal', size: 10, color: '#566D7E'.color(), weight: FontWeight.w900)
                    ],
                  ),
                  SizedBox(height: 19.h),
                  ParticleButton(
                    onTap: (){
                      if (_controller.text.length <= 0){
                        PSDialogTool.toast(context, 'Please input your account ID');
                      } else {
                        Navigator.pop(context);
                        context.tipShow(PSConfimOneDialog(isConfim: true, contentStr: 'Payout details confirmed.\nQuiz to release your ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} cash out.',));
                      }
                    },
                    child: Container(
                      width: 239.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: '#0E79C6'.color(),
                          borderRadius: BorderRadius.circular(25.h)
                      ),
                      child: Center(
                        child: PSText(text: 'Apply For Payout', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: 40,
              height: 40,
              child: ParticleButton(
                onTap: (){
                  Navigator.pop(context, 0);
                },
                child: Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_whine_close')
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

}

// 答题排行榜1
class PSQuizRankOneDialog extends StatefulWidget {
  const PSQuizRankOneDialog({super.key});

  @override
  State<PSQuizRankOneDialog> createState() => PSQuizRankOneDialogState();
}

class PSQuizRankOneDialogState extends State<PSQuizRankOneDialog>
    with SingleTickerProviderStateMixin {
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
    return Column(
      mainAxisAlignment: .center,
      children: [
        PSImg(name: 'ps_rank_top', width: 328.w, height: 66),
        SizedBox(height: 30.h),
        Container(
          width: 336.w,
          height: 70.h,
          decoration: BoxDecoration(
            image: PSDImg('ps_rank_list')
          ),
          child: Row(
            children: [
              SizedBox(width: 18.w),
              PSImg(name: 'ps_user_icon_0', width: 49, height: 49),
              SizedBox(width: 12.w),
              PSText(text: '12***22.@gamial', size: 12, color: '#733A1B'.color(), weight: FontWeight.w900),
              SizedBox(width: 24.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#733A1B'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Answer ',
                    ),
                    TextSpan(
                      text: '20 ',
                      style: TextStyle(color: '#0A8A33'.color()),
                    ),
                    TextSpan(
                      text: 'right',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        Container(
          width: 336.w,
          height: 70.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_rank_list')
          ),
          child: Row(
            children: [
              SizedBox(width: 18.w),
              PSImg(name: 'ps_user_icon_0', width: 49, height: 49),
              SizedBox(width: 12.w),
              PSText(text: '12***22.@gamial', size: 12, color: '#733A1B'.color(), weight: FontWeight.w900),
              SizedBox(width: 24.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#733A1B'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Answer ',
                    ),
                    TextSpan(
                      text: '20 ',
                      style: TextStyle(color: '#0A8A33'.color()),
                    ),
                    TextSpan(
                      text: 'right',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 336.w,
          height: 70.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_rank_list')
          ),
          child: Row(
            children: [
              SizedBox(width: 18.w),
              PSImg(name: 'ps_user_icon_0', width: 49, height: 49),
              SizedBox(width: 12.w),
              PSText(text: '12***22.@gamial', size: 12, color: '#733A1B'.color(), weight: FontWeight.w900),
              SizedBox(width: 24.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#733A1B'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Answer ',
                    ),
                    TextSpan(
                      text: '20 ',
                      style: TextStyle(color: '#0A8A33'.color()),
                    ),
                    TextSpan(
                      text: 'right',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          width: 336.w,
          height: 70.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_rank_list')
          ),
          child: Row(
            children: [
              SizedBox(width: 18.w),
              PSImg(name: 'ps_user_icon_0', width: 49, height: 49),
              SizedBox(width: 12.w),
              PSText(text: '12***22.@gamial', size: 12, color: '#733A1B'.color(), weight: FontWeight.w900),
              SizedBox(width: 24.w),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#733A1B'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Answer ',
                    ),
                    TextSpan(
                      text: '20 ',
                      style: TextStyle(color: '#0A8A33'.color()),
                    ),
                    TextSpan(
                      text: 'right',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              Navigator.pop(context, 0);
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}

// 答题排行榜2
class PSQuizRankTwoDialog extends StatefulWidget {
  final int quiz_num;
  const PSQuizRankTwoDialog({super.key, required this.quiz_num});

  @override
  State<PSQuizRankTwoDialog> createState() => PSQuizRankTwoDialogState();
}

class PSQuizRankTwoDialogState extends State<PSQuizRankTwoDialog>
    with SingleTickerProviderStateMixin {
  static final Random _random = Random();

  // 初始顺序 1~4
  List<int> cellOrder = [0, 1, 2, 3];

  bool showExtras = false; // 控制顶部文案和底部按钮显示
  bool showBreath = false; // 控制呼吸动画

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  final double cellHeight = 70;
  final double spacing = 19;

  // 固定头像和文案，保证随机一次
  late final List<String> avatars;
  late final List<String> names;

  @override
  void initState() {
    super.initState();
    ps_event_fire('process_rank_pop', {});
    // 初始化头像和文案
    avatars = List.generate(4, (_) => 'ps_user_s_${random0to55()}');
    names = List.generate(4, (_) => '1****${random1000to9999()}.@gamial');

    avatars[3] = 'ps_user_icon_s';

    names[3] = PSLocalProvider.instance.ps_account_id;

    _breathController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _breathAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
        CurvedAnimation(parent: _breathController, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startSwapAnimation();
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  static int random0to55() => _random.nextInt(56);
  static int random1000to9999() => 1000 + _random.nextInt(9000);

  Future<void> startSwapAnimation() async {
    Future<void> swapTwo(int index1, int index2) async {
      setState(() {
        final tmp = cellOrder[index1];
        cellOrder[index1] = cellOrder[index2];
        cellOrder[index2] = tmp;
      });
      await Future.delayed(const Duration(milliseconds: 500));
    }

    await swapTwo(3, 2); // 4 <-> 3
    await swapTwo(2, 1); // 4 <-> 2
    await swapTwo(1, 0); // 4 <-> 1

    setState(() {
      showExtras = true;
      showBreath = true; // 第一个 cell 开始呼吸动画
    });
  }

  double yOffset(int displayIndex) => displayIndex * (cellHeight + spacing);

  Widget buildCell(int displayIndex) {
    final int order = cellOrder[displayIndex];
    final bool isBreathingCell = showBreath && displayIndex == 0;

    Widget cellContent = Container(
      width: 336.w,
      height: 70.h,
      decoration: BoxDecoration(
        image: PSDImg(isBreathingCell ? 'ps_ranks_bg_s' : 'ps_rank_list'),
      ),
      child: Row(
        children: [
          SizedBox(width: 18),
          PSImg(name: avatars[order], width: 49, height: 49),
          SizedBox(width: 12),
          PSText(
            text: isBreathingCell
                ? PSLocalProvider.instance.ps_account_id
                : names[order],
            size: 12,
            color: '#733A1B'.color(),
            weight: FontWeight.w900,
          ),
          SizedBox(width: 24),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                fontFamily: 'Black_mianfeiziti',
                color: '#733A1B'.color(),
              ),
              children: <TextSpan>[
                const TextSpan(text: 'Answer '),
                TextSpan(
                    text: '${widget.quiz_num - (displayIndex)} ',
                    style: TextStyle(color: '#0A8A33'.color())),
                const TextSpan(text: 'right'),
              ],
            ),
          ),
        ],
      ),
    );

    // 添加 AnimatedBuilder 包裹 Transform.scale 让呼吸动画生效
    if (isBreathingCell) {
      cellContent = AnimatedBuilder(
        animation: _breathAnimation,
        builder: (_, child) {
          return Transform.scale(
            scale: _breathAnimation.value,
            child: child,
          );
        },
        child: cellContent,
      );
    }

    return AnimatedPositioned(
      key: ValueKey(order),
      left: 15,
      right: 15,
      top: yOffset(displayIndex) + 221.h,
      duration: const Duration(milliseconds: 500),
      child: cellContent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 142.h),
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Black_mianfeiziti',
                        color: '#FFFFFF'.color()),
                    children: const <TextSpan>[
                      TextSpan(text: 'Top Answerer\n'),
                      TextSpan(
                          text: 'Withdrawal Made Easy!! ',
                          style: TextStyle(color: Color(0xFFFFB300))),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(height: 4 * (cellHeight + spacing)), // 占位
            ],
          ),
      
          // 四个 cell
          for (int i = 0; i < 4; i++) buildCell(i),
      
          // 底部按钮
          Visibility(
            visible: showExtras,
            child: Positioned(
              bottom: 155.h,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: (){
                  'process_rank_pop_c'.log();
                  ps_event_fire('process_rank_pop_c', {});
                  Navigator.pop(context, 0);
                },
                child: Center(
                  child: Container(
                    width: 271,
                    height: 70.5,
                    decoration: BoxDecoration(image: PSDImg('ps_keep_btn')),
                  ),
                ),
              ),
            ),
          ),
      
          // 右下角关闭按钮
          Visibility(
            visible: showExtras,
            child: Positioned(
              bottom: 100.h,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: InkWell(
                    onTap: () {
                      ps_event_fire('process_rank_pop_close', {});
                      Navigator.pop(context, 0);
                    },
                    child: Center(
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(image: PSDImg('ps_whine_close')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      
          // 顶部光圈
          Visibility(
            visible: showExtras,
            child: Positioned(
                right: 4, top: 208.h, child: PSImg(name: 'ps_guang_icon', width: 31, height: 26)),
          ),
        ],
      ),
    );
  }
}
// 信息确认1
class PSConfimOneDialog extends StatefulWidget {
  final bool isConfim;
  final String contentStr;
  const PSConfimOneDialog({super.key, required this.isConfim, required this.contentStr});

  @override
  State<PSConfimOneDialog> createState() => PSConfimOneDialogState();
}

class PSConfimOneDialogState extends State<PSConfimOneDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _containerAnimation;
  late Animation<Offset> _rightImageAnimation;
  late Animation<Offset> _leftImageAnimation;
  late Animation<double> _iconFadeAnimation;

  @override
  void initState() {
    super.initState();

    // 创建AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 动画总时长
      vsync: this,
    );

    // 前两步动画加快速度，设置前两步的时长为 1.5 秒
    // Container从右到左的平移动画
    _containerAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // 起始位置在右边
      end: Offset(0.0, 0.0),   // 结束时居中
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // ps_tips_right_g 从右到左的动画，加快速度，动画时间较短
    _rightImageAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 加速动画开始部分
    ));

    // ps_tips_left_g 从左到右的动画，保持3秒
    _leftImageAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // ps_dui_b_icon 渐变显示，保持3秒
    _iconFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 通过调整两步动画的时长，手动控制动画执行的顺序
    // 设置前两步动画时间为 1.5 秒
    _controller.duration = Duration(seconds: 1); // 前两个动画的时间

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context, 0); // 动画结束后关闭弹框
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 177.h),
        Visibility(
          visible: widget.isConfim,
          child: FadeTransition(
            opacity: _iconFadeAnimation,
            child: PSImg(name: 'ps_dui_b_icon', width: 131, height: 131),
          ),
        ),
        SlideTransition(
          position: _rightImageAnimation,
          child: Row(
            children: [
              Spacer(),
              PSImg(name: 'ps_tips_right_g', width: 283, height: 33),
            ],
          ),
        ),
        SlideTransition(
          position: _containerAnimation,
          child: Container(
            width: 0.width(context),
            height: 125,
            decoration: BoxDecoration(
              image: PSDImg('ps_tip_tx_bg'),
            ),
            child: Center(
              child: SizedBox(width: 301, height: 70.5, child: PSStrokeText(text: widget.contentStr, size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#711A00'.color(), maxLines: 2, align: TextAlign.center,))
            ),
          ),
        ),
        SlideTransition(
          position: _leftImageAnimation,
          child: Row(
            children: [
              PSImg(name: 'ps_tips_left_g', width: 283, height: 33),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

// 信息确认2
class PSConfimTwoDialog extends StatefulWidget {
  const PSConfimTwoDialog({super.key});

  @override
  State<PSConfimTwoDialog> createState() => PSConfimTwoDialogState();
}

class PSConfimTwoDialogState extends State<PSConfimTwoDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _containerAnimation;
  late Animation<Offset> _rightImageAnimation;
  late Animation<Offset> _leftImageAnimation;

  @override
  void initState() {
    super.initState();

    // 创建AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // 动画总时长
      vsync: this,
    );

    // 前两步动画加快速度，设置前两步的时长为 1.5 秒
    // Container从右到左的平移动画
    _containerAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // 起始位置在右边
      end: Offset(0.0, 0.0),   // 结束时居中
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // ps_tips_right_g 从右到左的动画，加快速度，动画时间较短
    _rightImageAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // 加速动画开始部分
    ));

    // ps_tips_left_g 从左到右的动画，保持3秒
    _leftImageAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 通过调整两步动画的时长，手动控制动画执行的顺序
    // 设置前两步动画时间为 1.5 秒
    _controller.duration = Duration(seconds: 1); // 前两个动画的时间

    _controller.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (context.mounted) {
          Navigator.of(context).pop(); // 动画结束后关闭弹框
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        SlideTransition(
          position: _rightImageAnimation,
          child: Row(
            children: [
              Spacer(),
              PSImg(name: 'ps_tips_right_g', width: 283, height: 33),
            ],
          ),
        ),
        SlideTransition(
          position: _containerAnimation,
          child: Container(
            width: 0.width(context),
            height: 125,
            decoration: BoxDecoration(
              image: PSDImg('ps_tip_tx_bg'),
            ),
            child: Center(
              child: PSImg(name: 'ps_tip_keep_title', width: 301.5, height: 70.5),
            ),
          ),
        ),
        SlideTransition(
          position: _leftImageAnimation,
          child: Row(
            children: [
              PSImg(name: 'ps_tips_left_g', width: 283, height: 33),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

// 余额不足
class PSTXOutDialog extends StatefulWidget {
  final int seletcd_row;
  const PSTXOutDialog({super.key, required this.seletcd_row});

  @override
  State<PSTXOutDialog> createState() => PSTXOutDialogState();
}

class PSTXOutDialogState extends State<PSTXOutDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('cash_not_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 309.w,
          height: 325.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_about_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              PSText(text: 'Insufficient Balance', size: 24, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 20.h),
              Container(
                width: 167.w,
                height: 103.h,
                decoration: BoxDecoration(
                    image: PSDImg('ps_act_bg_0')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange[widget.seletcd_row]}', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#000000'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Only ',
                    ),
                    TextSpan(
                      text: '${0.dolasType()}${0.to2Double(PSNumberHelpers().intModel!.eqRange[widget.seletcd_row] - PSLocalProvider.instance.ps_dolas_number)} ',
                      style: TextStyle(color: '#0A8A33'.color()),
                    ),
                    TextSpan(
                      text: 'Left To Withdraw ',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 19.h),
              ParticleButton(
                onTap: (){
                  ps_event_fire('cash_not_pop_c', {});
                  Navigator.pop(context);
                   PigTabController.switchTo(1);
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Keep Earning', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              ps_event_fire('cash_not_pop_c', {});
              Navigator.pop(context, 0);
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}
// 提现最后一步
class PSTXLastDialog extends StatefulWidget {
  final int type;
  const PSTXLastDialog({super.key, required this.type});

  @override
  State<PSTXLastDialog> createState() => PSTXLastDialogState();
}

class PSTXLastDialogState extends State<PSTXLastDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('one_last_step_pop', {'type' : gettypeString()});
  }

  String gettypeString(){
    if (widget.type == 0){
      return 'quiz';
    } else if (widget.type == 1){
      return 'spine';
    } else if (widget.type == 2){
      return 'ad';
    } else if (widget.type == 3){
      return 'quiz';
    } else if (widget.type == 4){
      return 'spine';
    } else if (widget.type == 5){
      return 'ad';
    } else if (widget.type == 6){
      return 'quiz';
    } else if (widget.type == 7){
      return 'spine';
    } else {
      return 'ad';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 309.w,
          height: 407.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_tx_info_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 22.h),
              PSText(text: 'One Last Step', size: 26, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 18.h),
              Container(
                width: 167.w,
                height: 103.h,
                decoration: BoxDecoration(
                    image: PSDImg('ps_act_bg_${PSLocalProvider.instance.ps_tx_ing_account}${isBrazilianPortuguese(context) == true ? 'pt' : ''}')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(width: 205, height: 38,child: PSText(text: 'Only One Step Away From Successful Withdrawal', size: 15, color: '#134475'.color(), weight: FontWeight.w900, maxLines: 2,align: .center)),
              SizedBox(height: 12.h),
              Container(
                width: 283.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: '#E4E9EC'.color(),
                  borderRadius: BorderRadius.circular(16.h)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 12.h),
                    PSText(text: getTaskString(), size: 16, color: '#12881E'.color(), weight: FontWeight.w900),
                    SizedBox(height: 15.h),
                    Container(
                      width: 249.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: '#C3CBD3'.color(),
                        borderRadius: BorderRadius.circular(10.h)
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: 249.w * getTaskProgress(),
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: '#1757B1'.color(),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                          ),
                          Positioned(top: 5.h,left: 110.w,child: PSStrokeText(text: '${(getTaskProgress() * 100).toInt()}%', size: 10, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#113996'.color()))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ParticleButton(
                onTap: (){
                  ps_event_fire('one_last_step_pop_c', {'type' : gettypeString()});
                  Navigator.pop(context, 0);
                  if (PSLocalProvider.instance.ps_tx_task_index == 0){
                    PigTabController.switchTo(1);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 1){
                    PigTabController.switchTo(2);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 3){
                    PigTabController.switchTo(1);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 4){
                    PigTabController.switchTo(1);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 5){
                    PigTabController.switchTo(2);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 6){
                    PigTabController.switchTo(1);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 7){
                    PigTabController.switchTo(1);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 8){
                    PigTabController.switchTo(2);
                  } else if (PSLocalProvider.instance.ps_tx_task_index == 9){
                    PigTabController.switchTo(1);
                  }
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Cash Out', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              ps_event_fire('one_last_step_pop_c', {'type' : gettypeString()});
              Navigator.pop(context, 0);
              if (PSLocalProvider.instance.ps_tx_task_index == 0){
                PigTabController.switchTo(1);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 1){
                PigTabController.switchTo(2);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 3){
                PigTabController.switchTo(1);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 4){
                PigTabController.switchTo(1);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 5){
                PigTabController.switchTo(2);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 6){
                PigTabController.switchTo(1);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 7){
                PigTabController.switchTo(1);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 8){
                PigTabController.switchTo(2);
              } else if (PSLocalProvider.instance.ps_tx_task_index == 9){
                PigTabController.switchTo(1);
              }
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  String getTaskString(){
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
    } else {
      return 'Watch ${PSLocalProvider.instance.ps_tx_bubble_index}/${PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data} Ad Video';
    }
  }

  double getTaskProgress(){
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
      } else {
        return PSLocalProvider.instance.ps_tx_bubble_index / PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data;
      }
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

}
// 排行榜
class PSTXRankDialog extends StatefulWidget {
  const PSTXRankDialog({super.key});

  @override
  State<PSTXRankDialog> createState() => PSTXRankDialogState();
}

class PSTXRankDialogState extends State<PSTXRankDialog>
    with SingleTickerProviderStateMixin {

  final List<String> texts = List.generate(PSLocalProvider.instance.ps_all_ranking, (index) => '${index+1}');

  late ScrollController _scrollController = ScrollController();

  List<String> _generateList() {
    final random = Random(); // 创建一个随机数生成器
    List<String> list = List.generate(PSLocalProvider.instance.ps_all_ranking, (index) {
      if (index == PSLocalProvider.instance.ps_current_ranking - 1) { // 第90个位置（索引为89）
        return PSLocalProvider.instance.ps_account_id;
      } else {
        // 生成随机的三位数字
        String randomPart = random.nextInt(1000).toString().padLeft(3, '0');
        return "1*****$randomPart";
      }
    });
    return list;
  }

  final random = Random(); // 创建一个随机数生成器
  // 定义可能的金额值
  List possibleValues = PSNumberHelpers().intModel!.eqRange;
  // 生成列表
  List<String> _generateDolasList() {
    List<String> list = List.filled(PSLocalProvider.instance.ps_all_ranking, ""); // 初始化一个长度为200的空字符串列表

    for (int i = 0; i < list.length; i++) {
      if (i == PSLocalProvider.instance.ps_current_ranking - 1) { // 第90个位置（索引为89）
        list[i] = "${0.dolasType()}${possibleValues[PSLocalProvider.instance.ps_tx_ing_number]}";
      } else {
        // 随机选择一个可能的金额值
        list[i] = '${0.dolasType()}${possibleValues[random.nextInt(possibleValues.length)]}';
      }
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    ps_event_fire('cash_queue_pop', {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(PSLocalProvider.instance.ps_current_ranking);
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 317.w,
          height: 528.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_ranks_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 24.h),
              PSText(text: 'Withdrawal Approval ', size: 20, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 24.h),
              Container(
                width: 167.w,
                height: 103.h,
                decoration: BoxDecoration(
                    image: PSDImg('ps_act_bg_0')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(text: '${0.dolasType()}${possibleValues.first}', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 273,
                height: 44,
                decoration: BoxDecoration(
                  color: '#197632'.color(),
                  borderRadius: BorderRadius.circular(22)
                ),
                child: Center(
                  child: PSText(text: 'Congratulations, You are in the withdrawal approval queue.', size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w900, align: TextAlign.center, maxLines: 2),
                ),
              ),
              SizedBox(height: 11.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#2A1B1B'.color()
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${PSLocalProvider.instance.ps_all_ranking} ',
                      style: TextStyle(color: '#1A54A6'.color()),
                    ),
                    TextSpan(
                      text: 'in queue, Your Current rank: ',
                    ),
                    TextSpan(
                      text: '${PSLocalProvider.instance.ps_current_ranking}',
                      style: TextStyle(color: '#1B9A15'.color()),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 277.w,
                height: 166.h,
                decoration: BoxDecoration(
                  image: PSDImg('ps_rank_center_bg')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              'User ID',
                              style: TextStyle(color: '#000000'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Number',
                              style: TextStyle(color: '#000000'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              'Amount',
                              style: TextStyle(color: '#000000'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: 259.w,
                      height: 1,
                      child: CustomPaint(
                        size: Size(double.infinity, 1),  // 高度为1
                        painter: DashedLinePainter(),
                      ),
                    ),
                    SizedBox(
                      width: 261.0,
                      height: 119.0,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(top: 0.0),
                        itemCount: texts.length, // 计算需要多少行
                        itemBuilder: (context, index) {
                          return Container(
                            width: 261.0,
                            height: 23.0,
                            decoration: BoxDecoration(
                              color: index + 1 == PSLocalProvider.instance.ps_current_ranking ? '#0A4BA1'.color() : Colors.transparent,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      texts[index],
                                      style: TextStyle(color: index + 1 == PSLocalProvider.instance.ps_current_ranking ? '#FFFFFF'.color() : '#304B66'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      _generateList()[index],
                                      style: TextStyle(color: index + 1 == PSLocalProvider.instance.ps_current_ranking ? '#FFFFFF'.color() : '#304B66'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      _generateDolasList()[index],
                                      style: TextStyle(color: index + 1 == PSLocalProvider.instance.ps_current_ranking ? '#FFFFFF'.color() : '#304B66'.color(), fontSize: 14, fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              ParticleButton(
                onTap: (){
                  ps_event_fire('cash_queue_po_c', {});
                  PSPigAds().ps_showAd(context, 'nskdh_queue_rv', onCacheResponse: (onCacheResponse){

                    }, adDidClosed: (adDidClosed){
                      rankupdate();
                    });
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: PSText(text: 'Skip Wait', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                      ),
                      Positioned(right: 0,child: PSImg(name: 'ps_ad_icon', width: 37, height: 40))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 0.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              Navigator.pop(context, 0);
              ps_event_fire('cash_queue_po_close', {});
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 286,
          height: 82,
          decoration: BoxDecoration(
            image: PSDImg('p_rank_bottom_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 32),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#733A1B'.color(),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'No need to wait,\n',
                    ),
                    TextSpan(
                      text: 'watch ads and cash out ',
                    ),
                    TextSpan(
                      text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} ',
                      style: TextStyle(color: '#0F7E29'.color()),
                    ),
                    TextSpan(
                      text: 'faster!',
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> rankupdate() async {
    int row = randomIntInRange(min: PSNumberHelpers().intModel!.queueNumber.last.intCurrentDelete.first, max: PSNumberHelpers().intModel!.queueNumber.last.intCurrentDelete.last);
    if (PSLocalProvider.instance.ps_current_ranking - row <= 1) {
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_current_rankingName, 1);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, 0);
      Navigator.pop(context, 1);
      if (!mounted) return;
      PSDialogTool.toastRanking(context, 1);
      context.tipShow(PSTXLastDialog(type: PSLocalProvider.instance.ps_tx_task_index));
      PSPigCashNotificationService.sendToQuizProgressNotification(0);
    } else {
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_all_rankingName, PSLocalProvider.instance.ps_all_ranking - randomIntInRange(min: PSNumberHelpers().intModel!.queueNumber.first.intAllDelete.first, max: PSNumberHelpers().intModel!.queueNumber.first.intAllDelete.last));
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_current_rankingName, PSLocalProvider.instance.ps_current_ranking - row);
      Future.delayed(Duration(milliseconds: 200),(){
        if (!mounted) return;
        setState(() {
          _scrollToIndex(PSLocalProvider.instance.ps_current_ranking);
          PSDialogTool.toastRanking(context, PSLocalProvider.instance.ps_current_ranking);
          PSPigCashNotificationService.sendToQuizProgressNotification(0);
        });
      });
    }
  }


  void _scrollToIndex(int index) {
    // 每个 item 的高度固定为 38（根据你的例子）
    double itemHeight = 23;

    // 计算目标位置
    final double offset = (index - 1) * itemHeight;

    // 平滑滚动动画
    if (_scrollController.positions.isEmpty) return;
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
  
  /// Returns a random integer between [min] and [max] (inclusive).
  int randomIntInRange({required int min, required int max}) {
    if (min > max) {
      throw ArgumentError('min should be less than or equal to max');
    }
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

}
// 引导4
class PSGuide4Dialog extends StatefulWidget {
  const PSGuide4Dialog({super.key});

  @override
  State<PSGuide4Dialog> createState() => PSGuide4DialogState();
}

class PSGuide4DialogState extends State<PSGuide4Dialog>
    with SingleTickerProviderStateMixin {
  late spine.SpineWidgetController _controller;
  @override
  void initState() {
    super.initState();
    ps_event_fire('gold_pig_getpop', {});
    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(width: 0.width(context), height: 0.height(context),child: spine.SpineWidget.fromAsset('assets/spine/caidai/skeleton.atlas', 'assets/spine/caidai/skeleton.skel', _controller)),
        Column(
          mainAxisAlignment: .center,
          children: [
            PSImg(name: 'ps_guide4_top', width: 317, height: 77),
            Container(
              width: 211.w,
              height: 208.h,
              decoration: BoxDecoration(
                  image: PSDImg('ps_guide_jin')
              ),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    width: 141,
                    height: 34,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_act_bg')
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                        SizedBox(width: 5,),
                        PSText(text: '${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number)}', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 335,
              height: 259,
              decoration: BoxDecoration(
                  image: PSDImg('ps_guide4_bg')
              ),
              child: Column(
                children: [
                  SizedBox(height: 25),
                  SizedBox(width: 270, height: 40,child:
                  PSStrokeText(text: 'Advertiser apologized for the\ndelay and sent you a Golden Pig!', size: 16, color: '#FFE11C'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1D0808'.color(),maxLines: 2,)
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 276,
                    height: 48,
                    child:
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Black_mianfeiziti',
                          color: '#2A1B1B'.color(),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Collect ',
                          ),
                          TextSpan(
                            text: '10 Gold Bars ',
                            style: TextStyle(color: '#E18300'.color()),
                          ),
                          TextSpan(
                            text: 'To Speed Up Your ',
                          ),
                          TextSpan(
                            text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} ',
                            style: TextStyle(color: '#17931B'.color()),
                          ),
                          TextSpan(
                            text: ' Payout',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 28),
                  InkWell(
                    onTap: (){
                      ps_event_fire('gold_pig_getpop_c', {});
                      Navigator.pop(context, 1);
                      PigTabController.switchTo(1);
                    },
                    child: Container(
                      width: 272,
                      height: 71,
                      decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Start Now',
                          size: 24,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#025003'.color(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

}

// 到达100
class PSdolls100Dialog extends StatefulWidget {
  const PSdolls100Dialog({super.key});

  @override
  State<PSdolls100Dialog> createState() => PSdolls100DialogState();
}

class PSdolls100DialogState extends State<PSdolls100Dialog>
    with SingleTickerProviderStateMixin {
  late spine.SpineWidgetController _controller;
  @override
  void initState() {
    super.initState();
    ps_event_fire('diamond_pig_getpop', {});
    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(width: 0.width(context), height: 0.height(context),child: spine.SpineWidget.fromAsset('assets/spine/caidai/skeleton.atlas', 'assets/spine/caidai/skeleton.skel', _controller)),
        Column(
          mainAxisAlignment: .center,
          children: [
            PSImg(name: 'ps_100_top', width: 311, height: 82),
            Container(
              width: 211.w,
              height: 208.h,
              decoration: BoxDecoration(
                  image: PSDImg('ps_doamond_pigs')
              ),
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    width: 141,
                    height: 34,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_act_bg')
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                        SizedBox(width: 5,),
                        PSText(text: '${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number)}', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 335,
              height: 139,
              decoration: BoxDecoration(
                  image: PSDImg('ps_100_bg')
              ),
              child: Column(
                children: [
                  Padding(padding: EdgeInsetsGeometry.only(top: 0),child: PSImg(name: 'ps_100_dui', width: 66, height: 67)),
                  SizedBox(height: 0),
                  PSText(text: 'Platform approved.\nFunds are ready.', size: 24, color: '#179C0B'.color(), weight: FontWeight.w900, maxLines: 2, align: TextAlign.center,),
                ],
              ),
            ),
            SizedBox(height: 44),
            InkWell(
              onTap: (){
                ps_event_fire('diamond_pig_getpop_c', {});
                Navigator.pop(context, 1);
                context.tipShow(PSReviewingDialog());
              },
              child: Container(
                width: 272,
                height: 71,
                decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                child: Center(
                  child: PSStrokeText(
                    text: 'Next Step',
                    size: 24,
                    color: '#FFFFFF'.color(),
                    weight: FontWeight.w900,
                    skWidth: 2,
                    skColor: '#025003'.color(),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

}
// 虚线
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = '#A2B1C2'.color()    // 设置虚线颜色为绿色
      ..strokeWidth = 1         // 设置线条的宽度
      ..style = PaintingStyle.stroke;

    // 设置虚线的长度和间距
    double dashWidth = 5;
    double dashSpace = 5;
    double startX = 0;

    // 根据画布的宽度来绘制虚线
    while (startX < size.width) {
      // 绘制线段
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// 无网络，加载失败，超出上限，无通知权限,无转盘次数
class PSPopTipsToolDialog extends StatefulWidget {
  final AdStatus adStatus;
  const PSPopTipsToolDialog({super.key, required this.adStatus});

  @override
  State<PSPopTipsToolDialog> createState() => PSPopTipsToolDialogState();
}

class PSPopTipsToolDialogState extends State<PSPopTipsToolDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (widget.adStatus == .noticeOpen){
      ps_event_fire('inform_back_pop', {});
    } else if (widget.adStatus == .notWifi){
      ps_event_fire('no_network_pop', {});
    } else if (widget.adStatus == .adLoadfaild){
      ps_event_fire('ad_fail_pop', {});
    } else if (widget.adStatus == .adLimit){
      ps_event_fire('ad_limit_pop', {});
    } else if (widget.adStatus == .notWheel){
      ps_event_fire('no_chance_pop', {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Row(
          children: [
            Spacer(),
            ParticleButton(child: PSImg(name: "ps_close_icon", width: 40, height: 40), onTap: (){
              Navigator.pop(context, 0);
            }),
            SizedBox(width: 27)
          ],
        ),
        SizedBox(height: 20),
        Container(
          width: 335,
          height: 341,
          decoration: BoxDecoration(
            image: PSDImg("ps_tips_bg")
          ),
          child: Column(
            children: [
              SizedBox(height: 28),
              PSStrokeText(text: _getTotitleName(), size: widget.adStatus == .noticeOpen ? 22 : 26, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1051A4'.color()),
              SizedBox(height: _getToiconToTopH(),),
              PSImg(name: _getToImageName(),width: _getToImageSize().width, height: _getToImageSize().height),
              if (widget.adStatus == .adLimit || widget.adStatus == .notWheel)
                SizedBox(height: 7),
              if (widget.adStatus == .notWheel)
                PSText(text: "X2", size: 24, color: '#A4420B'.color(), weight: FontWeight.w900, maxLines: 1),
              if (widget.adStatus == .adLimit)
                SizedBox(width: 232, height: 34,child: PSText(text: "You've watched all available ads for today. Try again tomorrow.", size: 14, color: '#733A1B'.color(), weight: FontWeight.w900, maxLines: 2)),
              if (widget.adStatus == .noticeOpen)
                PSText(text: "open the notificationto receive cash", size: 14, color: '#733A1B'.color(), weight: FontWeight.w900, maxLines: 1),
              Spacer(),
              ParticleButton(child: Container(
                width: 272,
                height: 71,
                decoration: BoxDecoration(
                    image: PSDImg("ps_quzi_btn_d")
                ),
                child: Center(
                  child: PSStrokeText(text: _getToBtnName(), size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#025003'.color()),
                ),
              ), onTap: (){
                if (widget.adStatus == .adLoadfaild) {
                  Navigator.pop(context, 1);
                  PSPigAds().init(inputAd: PSPigAds().psPigAdModel);
                } else if (widget.adStatus == .notWifi) {
                  Navigator.pop(context, 1);
                } else if (widget.adStatus == .adLimit) {
                  Navigator.pop(context, 1);
                } else if (widget.adStatus == .noticeOpen) {
                  ps_event_fire('noti_confirm_pop_allow', {});
                  Navigator.pop(context, 1);
                  AppSettings.openAppSettings(
                    type: AppSettingsType.notification,
                  );
                  ps_event_fire('noti_confirm_pop_suc', {});
                } else if (widget.adStatus == .notWheel) {
                  ps_event_fire('no_chance_pop_c', {});
                  Navigator.pop(context, 1);
                  PigTabController.switchTo(1);
                }
              }),
              SizedBox(height: 11)
            ],
          )
        )
      ],
    );
  }

  double _getToiconToTopH(){
    double title = 31;
    if (widget.adStatus == .adLoadfaild) {
       title = 31;
    } else if (widget.adStatus == .notWifi) {
      title = 50;
    } else if (widget.adStatus == .adLimit) {
      title = 31;
    } else if (widget.adStatus == .noticeOpen) {
      title = 31;
    } else if (widget.adStatus == .notWheel) {
      title = 37;
    }
    return title;
  }

  String _getTotitleName(){
    String title = "";
    if (widget.adStatus == .adLoadfaild) {
      title = "Ad Loading Failed";
    } else if (widget.adStatus == .notWifi) {
      title = "No Network Currently";
    } else if (widget.adStatus == .adLimit) {
      title = "Ad Limit Reached";
    } else if (widget.adStatus == .noticeOpen) {
      title = "Turn On Pushnotifications";
    } else if (widget.adStatus == .notWheel) {
      title = "No More Chance";
    }
    return title;
  }

  String _getToBtnName(){
    String title = "";
    if (widget.adStatus == .adLoadfaild) {
      title = "Try Again";
    } else if (widget.adStatus == .notWifi) {
      title = "Got It";
    } else if (widget.adStatus == .adLimit) {
      title = "Got It";
    } else if (widget.adStatus == .noticeOpen) {
      title = "Got It";
    } else if (widget.adStatus == .notWheel) {
      title = "Get By Quiz";
    }
    return title;
  }

  String _getToImageName(){
    String title = "";
    if (widget.adStatus == .adLoadfaild) {
      title = "ps_adfaild_icon";
    } else if (widget.adStatus == .notWifi) {
      title = "ps_wift_icon";
    } else if (widget.adStatus == .adLimit) {
      title = "ps_limit_icon";
    } else if (widget.adStatus == .noticeOpen) {
      title = "ps_notice_icon";
    } else if (widget.adStatus == .notWheel) {
      title = "ps_wheel_cions";
    }
    return title;
  }

  Size _getToImageSize(){
    Size size = Size(0, 0);
    if (widget.adStatus == .adLoadfaild) {
      size = Size(137, 137);
    } else if (widget.adStatus == .notWifi) {
      size = Size(130, 108);
    } else if (widget.adStatus == .adLimit) {
      size = Size(96, 104);
    } else if (widget.adStatus == .noticeOpen) {
      size = Size(129, 129);
    } else if (widget.adStatus == .notWheel) {
      size = Size(93, 94);
    }
    return size;
  }
}
// 奖励通用1
class PSPopAwardToolDialog extends StatefulWidget {
  final AwardType type;
  final bool isGuide;
  final double award;
  const PSPopAwardToolDialog({super.key, required this.type, required this.isGuide, required this.award});

  @override
  State<PSPopAwardToolDialog> createState() => PSPopAwardToolDialogState();
}

class PSPopAwardToolDialogState extends State<PSPopAwardToolDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    if (widget.isGuide){
      ps_event_fire('new_quiz_correct_pop', {});
    }
    ps_event_fire('double_pop', {'pop_from' : widget.type == .quiz ? 'quiz' : 'wheel'});

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        PSImg(name:'ps_award_top_bg', width: 345.w, height: 74.h),
        SizedBox(height: 17.h),
        Stack(
          children: [
            Container(
                width: 345.w,
                height: 466.h,
                decoration: BoxDecoration(
                    image: PSDImg("ps_award_bottom_bg")
                ),
                child: Column(
                  children: [
                    SizedBox(height: 17.h),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Black_mianfeiziti',
                            color: '#134475'.color()
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Only ',
                          ),
                          TextSpan(
                            text: '${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first ? 0 : double.parse((PSNumberHelpers().intModel!.eqRange.first - PSLocalProvider.instance.ps_dolas_number).toStringAsFixed(2))}',
                            style: TextStyle(color: '#0E731E'.color()),
                          ),
                          TextSpan(
                            text: ' Left To Cash Out',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 34.h),
                    PSImg(name: "ps_dolas_b", width: 90.w, height: 79.h),
                    PSText(text: '+${0.dolasType()}${widget.award}', size: 24, color:'#199E24'.color() , weight: FontWeight.w900),
                    SizedBox(height:13.h),
                    Row(
                      children: [
                        SizedBox(width: 38.w),
                        PSImg(name: "ps_dui_icon", width: 27.w, height: 28.h),
                        SizedBox(width: 12.w),
                        PSText(text: 'Ensure Safety', size: 20, color: '#24313F'.color(), weight: FontWeight.w900)
                      ],
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        SizedBox(width: 38.w),
                        PSImg(name: "ps_dui_icon", width: 27.w, height: 28.h),
                        SizedBox(width: 12.w),
                        PSText(text: 'Arrived within 24 hours', size: 20, color: '#24313F'.color(), weight: FontWeight.w900)
                      ],
                    ),
                    SizedBox(height: 7.h),
                    Row(
                      children: [
                        SizedBox(width: 38.w),
                        PSImg(name: "ps_dui_icon", width: 27.w, height: 28.h),
                        SizedBox(width: 12.w),
                        PSText(text: '1M+ User Trusted', size: 20, color: '#24313F'.color(), weight: FontWeight.w900)
                      ],
                    ),
                    SizedBox(height:36.h),
                    Container(
                      width: 301.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_award_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width:(isBrazilianPortuguese(context) == true && PSLocalProvider.instance.ps_account_seled_index == 0) ? 12.w : 8.w),
                          PSImg(name: 'ps_act_samil_${PSLocalProvider.instance.ps_account_seled_index}${isBrazilianPortuguese(context) == true ? 'pt' : ''}', width: (isBrazilianPortuguese(context) == true && PSLocalProvider.instance.ps_account_seled_index == 0) ? 54.w : 61.w, height:(isBrazilianPortuguese(context) == true && PSLocalProvider.instance.ps_account_seled_index == 0) ? 27.h : 16.h),
                          SizedBox(width: 8.w,),
                          PSImg(name: 'ps_payment_icon', width: 67.w, height: 21.h),
                          SizedBox(width: 8.w,),
                          PSText(text: 'My Cash :${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number)}', size: 14, color: '#0C7A29'.color(), weight: FontWeight.w900)
                        ],
                      ),
                    ),
                    SizedBox(height: 19.h),
                    ParticleButton(
                      onTap: () async {
                        ps_event_fire('double_pop_c', {'pop_from' : widget.type == .quiz ? 'quiz' : 'wheel'});
                        if (widget.isGuide){
                          ps_event_fire('new_quiz_correct_pop_c', {});
                        }
                        if (!widget.isGuide){
                          PSPigAds().ps_showAd(context, adRewardPod_idName(), onCacheResponse: (onCacheResponse) async {
                            Navigator.pop(context, 1);
                          }, adDidClosed: (adDidClosed) async {
                            Navigator.pop(context, 1);
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, widget.award);
                            if (!context.mounted) return;
                            context.tipShow2(PSPoGetAwardDog(award: widget.award),bc: Colors.transparent);
                          });
                        } else {
                          Navigator.pop(context, 1);
                          await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, widget.award);
                          if (!context.mounted) return;
                          context.tipShow2(PSPoGetAwardDog(award: widget.award),bc: Colors.transparent);
                        }
                      },
                      child: Container(
                        width: 301.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                            color: '#0E79C6'.color(),
                            borderRadius: BorderRadius.circular(25.h)
                        ),
                        child: Center(
                          child: PSText(text: 'Claim', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                        ),
                      ),
                    )
                  ],
                )
            ),
            Visibility(visible: !widget.isGuide,child: Positioned(bottom: 39.h, right: 22.w,child: PSImg(name: 'ps_ad_icon', width: 37, height: 40)))
          ],
        ),
        SizedBox(height: 16.h),
        ParticleButton(child: SizedBox(width: 40,height: 40,child: Center(child: PSImg(name: 'ps_whine_close', width: 18, height: 18 , fit: BoxFit.fill,))), onTap: (){
          if (PSNumberHelpers().checkProbability() && !widget.isGuide){
            PSPigAds().ps_showAd(context, adIntPod_idName(), onCacheResponse: (onCacheResponse){
              Navigator.pop(context, 0);
            }, adDidClosed: (adDidClosed){
              Navigator.pop(context, 0);
            });
          } else {
            Navigator.pop(context, 0);
          }
        })
      ],
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

  String adIntPod_idName(){
    if (widget.type == .apple) {
      return 'nskdh_applebub_getpop_int';
    } else if (widget.type == .quiz){
      return 'nskdh_quizgetinfor_int';
    } else if (widget.type == .buble){
      return 'nskdh_moneybub_getpop_int';
    } else if (widget.type == .wheel){
      return 'nskdh_wheel_int';
    } else {
      return 'nskdh_launch';
    }
  }

  String adRewardPod_idName(){
    if (widget.type == .apple) {
      return 'asd_rv';
    } else if (widget.type == .quiz){
      return 'nskdh_quizgetc_rv';
    } else if (widget.type == .buble){
      return 'nskdh_moneybub_getpop_rv';
    } else if (widget.type == .wheel){
      return 'nskdh_wheel_rv';
    } else {
      return 'nskdh_launch';
    }
  }

}
// 正在审核
class PSReviewingDialog extends StatefulWidget {
  const PSReviewingDialog({super.key});

  @override
  State<PSReviewingDialog> createState() => PSReviewingDialogState();
}

class PSReviewingDialogState extends State<PSReviewingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    ps_event_fire('ad_review_pop', {});
    // Animate progress from 0 to 1 in 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // When animation completes, pop the dialog
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.pop(context);
        context.tipShow(PSReviewFaildDialog());
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progressBarWidth = 249.w; // total width of progress bar
    double progressBarHeight = 20.h;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 309.w,
          height: 325.h,
          decoration: BoxDecoration(image: PSDImg('ps_about_bg')),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              PSText(
                text: '⚡ Advertiser Review Pending',
                size: 18,
                color: '#264077'.color(),
                weight: FontWeight.w900,
              ),
              SizedBox(height: 20.h),
              Container(
                width: 167.w,
                height: 103.h,
                decoration: BoxDecoration(image: PSDImg('ps_act_bg_0')),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(
                      text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 1,
                      skColor: '#000000'.color(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 283.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: '#E4E9EC'.color(),
                    borderRadius: BorderRadius.circular(16.h)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        double progress = _animation.value; // 0.0 - 1.0
                        double percentage = (progress * 100).clamp(0, 100);
                        return Stack(
                          children: [
                            Container(
                              width: progressBarWidth,
                              height: progressBarHeight,
                              decoration: BoxDecoration(
                                color: '#C3CBD3'.color(),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                            ),
                            Container(
                              width: progressBarWidth * progress,
                              height: progressBarHeight,
                              decoration: BoxDecoration(
                                color: '#1757B1'.color(),
                                borderRadius: BorderRadius.circular(10.h),
                              ),
                            ),
                            Positioned(
                              top: 5.h,
                              left: progressBarWidth * progress - 30, // adjust text position
                              child: PSStrokeText(
                                text: '${percentage.toInt()}%',
                                size: 10,
                                color: '#FFFFFF'.color(),
                                weight: FontWeight.w900,
                                skWidth: 1,
                                skColor: '#113996'.color(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    PSText(
                      text: 'Review in progress...',
                      size: 14,
                      color: '#6B7C8B'.color(),
                      weight: FontWeight.w900,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30.h),
      ],
    );
  }
}
// 审核失败
class PSReviewFaildDialog extends StatefulWidget {
  const PSReviewFaildDialog({super.key});

  @override
  State<PSReviewFaildDialog> createState() => PSReviewFaildDialogState();
}

class PSReviewFaildDialogState extends State<PSReviewFaildDialog>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('collect_diamond_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        Container(
          width: 309.w,
          height: 400.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_tx_info_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              PSText(text: 'Oops, One More Step!', size: 20, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 2.h),
              Container(
                width: 136.w,
                height: 136.h,
                decoration: BoxDecoration(
                    image: PSDImg('ps_faild_icon')
                ),
              ),
              SizedBox(height: 8.h),
              PSText(text: 'Advertiser review isn’t complete.', size: 16, color: '#264077'.color(), weight: FontWeight.w900),
              SizedBox(height: 24.h),
              SizedBox(
                width: 272, height: 57,
                child: PSText(text: 'We apologize for the delay—earn 20 Diamonds to clear the last check and get paid instantly.', size: 16, color: '#EA8100'.color(), weight: FontWeight.w900, maxLines: 3
                ,align: TextAlign.center,),
              ),
              SizedBox(height: 19.h),
              ParticleButton(
                onTap: (){
                  ps_event_fire('collect_diamond_pop_c', {});
                  Navigator.pop(context, 0);
                  PigTabController.switchTo(1);
                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Earn Now', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 30.h),
        SizedBox(
          width: 40,
          height: 40,
          child: ParticleButton(
            onTap: (){
              Navigator.pop(context, 0);
            },
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                    image: PSDImg('ps_whine_close')
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

}
///******************** A **************************///
class PSDialogTool {
  // tosat
  static void toast(BuildContext buildContext, String text) async {
    await showAndroidToast(
      padding: 0.0.all(16),
      margin: 0.0.all(32),
      alignment: Alignment.center,
      backgroundColor: '#000000'.color(opacity: 0.8),
      duration: Duration(seconds: 2),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      context: buildContext,
    );
  }

  static void toastRanking(BuildContext buildContext, int num) async {
    await showAndroidToast(
      padding: 0.0.all(0),
      margin: 0.0.all(0),
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      duration: Duration(seconds: 3),
      child: Container(
        width: 205,
       height: 50.5,
        decoration: BoxDecoration(
          color: '#000000'.color(opacity: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Your Current rank: ',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: '$num',
                  style: TextStyle(color: '#16FF16'.color(), fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
      context: buildContext,
    );
  }
}

// 钻石/金砖 奖励
class PSPopDomandAwardADialog extends StatefulWidget {
  PSPopDomandAwardADialog({super.key});

  @override
  State<PSPopDomandAwardADialog> createState() =>
      PSPopDomandAwardADialogState();
}

class PSPopDomandAwardADialogState extends State<PSPopDomandAwardADialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6), // 转一圈时间（可调）
    )..repeat(); // 无限循环
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PSImg(name: 'ps_domand_titlle', width: 343, height: 64),
          const SizedBox(height: 20),

          /// 👇 旋转部分
          SizedBox(
            width: 239,
            height: 228,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 旋转背景
                RotationTransition(
                  turns: _rotateController,
                  child: Container(
                    width: 239,
                    height: 228,
                    decoration: BoxDecoration(
                      image: PSDImg('ps_domand_center'),
                    ),
                  ),
                ),

                /// 中间图标（不旋转）
                PSImg(name: PSLocalProvider.instance.ps_pig_level == 0 ? 'ps_domand_icon' : PSLocalProvider.instance.ps_pig_level == 1 ? 'ps_domand_icon' : 'ps_zhuan_big', width: 136, height: 119),
                Positioned(
                  bottom: 0,
                  child: PSStrokeText(
                    text: PSLocalProvider.instance.ps_pig_level == 0 ? 'X1' : PSLocalProvider.instance.ps_pig_level == 1 ? 'X1' : 'X2',
                    size: 40,
                    color: '#FFFFFF'.color(),
                    weight: FontWeight.w900,
                    skWidth: 2,
                    skColor: '#5F2605'.color(),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 57),

          ParticleButton(
            onTap: () {
              Navigator.pop(context, 1);
              PSAdAHelper().show(
                context,
                (hasCache) {
                  if (!hasCache){
                    PSAdAHelper().resetBlock();
                  }
                },
                (finished) async {
                  // X2
                  await PSLocalProvider.instance.updatedouble(
                    PSLocalProvider.instance.ps_pig_level_indexName,
                    PSLocalProvider.instance.ps_pig_level_index + 2,
                  );
                  if (PSLocalProvider.instance.ps_pig_level == 0 && PSLocalProvider.instance.ps_pig_level_index >= 20){
                    await PSLocalProvider.instance.updateint(
                      PSLocalProvider.instance.ps_pig_level_indexName,
                      0,
                    );
                    await PSLocalProvider.instance.updateint(
                      PSLocalProvider.instance.ps_pig_levelName,
                      1,
                    );
                  } else if (PSLocalProvider.instance.ps_pig_level == 1 && PSLocalProvider.instance.ps_pig_level_index >= 10){
                    await PSLocalProvider.instance.updateint(
                      PSLocalProvider.instance.ps_pig_level_indexName,
                      10,
                    );
                    await PSLocalProvider.instance.updateint(
                      PSLocalProvider.instance.ps_pig_levelName,
                      2,
                    );
                  }
                  PSAdAHelper().resetBlock();
                },
              );
            },
            child: Container(
              width: 260,
              height: 58.5,
              decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
              child: Stack(
                children: [
                  Center(
                    child: PSStrokeText(
                      text: 'Collect',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 2,
                      skColor: '#025003'.color(),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: 0,
                    child: PSImg(name: 'ps_ad_icon', width: 37, height: 40),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          PSUnderlineTextButton(
            text: 'Give Up',
            textColor: '#F1EFB2'.color(),
            fontSize: 20,
            underlineColor: '#F1EFB2'.color(),
            onPressed: () {
              Navigator.pop(context, 0);
            },
          ),
        ],
      ),
    );
  }
}

// 获取转盘次数
class PSPopMoreChanceDialog extends StatefulWidget {
  PSPopMoreChanceDialog({super.key});

  @override
  State<PSPopMoreChanceDialog> createState() => PSPopMoreChanceDialogState();
}

class PSPopMoreChanceDialogState extends State<PSPopMoreChanceDialog>
    with SingleTickerProviderStateMixin {
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
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context, 0);
                },
                child: PSImg(name: 'ps_close_btn', width: 48, height: 48),
              ),
              SizedBox(width: 44),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 335,
            height: 341,
            decoration: BoxDecoration(image: PSDImg('ps_channel_bg')),
            child: Column(
              children: [
                SizedBox(height: 28),
                PSStrokeText(
                  text: 'No More Chance',
                  size: 26,
                  color: '#FFFFFF'.color(),
                  weight: FontWeight.w900,
                  skWidth: 2,
                  skColor: '#1051A4'.color(),
                ),
                SizedBox(height: 37),
                PSImg(name: 'ps_channe_wheel', width: 93, height: 97),
                SizedBox(height: 5),
                PSText(
                  text: 'X2',
                  size: 24,
                  color: '#A4420B'.color(),
                  weight: FontWeight.w900,
                ),
                SizedBox(height: 35),
                ParticleButton(
                  onTap: () {
                    Navigator.pop(context, 1);
                    PigTabController.switchTo(1);
                  },
                  child: Container(
                    width: 272,
                    height: 71,
                    decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                    child: Center(
                      child: PSStrokeText(
                        text: 'Get By Quiz',
                        size: 24,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 2,
                        skColor: '#025003'.color(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// 转盘奖励
class PSPopWheelAwaradDialog extends StatefulWidget {
  final double award;
  final bool is_wheel;
  final bool is_rv;
  final AwardType type;
  PSPopWheelAwaradDialog({super.key, required this.award, required this.is_wheel, required this.is_rv, required this.type});

  @override
  State<PSPopWheelAwaradDialog> createState() => PSPopWheelAwaradDialogState();
}

class PSPopWheelAwaradDialogState extends State<PSPopWheelAwaradDialog>
    with SingleTickerProviderStateMixin {

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    ps_event_fire('double_pop', {'pop_from' : widget.type == .quiz ? 'quiz' : 'wheel'});
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // 旋转周期，可调节速度
    )..repeat(); // 无限循环
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 323,
            height: 93,
            child: Stack(
              children: [
                Positioned(
                  left: (349 - 260) * 0.5,
                  top: 32,
                  child: SizedBox(
                    width: 260,
                    height: 20,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: 260,
                          height: 20,
                          decoration: BoxDecoration(
                            image: PSDImg('ps_pro_bg_t',fit: BoxFit.fill),
                          ),
                        ),
                        Positioned(
                          left: 7,
                          child: Container(
                            width:
                            251 * (PSLocalProvider.instance.ps_pig_level == 1 ? PSLocalProvider.instance.ps_pig_level_index / 20 : PSLocalProvider.instance.ps_pig_level_index / 10),
                            height: 12,
                            decoration: BoxDecoration(
                              color: '#80F207'.color(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 180.w,
                  top: 36,
                  child: PSStrokeText(
                    text: PSLocalProvider.instance.ps_pig_level == 0 ? '${PSLocalProvider.instance.ps_dolas_number}0' :
                    '${0.to2Double(PSLocalProvider.instance.ps_pig_level_index)}/${PSLocalProvider.instance.ps_pig_level == 1 ? '20' : '10'}',
                    size: 10,
                    color: '#FFFFFF'.color(),
                    weight: FontWeight.w900,
                    skWidth: 1,
                    skColor: '#15235B'.color(),
                  ),
                ),
                Positioned(
                  left: 158.w,
                  top: 36,
                  child: PSImg(
                    name: PSLocalProvider.instance.ps_pig_level == 0 ? 'ps_dolas_2' : PSLocalProvider.instance.ps_pig_level == 1 ? 'ps_domand_s' : 'ps_zhuan_smail',
                    width: PSLocalProvider.instance.ps_pig_level == 0 ? 18 : 13,
                    height: PSLocalProvider.instance.ps_pig_level == 0 ? 17 : 11,
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 12,
                  child: PSImg(
                    name: PSLocalProvider.instance.ps_pig_level == 0 ? 'ps_pig_0' : PSLocalProvider.instance.ps_pig_level == 1
                        ? 'ps_pig_1'
                        : 'ps_pig_2',
                    width: 47,
                    height: 47,
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 30,
                  child: PSImg(name: 'ps_act_top_${PSLocalProvider.instance.ps_tx_ing_account}', width: 72, height: 25),
                ),
                Positioned(
                  left: 29,
                  top: 42,
                  child: PSStrokeText(
                      text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}',
                      size: 12,
                      color: '#FFE711'.color(),
                      weight: FontWeight.w900,
                      skWidth: 1,
                      skColor: '#042267'.color()),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 0.width(context),
            height: 66.h,
            child: Row(
              children: [
                SizedBox(width: (0.width(context) - 254.w - 30) * 0.5),
                SizedBox(
                    width: 254.w,
                    height: 66.h,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.w500,
                            color: '#FFFFF3'.color(),
                            fontFamily: 'Black_mianfeiziti'),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Just ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: PSLocalProvider.instance.ps_pig_level == 1
                                ? '20 Diamonds'
                                : '10 Gold Brick',
                            style: TextStyle(
                                color: PSLocalProvider.instance.ps_pig_level == 1
                                    ? '#03D5FF'.color()
                                    : '#FFE203'.color()),
                          ),
                          TextSpan(
                            text: ' To Cash Out!',
                          ),
                        ],
                      ),
                    )),
                SizedBox(width: 8),
                SizedBox(
                    width: 22,
                    height: 19,
                    child: PSImg(
                        name: PSLocalProvider.instance.ps_pig_level == 1
                            ? 'ps_domand_s'
                            : 'ps_zhuan_smail',
                        width: 22,
                        height: 19))
              ],
            ),
          ),
          SizedBox(height: 36.h),
          SizedBox(
            width: 239,
            height: 228,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 背景旋转
                RotationTransition(
                  turns: _controller,
                  child: Container(
                    width: 239,
                    height: 228,
                    decoration: BoxDecoration(
                      image: PSDImg('ps_wheel_award_bg'),
                    ),
                  ),
                ),
                // 上层静止内容
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20),
                    PSImg(
                      name: PSLocalProvider.instance.ps_pig_level == 1
                          ? 'ps_wheel_domand_b'
                          : 'ps_wheel_zhuan_b',
                      width: 136,
                      height: 136,
                    ),
                    PSStrokeText(
                      text: 'X${widget.award}',
                      size: 40,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 2,
                      skColor: '#5F2605'.color(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 22.h),
          PSText(
              text: 'Money’s in-ready To Withdraw!',
              size: 18,
              color: '#E8E893'.color(),
              weight: FontWeight.w900),
          SizedBox(height: 20.h),
          ParticleButton(
            onTap: () {
              ps_event_fire('double_pop_c', {'pop_from' : widget.type == .quiz ? 'quiz' : 'wheel'});
              PSPigAds().ps_showAd(context, adRewardPod_idName(), onCacheResponse: (onCacheResponse) async {
                Navigator.pop(context, 1);
              }, adDidClosed: (adDidClosed) async {
                Navigator.pop(context, 1);
                if (PSLocalProvider.instance.ps_pig_level == 1){
                  await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_pig_level_indexName, (widget.award * 1.0) + PSLocalProvider.instance.ps_pig_level_index);
                  if (!context.mounted) return;
                  context.tipShow2(PSPoGetAwardDog(award: widget.award),bc: Colors.transparent);
                } else {
                  await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_pig_level_indexName, (widget.award * 2.0) + PSLocalProvider.instance.ps_pig_level_index);
                  if (!context.mounted) return;
                  context.tipShow2(PSPoGetAwardDog(award: widget.award),bc: Colors.transparent);
                }
              });
            },
            child: Container(
              width: 272,
              height: 71,
              decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
              child: Stack(
                children: [
                  Center(
                    child: PSStrokeText(
                      text: PSLocalProvider.instance.ps_pig_level == 1 ? 'Collect' : 'Collect Double',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 2,
                      skColor: '#025003'.color(),
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: 0,
                    child: PSImg(name: 'ps_ad_icon', width: 37, height: 40),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          PSUnderlineTextButton(
            text: 'Claim',
            underlineColor: '#F1EFB2'.color(),
            textColor: '#F1EFB2'.color(),
            fontSize: 20,
            onPressed: (){
              ps_event_fire('double_pop_c', {'pop_from' : widget.type == .quiz ? 'quiz' : 'wheel'});
              if (PSNumberHelpers().checkProbability()){
                PSPigAds().ps_showAd(context, adIntPod_idName(), onCacheResponse: (onCacheResponse){
                  Navigator.pop(context, 0);
                }, adDidClosed: (adDidClosed){
                  Navigator.pop(context, 0);
                });
              } else {
                Navigator.pop(context, 0);
              }
            },
          )
        ],
      ),
    );
  }

  String adIntPod_idName(){
    if (widget.type == .apple) {
      return 'nskdh_applebub_getpop_int';
    } else if (widget.type == .quiz){
      return 'nskdh_quizgetinfor_int';
    } else if (widget.type == .buble){
      return 'nskdh_moneybub_getpop_int';
    } else if (widget.type == .wheel){
      return 'nskdh_wheel_int';
    } else {
      return 'nskdh_launch';
    }
  }

  String adRewardPod_idName(){
    if (widget.type == .apple) {
      return 'asd_rv';
    } else if (widget.type == .quiz){
      return 'nskdh_quizgetc_rv';
    } else if (widget.type == .buble){
      return 'nskdh_moneybub_getpop_rv';
    } else if (widget.type == .wheel){
      return 'nskdh_wheel_rv';
    } else {
      return 'nskdh_launch';
    }
  }
}

// 老用户弹窗
class PSPopWheelOldDog extends StatefulWidget {
  PSPopWheelOldDog({super.key});

  @override
  State<PSPopWheelOldDog> createState() => PSPopWheelOldDogState();
}

class PSPopWheelOldDogState extends State<PSPopWheelOldDog>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    ps_event_fire('no_chance_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Spacer(),
              ParticleButton(child: PSImg(name: "ps_close_icon", width: 40, height: 40), onTap: (){
                if (Navigator.canPop(context)) {
                  Navigator.pop(context, 0);
                }
              }),
              SizedBox(width: 27)
            ],
          ),
          SizedBox(height: 18),
          Container(
            width: 335,
            height: 341,
            decoration: BoxDecoration(
              image: PSDImg('ps_old_wheel_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 29),
                PSStrokeText(text: 'Daily Bonus', size: 22, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1051A4'.color()),
                SizedBox(height: 36),
                PSText(text: 'Spin The Wheel Daily For Prize!', size: 14, color: '#733A1B'.color(), weight: FontWeight.w900),
                SizedBox(height: 152),
                ParticleButton(
                  onTap: () {
                    ps_event_fire('no_chance_pop_c', {});
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context, 0);
                    }
                    PigTabController.switchTo(1);
                  },
                  child: Container(
                    width: 272,
                    height: 71,
                    decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                    child: Center(
                      child: PSStrokeText(
                        text: 'Go Earn',
                        size: 24,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 2,
                        skColor: '#025003'.color(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
// 存钱罐弹窗
class PSPopCunCashDog extends StatefulWidget {
  final PSUserData userData;
  final bool is_gold;
  PSPopCunCashDog({
    super.key, required this.userData, required this.is_gold,
  });

  @override
  State<PSPopCunCashDog> createState() => PSPopCunCashDogState();
}

class PSPopCunCashDogState extends State<PSPopCunCashDog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int row = Random().nextInt(3);

  // 3条不重复文案
  late List<String> msgs = getRandomMessages(
      widget.is_gold ? _messages : _messages2);

  final List<String> _messages = [
    "Just withdrew ${0.dolasType()}12.75—this app really pays!",
    "Just got ${0.dolasType()}10 on PayPal — it’s real!",
    "Cashed out ${0.dolasType()}15 today, straight to my account.",
    "${0.dolasType()}20 received instantly, no fees at all.",
    "Got my payout! Earning while watching ads works.",
    "Withdrawn ${0.dolasType()}25 successfully, money in my PayPal now.",
  ];

  final List<String> _messages2 = [
    "Just started, already made ${0.dolasType()}0.85 by watching ads!",
    "Watched a couple of ads and boom — ${0.dolasType()}0.85 in my balance!",
    "Didn’t think it’d work, but after a few minutes I got my first cents. Feels real!",
  ];

  @override
  void initState() {
    super.initState();
    ps_event_fire('showpig_page', {});

    // 初始化动画控制器，持续时间为5秒，可以调整速度
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    // Tween从0到1，重复无限循环
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.repeat(); // 无限循环
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 随机取 [count] 条不重复消息，默认 3 条
  List<String> getRandomMessages(List<String> msg, {int count = 3}) {
    if (count >= msg.length) {
      return List.from(msg); // 如果请求数 >= 总数，返回所有
    }

    final random = Random();
    final tempList = List<String>.from(msg); // 复制一份防止修改原始列表
    final result = <String>[];

    for (int i = 0; i < count; i++) {
      int index = random.nextInt(tempList.length);
      result.add(tempList[index]);
      tempList.removeAt(index); // 移除已选的，保证不重复
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double bgWidth = 210; // ps_pop_act_bg 宽度
    double bg2Width = 302; // ps_pop_act_bg 宽度

    // 计算平移距离
    double translateX =
        -((_animation.value * (bgWidth + screenWidth)) %
            (bgWidth + screenWidth)) + screenWidth;
    double translateX2 =
        -((_animation.value * (bg2Width + screenWidth)) %
            (bg2Width + screenWidth)) + screenWidth;

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 32.h),
            Row(
              children: [
                Spacer(),
                // 添加平移动画
                Transform.translate(
                  offset: Offset(translateX, 0),
                  child: Container(
                    width: bgWidth,
                    height: 42,
                    decoration: BoxDecoration(
                      image: PSDImg('ps_pop_act_bg'),
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 7),
                        PSImg(name: 'ps_act_pop_icon', width: 34, height: 34),
                        SizedBox(width: 9),
                        SizedBox(
                          width: 134,
                          height: 32,
                          child: RichText(
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 9.0,
                                fontWeight: FontWeight.w900,
                                color: '#000000'.color(),
                                fontFamily: 'Black_mianfeiziti',
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'PayPal ',
                                  style: TextStyle(color: '#1E60EF'.color()),
                                ),
                                TextSpan(text: 'Sent '),
                                TextSpan(
                                  text:
                                  '${0.dolasType()}${PSNumberHelpers().intModel!
                                      .eqRange[row]} ',
                                  style: TextStyle(color: '#19912B'.color()),
                                ),
                                TextSpan(
                                  text: ' To ${widget.userData.username}.',
                                ),
                                TextSpan(text: 'Withdrawal Completed'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
              ],
            ),
            SizedBox(height: 10.h),
            Transform.translate(
              offset: Offset(translateX2, 0),
              child: SizedBox(
                width: 0.width(context),
                height: 49,
                child: Stack(
                  children: [
                    Positioned(
                      left: 40.w,
                      top: 10.h,
                      child: Container(
                        width: 302,
                        height: 25,
                        decoration: BoxDecoration(
                            image: PSDImg('ps_text_bg')
                        ),
                        child: Center(
                          child: PSText(text: msgs.first,
                              size: 10,
                              color: '#691C1C'.color(),
                              weight: FontWeight.w900),
                        ),
                      ),
                    ),
                    PSImg(name: 'ps_user_n_${widget.userData.id}',
                        width: 49,
                        height: 49),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Transform.translate(
              offset: Offset(translateX2 + 30.w, 0),
              child: SizedBox(
                width: 0.width(context),
                height: 49,
                child: Stack(
                  children: [
                    Positioned(
                      left: 40.w,
                      top: 10.h,
                      child: Container(
                        width: 302,
                        height: 25,
                        decoration: BoxDecoration(
                            image: PSDImg('ps_text_bg')
                        ),
                        child: Center(
                          child: PSText(text: msgs[1],
                              size: 10,
                              color: '#691C1C'.color(),
                              weight: FontWeight.w900),
                        ),
                      ),
                    ),
                    PSImg(name: 'ps_user_n_${widget.userData.id}',
                        width: 49,
                        height: 49),
                  ],
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Transform.translate(
              offset: Offset(translateX2 + 70.w, 0),
              child: SizedBox(
                width: 0.width(context),
                height: 49,
                child: Stack(
                  children: [
                    Positioned(
                      left: 40.w,
                      top: 10.h,
                      child: Container(
                        width: 302,
                        height: 25,
                        decoration: BoxDecoration(
                            image: PSDImg('ps_text_bg')
                        ),
                        child: Center(
                          child: PSText(text: msgs.last,
                              size: 10,
                              color: '#691C1C'.color(),
                              weight: FontWeight.w900),
                        ),
                      ),
                    ),
                    PSImg(name: 'ps_user_n_${widget.userData.id}',
                        width: 49,
                        height: 49),
                  ],
                ),
              ),
            ),
            SizedBox(height: 198.h),
            Transform.translate(
              offset: Offset(translateX2 + 0.w, 0),
              child: Container(
                width: 210,
                height: 32,
                decoration: BoxDecoration(
                    color: '#F3D516'.color(),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Center(
                  child: PSStrokeText(text: 'Earnings From Quiz Game',
                      size: 14,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 1,
                      skColor: '#000000'.color()),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Transform.translate(
              offset: Offset(translateX2 + 70.w, 0),
              child: Container(
                width: 210,
                height: 32,
                decoration: BoxDecoration(
                    color: '#24A7ED'.color(),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    SizedBox(width: 43.w),
                    PSStrokeText(text: 'Ads Watched:',
                        size: 14,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#000000'.color()),
                    PSStrokeText(text: ' ${widget.userData.adsWatched}',
                        size: 14,
                        color: '#F3D515'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#000000'.color()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Transform.translate(
              offset: Offset(translateX2 + 10.w, 0),
              child: Container(
                width: 210,
                height: 32,
                decoration: BoxDecoration(
                    color: '#3BC14F'.color(),
                    borderRadius: BorderRadius.circular(16)
                ),
                child: Row(
                  children: [
                    SizedBox(width: 28.w),
                    PSStrokeText(text: 'Total Earning:',
                        size: 14,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#000000'.color()),
                    PSStrokeText(text: ' ${0.dolasType()}${widget.userData.totalEarning}',
                        size: 14,
                        color: '#F3D515'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#000000'.color()),
                  ],
                ),
              ),
            ),
            SizedBox(height: 64.h),
            ParticleButton(
              onTap: () {
                ps_event_fire('showpig_page_c', {});
              if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                PigTabController.switchTo(Random().nextInt(2) + 1);
              },
              child: Container(
                width: 272,
                height: 71,
                decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                child: Center(
                  child: PSStrokeText(
                    text: 'Go Earn',
                    size: 24,
                    color: '#FFFFFF'.color(),
                    weight: FontWeight.w900,
                    skWidth: 2,
                    skColor: '#025003'.color(),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: (0.width(context) - 211) * 0.5,
          top: 148.h,
          width: 211,
          height: 208,
          child: Container(
            width: 211,
            height: 208,
            decoration: BoxDecoration(
              image: PSDImg('ps_b_pig_icon_${widget.is_gold == true ? 2 : 0}')
            ),
            child: Column(
              children: [
                Spacer(),
                Padding(padding: EdgeInsetsGeometry.only(left: !widget.is_gold == 1 ? 38 : 52),child: PSImg(name: 'ps_${!widget.is_gold ? 0 : 2}_${getIntervalValue(widget.is_gold == true ? 2 : 0, widget.is_gold == true ? 20 : widget.userData.totalEarning)}', width: 78.02, height: 67.21)),
                if (!widget.is_gold)
                  SizedBox(height: 50),
                if (widget.is_gold)
                  SizedBox(height: 52),
              ],
            ),
          ),
        ),
        Positioned(
          top: 330.h,
          left: (0.width(context) - 141) * 0.5,
          child: Container(
            width: 141,
            height: 34,
            decoration: BoxDecoration(
              image: PSDImg('ps_act_bg'),
            ),
            child: Consumer<PSLocalProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PSImg(
                        name: 'ps_dolas_2',
                        width: 26,
                        height: 21),
                    SizedBox(width: 5),
                    PSText(
                      text:
                      '${0.dolasType()}${widget.userData.totalEarning}',
                      size: 20,
                      color: '#8B0002'.color(),
                      weight: FontWeight.w900,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 27.w,
          top: 128.h,
          child: ParticleButton(
            child: PSImg(name: "ps_close_icon", width: 40, height: 40),
            onTap: () {
              Navigator.pop(context, 0);
            },
          ),
        ),
      ],
    );
  }

  // 根据不同类型获取当前的翻位置
  int getIntervalValue(int type, double value) {
    // 固定区间
    final List<int> intervals = [25, 50, 75, 100];

    // 最大值根据 type
    double maxValue;
    switch (type) {
      case 0:
        maxValue = 100;
        break;
      case 1:
        maxValue = 20;
        break;
      case 2:
        maxValue = 10;
        break;
      default:
        maxValue = 10;
        type = 2;
    }

    // 限制 value 在 0~maxValue 之间
    value = value.clamp(0, maxValue);

    // 每个区间长度
    double segment = maxValue / 4;

    // 计算落在哪个区间
    int index = (value / segment).ceil() - 1;
    if (index < 0) index = 0;
    if (index > 3) index = 3;

    return intervals[index];
  }
}

// 获取收益
class PSPoGetAwardDog extends StatefulWidget {
  final double award;
  PSPoGetAwardDog({super.key, required this.award});

  @override
  State<PSPoGetAwardDog> createState() => PSPoGetAwardDogState();
}

class PSPoGetAwardDogState extends State<PSPoGetAwardDog>
    with SingleTickerProviderStateMixin {

  late spine.SpineWidgetController _controller;

  @override
  void initState() {
    super.initState();

    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
    // 页面 2 秒后自动关闭
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context, 0);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.width(context),
      height: 0.height(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 256,
            height: 57,
            decoration: BoxDecoration(
                color: '#000000'.color(opacity: 0.7),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                if (PSLocalProvider.instance.ps_pig_level == 0)
                 PSGradientStrokeText(text: 'My Account: ', gradientColors: ['#FFFFFF'.color(), '#FFF47F'.color()], width: 138, height: 57, fontSize: 22),
                if (PSLocalProvider.instance.ps_pig_level == 0)
                  PSGradientNumberRoller(
                  value: PSLocalProvider.instance.ps_dolas_number,
                  duration: 800,
                  fontSize: 22.0,
                  gradientColors: ['#FFFFFF'.color(), '#FFF47F'.color()],
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  decimalPlaces: 2,
                ),
                if (PSLocalProvider.instance.ps_pig_level == 1 || PSLocalProvider.instance.ps_pig_level == 2)
                  PSGradientStrokeText(text: 'Pending Amount:', gradientColors: ['#FFFFFF'.color(), '#FFF47F'.color()], width: 138, height: 57, fontSize: 18),
                if (PSLocalProvider.instance.ps_pig_level == 1 || PSLocalProvider.instance.ps_pig_level == 2)
                  SizedBox(width: 8),
                if (PSLocalProvider.instance.ps_pig_level == 1 || PSLocalProvider.instance.ps_pig_level == 2)
                  PSGradientNumberRoller(
                    value: PSLocalProvider.instance.ps_dolas_number,
                    duration: 800,
                    fontSize: 18.0,
                    gradientColors: ['#FFFFFF'.color(), '#FFF47F'.color()],
                    borderColor: Colors.transparent,
                    borderWidth: 0.0,
                    decimalPlaces: 2,
                    showDolas: false,
                  ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          Container(
            width: 256,
            height: 219,
            decoration: BoxDecoration(
                color: '#000000'.color(opacity: 0.7),
                borderRadius: BorderRadius.circular(16)
            ),
            child: Column(
              children: [
                SizedBox(height: 18),
                if (PSLocalProvider.instance.ps_pig_level == 0)
                  PSStrokeText(text: 'Earned ${0.dolasType()}${widget.award}', size: 20, color: '#FFDD00'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1D0808'.color()),
                if (PSLocalProvider.instance.ps_pig_level == 0)
                  SizedBox(
                    width: 111,
                    height: 109,
                    child: spine.SpineWidget.fromAsset('assets/spine/pink/skeleton.atlas', 'assets/spine/pink/skeleton.skel', _controller),
                  ),
                if (PSLocalProvider.instance.ps_pig_level == 1)
                  PSStrokeText(text: 'Earned X${widget.award} Daimond', size: 20, color: '#FFDD00'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1D0808'.color()),
                if (PSLocalProvider.instance.ps_pig_level == 1)
                 SizedBox(
                  width: 111,
                  height: 109,
                  child: spine.SpineWidget.fromAsset('assets/spine/blue/skeleton.atlas', 'assets/spine/blue/skeleton.skel', _controller),
                 ),
                if (PSLocalProvider.instance.ps_pig_level == 2)
                  PSStrokeText(text: 'Earned X${widget.award} Gold', size: 20, color: '#FFDD00'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1D0808'.color()),
                if (PSLocalProvider.instance.ps_pig_level == 2)
                  SizedBox(
                    width: 111,
                    height: 109,
                    child: spine.SpineWidget.fromAsset('assets/spine/golden/skeleton.atlas', 'assets/spine/golden/skeleton.skel', _controller),
                  ),
                SizedBox(height: 11),
                if (PSLocalProvider.instance.ps_pig_level == 1 || PSLocalProvider.instance.ps_pig_level == 2)
                 PSText(text: 'X${widget.award}', size: 24, color: '#16E927'.color(), weight: FontWeight.w900),
                if (PSLocalProvider.instance.ps_pig_level == 0)
                  PSText(text: '+${0.dolasType()}${widget.award}', size: 24, color: '#16E927'.color(), weight: FontWeight.w900),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
