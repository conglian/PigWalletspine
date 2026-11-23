import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'dart:math';

import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:provider/provider.dart';

class PigWheelPage extends StatefulWidget {
  final imagePath;

  const PigWheelPage({super.key, this.imagePath});

  @override
  _PigWheelPageState createState() => _PigWheelPageState();
}

class _PigWheelPageState extends State<PigWheelPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _rotationAngle = 0.0;
  bool _isAnimating = false;
  StreamSubscription? _wheelSubscription;

  // 假设转盘有8个奖项，每个奖项占45度
  final int itemCount = 8;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _rotationAngle = _animation.value;
        });
      }
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _isAnimating = false;
          });
        }
      }
    });
    _submitWheelIndex();
  }

  void _submitWheelIndex() {
    _wheelSubscription = WheelStartNotificationService.stream.listen((value) {
      startRotation(value);
    });
  }

  @override
  void dispose() {
    _wheelSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // 添加复位功能（无动画）
  void _resetWheel() {
    if (_isAnimating) return;
    if (mounted) {
      setState(() {
        _rotationAngle = 0.0; // 直接重置角度为0
      });
    }
  }

  void startRotation(int targetIndex) {
    if (_isAnimating) return;
    if (!mounted) return;
    _resetWheel();
    if (mounted) {
      setState(() {
        _isAnimating = true;
      });
    }

    // 计算目标角度 (确保停在两个奖项中间)
    double targetAngle =
        360 - (targetIndex * (360 / itemCount) + (360 / itemCount / 1.03));

    // 计算总旋转角度 (5圈 + 到目标位置的角度)
    double totalRotation = 5 * 360 + targetAngle;

    // 创建从当前角度到总旋转角度的动画曲线
    _animation =
        Tween<double>(
          begin: _rotationAngle % 360,
          end: _rotationAngle + totalRotation,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.decelerate, // 减速曲线实现从快到慢的效果
          ),
        );

    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // 转盘
                Transform.rotate(
                  angle: _rotationAngle * (pi / 180), // 将角度转换为弧度
                  child: Container(
                    width: 340.w,
                    height: 340.w,
                    decoration: BoxDecoration(image: PSDImg(widget.imagePath)),
                    child: Consumer<PSLocalProvider>(
                      builder: (context, provider, child) {
                        final prizes = PSNumberHelpers().getPrizeWithDolasNSize(
                          provider.ps_dolas_number,
                        );
                        final label = SizedBox(
                          width: 120.w,
                          height: 34,
                          child: PSStrokeText(
                            text:
                                '${PSLocale.money(prizes.first)} – ${PSLocale.money(prizes.last)}',
                            size: 14,
                            maxLines: 2,
                            color: Colors.white,
                            weight: FontWeight.w900,
                            skWidth: 2,
                            skColor: '#038719'.color(),
                          ),
                        );
                        return Column(
                          children: [
                            SizedBox(height: 45.h),
                            label,
                            const Spacer(),
                            Transform.rotate(angle: pi, child: label),
                            SizedBox(height: 45.h),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WheelStartNotificationService {
  static final StreamController<int> _streamController =
      StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToStartIndexNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}
