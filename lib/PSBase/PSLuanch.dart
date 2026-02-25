import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../PSGuide/PSGuideAOne.dart';
import '../PSHome/PSHome.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import 'PSTbaBar.dart';

class PSLaunch extends StatefulWidget {
  PSLaunch({super.key});

  @override
  State<PSLaunch> createState() => PSLaunchState();
}

class PSLaunchState extends State<PSLaunch>
    with SingleTickerProviderStateMixin {
  var _daydateString = '';

  @override
  void initState() {
    super.initState();
    _setConfigDateInfoData();
    // Future.delayed(Duration(milliseconds: 2),(){
    //   ps_getSBUserCloakConfig();
    // });
    // ps_event_fire('launch_page', {});
  }

  Future<void> _setConfigDateInfoData() async {
    // text
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _daydateString = prefs.getString('ps_day_date') ?? '';
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);
    prefs.setBool('ps_old_guide', true);
    if (_daydateString == '') {
      prefs.setString('ps_day_date', formattedDate);
      // 首次
      prefs.setBool('ps_first_instll', true);
    } else {
      if (_daydateString != formattedDate) {
        // 隔天
        prefs.setString('ps_day_date', formattedDate);
        prefs.setBool('ps_old_guide', false);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PSImg(
            name: 'ps_luanch_bg',
            width: 0.width(context),
            height: 0.height(context),
          ),
          Column(
            children: [
              SizedBox(height: 25.h),
              PSImg(name: 'ps_logo_icons', width: 352, height: 236),
              Spacer(),
              SJGradientProgressBar(
                onCompleted: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => !PSLocalProvider.instance.ps_newA_guide
                          ? PSGuideOne(key: homeKey)
                          : PigBottomExample(key: homeKey),
                    ),
                  );
                },
              ),
              SizedBox(height: 195.h),
            ],
          ),
        ],
      ),
    );
  }
}

class SJGradientProgressBar extends StatefulWidget {
  final VoidCallback? onCompleted; // ✅ 动画完成后的回调

  const SJGradientProgressBar({super.key, this.onCompleted});

  @override
  State<SJGradientProgressBar> createState() => _SJGradientProgressBarState();
}

class _SJGradientProgressBarState extends State<SJGradientProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final double barWidth = 307;
  final double barHeight = 30;
  final double progressHeight = 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // ✅ 动画完成回调
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onCompleted != null) {
        widget.onCompleted!();
      }
    });

    // 启动动画
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: barWidth,
      height: barHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背景图片
          Positioned.fill(child: PSImg(name: 'ps_pro_bg')),
          // 进度条
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final progressWidth = barWidth * _animation.value;
              final progressPercent = (_animation.value * 100)
                  .clamp(0, 100)
                  .toInt();
              return Stack(
                alignment: Alignment.center,
                children: [
                  // 渐变进度条
                  Positioned(
                    left: 4,
                    top: 2,
                    child: Container(
                      width: max(0, progressWidth - 8),
                      height: progressHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            '#E8C70C'.color(),
                            '#FFE659'.color(),
                            '#B47405'.color(),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                  // ✅ 居中显示百分比文字
                  Center(
                    child: Text(
                      '$progressPercent%',
                      style: TextStyle(
                        fontFamily: 'Black_mianfeiziti',
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            blurRadius: 2,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 进度前端跟随图片
                  // Positioned(
                  //   left: (progressWidth - 20).clamp(0, barWidth - 20),
                  //   top: -3,
                  //   child: PSImg(name: 'ps_luach_xing', width: 30, height: 30),
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
