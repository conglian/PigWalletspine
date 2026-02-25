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
                  PSAdAHelper().resetBlock();
                },
                (finished) async {
                  PSAdAHelper().resetBlock();
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
                  }
                  if (PSLocalProvider.instance.ps_pig_level == 1 && PSLocalProvider.instance.ps_pig_level_index >= 10){
                    await PSLocalProvider.instance.updateint(
                      PSLocalProvider.instance.ps_pig_level_indexName,
                      10,
                    );
                  }
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
