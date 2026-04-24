import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSHome/PSQuiz.dart';
import 'package:piggywalletspinearn/PSHome/PSWheel.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import '../PSPigVC/PSPigCash.dart';
import '../PSPigVC/PSPigHome.dart';
import '../PSPigVC/PSPigQuiz.dart';
import '../PSPigVC/PSPigWheel.dart';
import '../PSTool/ps_extension_help.dart';

class PigTabController {
  PigTabController._();

  /// 当前选中的 tab
  static final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  /// 外部切换
  static void switchTo(int index) {
    currentIndex.value = index;
  }
}

class PigBottomExample extends StatefulWidget {
  const PigBottomExample({Key? key}) : super(key: key);

  @override
  State<PigBottomExample> createState() => _PigBottomExampleState();
}

class _PigBottomExampleState extends State<PigBottomExample> {
  /// ✅ 不再自己维护 int
  final ValueNotifier<int> _indexNotifier = PigTabController.currentIndex;

  final List<Widget> _screens = const [PSHome(), PSQuiz(), PSWheel()];

  final List<Widget> _screenbs = const [PSPigHome(), PSPigQuiz(), PSPigWheel(), PSPigCash()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      /// ✅ 只监听 index
      body: ValueListenableBuilder<int>(
        valueListenable: _indexNotifier,
        builder: (_, index, __) {
          return IndexedStack(index: index, children: _screenbs);
        },
      ),

      /// ✅ 底部栏也监听
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: _indexNotifier,
        builder: (_, index, __) {
          return CustomNavBarWidget(
            [
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_home_icon'.image()),
                inactiveIcon: Image.asset('ps_home_icon'.image()),
                title: 'Earn',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_quiz_icon'.image()),
                inactiveIcon: Image.asset('ps_quiz_icon'.image()),
                title: 'Quiz',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_wheel_icon'.image()),
                inactiveIcon: Image.asset('ps_wheel_icon'.image()),
                title: 'Wheel',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_cash_icon'.image()),
                inactiveIcon: Image.asset('ps_cash_icon'.image()),
                title: 'Cash',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
            ],
            selectedIndex: index,

            /// ✅ 不再 setState
            onItemSelected: (i) {
              PigTabController.switchTo(i);
            },
          );
          return CustomNavBarWidget(
            [
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_home_icon'.image()),
                inactiveIcon: Image.asset('ps_home_icon'.image()),
                title: 'Piggy',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_quiz_icon'.image()),
                inactiveIcon: Image.asset('ps_quiz_icon'.image()),
                title: 'Quiz',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
              PersistentBottomNavBarItem(
                icon: Image.asset('ps_wheel_icon'.image()),
                inactiveIcon: Image.asset('ps_wheel_icon'.image()),
                title: 'Wheel',
                activeColorPrimary: Colors.transparent,
                inactiveColorPrimary: Colors.transparent,
              ),
            ],
            selectedIndex: index,

            /// ✅ 不再 setState
            onItemSelected: (i) {
              PigTabController.switchTo(i);
            },
          );
        },
      ),
    );
  }
}

class CustomNavBarWidget extends StatefulWidget {
  const CustomNavBarWidget(
    this.items, {
    required this.selectedIndex,
    required this.onItemSelected,
    Key? key,
  }) : super(key: key);

  final int selectedIndex;
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  @override
  State<CustomNavBarWidget> createState() => _CustomNavBarWidgetState();
}

class _CustomNavBarWidgetState extends State<CustomNavBarWidget>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.items.length == 3 ? 'ps_tabbar_bg'.image() : 'ps_pig_tab_bg'.image()),
          fit: BoxFit.fill,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 81,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(widget.items.length, (index) {
            final item = widget.items[index];
            final bool isSelected = widget.selectedIndex == index;
            return Expanded(
              child: ParticleButton(
                onTap: () => widget.onItemSelected(index),
                child: _buildItem(item, isSelected),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return SizedBox(
      height: 81,
      child: Stack(
        clipBehavior: Clip.none, // 👈 关键
        alignment: Alignment.center,
        children: [
          /// 🔹 选中背景图
          if (isSelected)
            Positioned(
              left: 0,
              top: 6, // 背景可以稍微比icon大
              child: SizedBox(
                width: 0.width(context) / widget.items.length,
                height: 78,
                child: Image.asset(
                  'ps_tabbar_s'.image(), // 你的背景图资源
                  fit: BoxFit.fill,
                ),
              ),
            ),

          /// 图标
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
            top: isSelected ? -8 : 14, // 👈 关键点
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              child: SizedBox(
                width: 56,
                height: 54,
                child: isSelected ? item.icon : item.inactiveIcon,
              ),
            ),
          ),

          /// 文字
          Positioned(
            bottom: 8,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1 : 0,
              child: PSStrokeText(
                text: item.title ?? '',
                size: 16,
                color: '#FAF5D7'.color(),
                weight: FontWeight.w400,
                skWidth: 1,
                skColor: '#000000'.color(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
