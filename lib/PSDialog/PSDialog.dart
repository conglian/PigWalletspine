import 'package:fl_toast/fl_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';

import '../PSTool/PSAdAManger.dart';
import '../PSTool/ps_LocalProvider.dart';
import '../PSTool/ps_extension_help.dart';

enum AdStatus {
  adLoadfaild,
  notWifi,
  adLimit,
  noticeOpen,
  notWheel
}

enum AwardType {
  dolas,
  diamonds,
  ingots,
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

                } else if (widget.adStatus == .notWifi) {

                } else if (widget.adStatus == .adLimit) {

                } else if (widget.adStatus == .noticeOpen) {

                } else if (widget.adStatus == .notWheel) {

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
// 奖励通用
class PSPopAwardToolDialog extends StatefulWidget {
  final AwardType type;
  const PSPopAwardToolDialog({super.key, required this.type});

  @override
  State<PSPopAwardToolDialog> createState() => PSPopAwardToolDialogState();
}

class PSPopAwardToolDialogState extends State<PSPopAwardToolDialog>
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
                            fontSize: 24.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Black_mianfeiziti',
                            color: '#134475'.color()
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Only ',
                          ),
                          TextSpan(
                            text: '\$4',
                            style: TextStyle(color: '#0E731E'.color()),
                          ),
                          TextSpan(
                            text: ' Left To Cash Out',
                          ),
                        ],
                      ),
                    ),
                    if (widget.type == .dolas)
                      SizedBox(height: 34.h),
                    if (widget.type == .diamonds)
                      SizedBox(height: 10.h,),
                    if (widget.type == .diamonds)
                      Container(
                        width: 273.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          color: '#F54E00'.color(),
                          borderRadius: BorderRadius.circular(11.h)
                        ),
                        child: Center(
                          child: PSText(text: '5 diamonds can be exchanged for \$0.01', size: 12, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                        ),
                      ),
                    if (widget.type == .diamonds)
                      SizedBox(height: 19.h,),
                    if (widget.type == .dolas)
                      PSImg(name: "ps_dolas_b", width: 90.w, height: 79.h),
                    if (widget.type == .diamonds)
                      PSImg(name: "ps_doamond_b", width: 119.w, height: 88.h),
                    PSText(text: '+\$2.0', size: 24, color: widget.type == .dolas ? '#199E24'.color() : '#1562CD'.color(), weight: FontWeight.w900),
                    SizedBox(height: widget.type == .dolas ? 13.h : 5.h),
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
                    SizedBox(height: widget.type == .dolas ? 36.h : 20.h),
                    Container(
                      width: 301.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_award_center_bg')
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 25.w,),
                          PSImg(name: 'ps_act_samil_0', width: 54.w, height: 27.h),
                          SizedBox(width: 15.w,),
                          PSImg(name: 'ps_payment_icon', width: 67.w, height: 21.h),
                          SizedBox(width: 24.w,),
                          PSText(text: 'My Cash :\$516', size: 14, color: '#0C7A29'.color(), weight: FontWeight.w900)
                        ],
                      ),
                    ),
                    SizedBox(height: 19.h),
                    Container(
                      width: 301.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          color: '#0E79C6'.color(),
                          borderRadius: BorderRadius.circular(25.h)
                      ),
                      child: Center(
                        child: PSText(text: 'Claim', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                      ),
                    )
                  ],
                )
            ),
            Positioned(bottom: 39.h, right: 22.w,child: PSImg(name: 'ps_ad_icon', width: 37, height: 40))
          ],
        ),
        SizedBox(height: 16.h),
        ParticleButton(child: SizedBox(width: 40,height: 40,child: Center(child: PSImg(name: 'ps_whine_close', width: 18, height: 18 , fit: BoxFit.fill,))), onTap: (){
          Navigator.pop(context, 0);
        })
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
                PSImg(name: PSLocalProvider.instance.ps_pig_level == 0 ? 'ps_domand_icon' : 'ps_zhuan_big', width: 136, height: 119),
                Positioned(
                  bottom: 0,
                  child: PSStrokeText(
                    text: 'X2',
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
                  await PSLocalProvider.instance.updateint(
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
