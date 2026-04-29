import 'dart:math';

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
                        PSText(text: 'Account Name：12***22.@gamial', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        SizedBox(width: 12.w),
                        PSText(text: 'Payment Method:', size: 14, color: '#264077'.color(), weight: FontWeight.w900),
                        SizedBox(width: 14.w),
                        PSImg(name: 'ps_pangle_icon', width: 116, height: 40)
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
    );
  }

}
// 准备提现
class PSAboutTXDialog extends StatefulWidget {
  const PSAboutTXDialog({super.key});

  @override
  State<PSAboutTXDialog> createState() => PSAboutTXDialogState();
}

class PSAboutTXDialogState extends State<PSAboutTXDialog>
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
                    PSStrokeText(text: '\$100', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 26.h),
              ParticleButton(
                onTap: (){

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

                    },
                    child: Container(
                      width: 116.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_act_0')
                      ),
                    ),
                  ),
                  SizedBox(width: 22.w),
                  ParticleButton(
                    onTap: (){

                    },
                    child: Container(
                      width: 116.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_act_1')
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
    );
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
  const PSQuizRankTwoDialog({super.key});

  @override
  State<PSQuizRankTwoDialog> createState() => PSQuizRankTwoDialogState();
}

class PSQuizRankTwoDialogState extends State<PSQuizRankTwoDialog>
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
        SizedBox(
          width: 270.w,
          height: 50.h,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Black_mianfeiziti',
                  color: '#FFFFFF'.color()
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Top Answerer\n',
                ),
                TextSpan(
                  text: 'withdrawal made easy!! ',
                  style: TextStyle(color: '#FFB300'.color()),
                ),
              ],
            ),
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
        Container(
          width: 280.w,
          height: 58.5.h,
          decoration: BoxDecoration(
            image: PSDImg('ps_keep_btn')
          ),
          child: InkWell(
            onTap: (){

            },
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
// 信息确认1
class PSConfimOneDialog extends StatefulWidget {
  const PSConfimOneDialog({super.key});

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
      children: [
        SizedBox(height: 177.h),
        FadeTransition(
          opacity: _iconFadeAnimation,
          child: PSImg(name: 'ps_dui_b_icon', width: 131, height: 131),
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
              child: PSImg(name: 'ps_tip_title_center', width: 301.5, height: 70.5),
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
  const PSTXOutDialog({super.key});

  @override
  State<PSTXOutDialog> createState() => PSTXOutDialogState();
}

class PSTXOutDialogState extends State<PSTXOutDialog>
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
                    PSStrokeText(text: '\$100', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
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
                      text: '\$4 ',
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
  const PSTXLastDialog({super.key});

  @override
  State<PSTXLastDialog> createState() => PSTXLastDialogState();
}

class PSTXLastDialogState extends State<PSTXLastDialog>
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
                    image: PSDImg('ps_act_bg_0')
                ),
                child: Column(
                  children: [
                    SizedBox(height: 56.h),
                    PSStrokeText(text: '\$100', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(width: 205, height: 38,child: PSText(text: 'Only one step away from successful withdrawal', size: 16, color: '#134475'.color(), weight: FontWeight.w900, maxLines: 2,align: .center)),
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
                    PSText(text: 'Answer 10/50 question right', size: 16, color: '#12881E'.color(), weight: FontWeight.w900),
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
                            width: 249.w * 0.5,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: '#1757B1'.color(),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                          ),
                          Positioned(top: 5.h,left: 110.w,child: PSStrokeText(text: '100%', size: 10, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#113996'.color()))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              ParticleButton(
                onTap: (){

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
// 排行榜
class PSTXRankDialog extends StatefulWidget {
  const PSTXRankDialog({super.key});

  @override
  State<PSTXRankDialog> createState() => PSTXRankDialogState();
}

class PSTXRankDialogState extends State<PSTXRankDialog>
    with SingleTickerProviderStateMixin {

  final List<String> texts = List.generate(PSLocalProvider.instance.ps_all_ranking, (index) => '${index+1}');

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
  List possibleValues = ["\$100", "\$150", "\$200", "\$500"];
  // 生成列表
  List<String> _generateDolasList() {
    List<String> list = List.filled(PSLocalProvider.instance.ps_all_ranking, ""); // 初始化一个长度为200的空字符串列表

    for (int i = 0; i < list.length; i++) {
      if (i == PSLocalProvider.instance.ps_current_ranking - 1) { // 第90个位置（索引为89）
        list[i] = "\$${possibleValues[PSLocalProvider.instance.ps_tx_ing_number]}";
      } else {
        // 随机选择一个可能的金额值
        list[i] = possibleValues[random.nextInt(possibleValues.length)];
      }
    }
    return list;
  }

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
                    PSStrokeText(text: '\$100', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
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

                },
                child: Container(
                  width: 239.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(25.h)
                  ),
                  child: Center(
                    child: PSText(text: 'Skip Wait', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
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
                      text: '\$60 ',
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

}
// 引导4
class PSGuide4Dialog extends StatefulWidget {
  const PSGuide4Dialog({super.key});

  @override
  State<PSGuide4Dialog> createState() => PSGuide4DialogState();
}

class PSGuide4DialogState extends State<PSGuide4Dialog>
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
                    PSText(text: '\$158.00', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
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
                        text: 'to speed up your ',
                      ),
                      TextSpan(
                        text: '\$100 ',
                        style: TextStyle(color: '#17931B'.color()),
                      ),
                      TextSpan(
                        text: ' payout',
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 28),
              InkWell(
                onTap: (){
                  Navigator.pop(context, 1);
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
                    PSText(text: '\$158.00', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
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
            Navigator.pop(context, 1);
          },
          child: Container(
            width: 272,
            height: 71,
            decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
            child: Center(
              child: PSStrokeText(
                text: 'Try It Now',
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
  final bool isGuide;
  const PSPopAwardToolDialog({super.key, required this.type, required this.isGuide});

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
                    ParticleButton(
                      onTap: (){
                        Navigator.pop(context, 1);
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
          Navigator.pop(context, 0);
        })
      ],
    );
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
          height: 325.h,
          decoration: BoxDecoration(
              image: PSDImg('ps_about_bg')
          ),
          child: Column(
            children: [
              SizedBox(height: 32.h),
              PSText(text: '⚡ Advertiser Review Pending', size: 18, color: '#264077'.color(), weight: FontWeight.w900),
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
                    PSStrokeText(text: '\$100', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#000000'.color()),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: 283.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: '#E4E9EC'.color(),
                    borderRadius: BorderRadius.circular(16.h)
                ),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
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
                            width: 249.w * 0.4,
                            height: 20.h,
                            decoration: BoxDecoration(
                              color: '#1757B1'.color(),
                              borderRadius: BorderRadius.circular(10.h),
                            ),
                          ),
                          Positioned(top: 5.h,left: 110.w,child: PSStrokeText(text: '40%', size: 10, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#113996'.color()))
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    PSText(text: 'Review in progress...', size: 14, color: '#6B7C8B'.color(), weight: FontWeight.w900),
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
