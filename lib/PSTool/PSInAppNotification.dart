import 'PSLocale.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import '../PSBase/PSTbaBar.dart';
import 'PSTBAEventTool.dart';

class PSInAppNotification {
  static final PSInAppNotification _instance = PSInAppNotification._internal();
  factory PSInAppNotification() => _instance;
  PSInAppNotification._internal();

  OverlayEntry? _overlayEntry;
  Timer? _timer;
  bool _isShowing = false;
  final Random _random = Random();

  // 可随机金额列表
  final List<int> _amounts = [100, 120, 150, 200];

  final List<String> _names = [
    'Mary',
    'James',
    'Linda',
    'Robert',
    'Sarah',
    'Michael',
  ];

  int _currentIndex = 0;

  /// 初始化计时器
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      prefs.setBool('first_launch', false);
      _startTimer(_random.nextInt(2) + 1); // 测试用 1~2 分钟
    } else {
      _startTimer(_random.nextInt(6) + 5); // 5~10 分钟
    }
  }

  void _startTimer(int minutes) {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: minutes), () {
      final amount = _amounts[_random.nextInt(_amounts.length)];
      final content = PSLocale.tr('{p0} received {p1} via {p2} successfully', {
        'p0': _names[_currentIndex],
        'p1': PSLocale.money(amount),
        'p2': PSLocale.payment(0),
      });
      _showNotification(PSLocale.tr('Withdrawal Sent'), content);
      _currentIndex = (_currentIndex + 1) % _names.length;

      // 下一条 5~10 分钟
      _startTimer(_random.nextInt(6) + 5);
    });
  }

  void dispose() {
    _timer?.cancel();
    _overlayEntry?.remove();
  }

  void _showNotification(String title, String content) {
    ps_event_fire('push_appin_p', {});

    if (_isShowing) return;
    _isShowing = true;
    Random random = Random();
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return _NotificationWidget(
          title: title,
          content: content,
          row: random.nextInt(56),
          onComplete: () {
            _overlayEntry?.remove();
            _overlayEntry = null;
            _isShowing = false;
          },
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = homeKey.currentContext;
      if (context != null) {
        Overlay.of(context)?.insert(_overlayEntry!);
      } else {
        _isShowing = false;
      }
    });
  }
}

// --- Notification Widget ---

class _NotificationWidget extends StatefulWidget {
  final String title;
  final String content;
  final int row;
  final VoidCallback onComplete;
  const _NotificationWidget({
    required this.title,
    required this.content,
    required this.onComplete,
    required this.row,
  });

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = Tween<double>(
      begin: -104,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        widget.onComplete();
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
    return Positioned(
      top: MediaQuery.paddingOf(context).top + 8,
      left: 7,
      right: 7,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _animation.value),
            child: child,
          ),
          child: PSInAppNotificationCard(
            title: widget.title,
            content: widget.content,
            row: widget.row,
          ),
        ),
      ),
    );
  }
}

class PSInAppNotificationCard extends StatelessWidget {
  final String title;
  final String content;
  final int row;

  const PSInAppNotificationCard({
    super.key,
    required this.title,
    required this.content,
    required this.row,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 76,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const PSImg(name: 'ps_inapp_notice_bg', width: 361, height: 76),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 7),
            child: Row(
              children: [
                PSImg(name: 'ps_user_s_$row', width: 49, height: 49),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 23,
                        child: PSText(
                          text: title,
                          size: 18,
                          color: Colors.black,
                          weight: FontWeight.w900,
                          align: TextAlign.left,
                        ),
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        height: 34,
                        child: PSText(
                          text: content,
                          size: 13,
                          color: '#152456'.color(),
                          weight: FontWeight.w600,
                          maxLines: 2,
                          align: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                const SizedBox(
                  width: 68,
                  child: Icon(
                    Icons.payments_rounded,
                    size: 50,
                    color: Color(0xFF6098B7),
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
