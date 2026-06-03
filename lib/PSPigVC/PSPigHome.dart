import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:piggywalletspinearn/PSTool/PSTBAEventTool.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_WebKitView.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:provider/provider.dart';
import '../PSBase/PSTbaBar.dart';
import '../PSDialog/PSDialog.dart';
import '../PSDialog/PSGuideDialog.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSTool/PSAdAManger.dart';
import '../PSTool/PSFKManger.dart';
import '../PSTool/PSInAppNotification.dart';
import '../PSTool/PSMarqueeText.dart';
import '../PSTool/PSNoticeHelp.dart';
import '../PSTool/PSNumberHelpers.dart';
import '../PSTool/PSRankData.dart';
import '../PSTool/ps_GradientNumber.dart';

class PSPigHome extends StatefulWidget {
  const PSPigHome({super.key});

  @override
  State<PSPigHome> createState() => _PSPigHomeState();
}

class _PSPigHomeState extends State<PSPigHome> with TickerProviderStateMixin {
  late AnimationController _controller;

  // 六个按钮单独动画控制器
  late List<AnimationController> _buttonControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  double bubble_award_one = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();

  double bubble_award_two = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();

  double bubble_award_three = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();

  final int itemCount = 52;

  List<PSUserData> rank_data = [];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    PSInAppNotification().init();
    PSFKManger().initFK();
    ps_event_fire('home_page', {});
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();

    // 初始化 6 个按钮的动画
    _buttonControllers = List.generate(6, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    _fadeAnimations = _buttonControllers
        .map(
          (ctrl) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeIn)),
    )
        .toList();

    _scaleAnimations = _buttonControllers
        .map(
          (ctrl) => Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.elasticOut)),
    )
        .toList();

    // 依次延迟 200ms 播放动画
    for (int i = 0; i < _buttonControllers.length; i++) {
      Timer(Duration(milliseconds: 300 * i), () {
        if (mounted) _buttonControllers[i].forward();
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PSNoticeHelp().initNotice(context);
      showOldguideDialog();
    });
    updateRankdata();
    startTimer();

    PSPigDolasUpdateNotificationService.stream.listen((value) async {

      bubble_award_one = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();
      bubble_award_two = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();
      bubble_award_three = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();
      Future.delayed(Duration(milliseconds: 300), () async {
        setState(() {
        });
      });
    });
  }
  // 老用户流程
  void showOldguideDialog(){
    if (PSLocalProvider.instance.ps_old_guide == false) {
      context.tipShow(PSGuideNew12Dialog(is_old: true));
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_old_guideName, true);
    }
  }
  // 检查12点刷新排行榜1分钟检查一次
  void startTimer() {
    _timer?.cancel();
    // 每分钟检查一次
    _timer = Timer.periodic(Duration(minutes: 1), (_) async {
      DateTime now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        await PSUserDataManager.getPSUserData();
        setState(() {});
        print("Data refreshed at midnight!");
      }
    });
  }
  // 获取排行榜数据
  Future<void> updateRankdata() async {
    rank_data = await PSUserDataManager.getPSUserData();
    setState(() {});
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    for (var ctrl in _buttonControllers) {
      ctrl.dispose();
    }
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 原来的背景、列表、顶部进度条等保持不变
          Container(
            width: 0.width(context),
            height: 0.height(context),
            decoration: BoxDecoration(image: PSDImg('ps_pig_home_bg')),
            child: Stack(
              children: [
                Positioned(bottom: 0,child: PSImg(name: 'ps_pig_home_bottom', width: 0.width(context), height: 338.h)),
                Column(
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
                    SizedBox(height:288.h),
                    // ListView 列表
                    SizedBox(
                      width: 0.width(context),
                      height: 277.h,
                      child: CustomScrollView(
                        slivers: [
                          // Sliver for the header (TableViewHeaderView)
                          SliverToBoxAdapter(
                            child: Container(
                              width: 364.w,
                              height: 184.h,
                              decoration: BoxDecoration(
                                image: PSDImg('ps_pig_user_top_bg')
                              ),
                              child: Stack(
                                children: [
                                  Positioned(right: 14.w,top: 24.h,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  Positioned(left: 14.w,top: 24.h,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  Positioned(right: 124.w,top: 12.h,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  if (rank_data.length > 0)
                                   Positioned(left: 48.w,top: 64.h,child: PSImg(name: 'ps_user_s_${rank_data[1].id}', width: 31, height: 31)),
                                  if (rank_data.length > 0)
                                    Positioned(right: 52.w,top: 64.h,child: PSImg(name: 'ps_user_s_${rank_data[2].id}', width: 31, height: 31)),
                                  if (rank_data.length > 0)
                                    Positioned(left: 160.w,top: 48.h,child: PSImg(name: 'ps_user_s_${rank_data[0].id}', width: 49, height: 49)),
                                  if (rank_data.length > 0)
                                    Positioned(left: 24.w,top: 98.h,child: PSStrokeText(text: rank_data[1].username, size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  if (rank_data.length > 0)
                                    Positioned(right: 24.w,top: 98.h,child: PSStrokeText(text: rank_data[2].username, size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  if (rank_data.length > 0)
                                    Positioned(left: 145.w,top: 98.h,child: PSStrokeText(text: rank_data[0].username, size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  if (rank_data.length > 0)
                                    Positioned(left: 24.w,top: 108.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning:'),
                                        TextSpan(
                                          text: '${0.dolasType()}${rank_data[1].totalEarning}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(right: 24.w,top: 108.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning:'),
                                        TextSpan(
                                          text: '${0.dolasType()}${rank_data[2].totalEarning}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(left: 145.w,top: 108.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 8,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning:'),
                                        TextSpan(
                                          text: '${0.dolasType()}${rank_data[0].totalEarning}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(left: 24.w,top: 120.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '${rank_data[1].adsWatched}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(right: 24.w,top: 120.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '${rank_data[2].adsWatched}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(left: 145.w,top: 120.h,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '${rank_data[0].adsWatched}',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(left: 28.w,top: 136.h,child: ParticleButton(
                                    onTap: (){
                                      ps_event_fire('home_list_showpig', {});
                                      context.tipShow2(PSPopCunCashDog(is_gold: true, userData: rank_data[1]));
                                    },
                                    child: Container(
                                      width: 71,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        image: PSDImg('ps_show_pig_b')
                                      ),
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(right: 28.w,top: 136.h,child: ParticleButton(
                                    onTap: (){
                                      ps_event_fire('home_list_showpig', {});
                                      context.tipShow2(PSPopCunCashDog(is_gold: true, userData: rank_data[2]));
                                    },
                                    child: Container(
                                      width: 71,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          image: PSDImg('ps_show_pig_b')
                                      ),
                                    ),
                                  ),),
                                  if (rank_data.length > 0)
                                    Positioned(left: 153.w,top: 136.h,child: ParticleButton(
                                    onTap: (){
                                      ps_event_fire('home_list_showpig', {});
                                      context.tipShow2(PSPopCunCashDog(is_gold: true, userData: rank_data[0]));
                                    },
                                    child: Container(
                                      width: 71,
                                      height: 22,
                                      decoration: BoxDecoration(
                                          image: PSDImg('ps_show_pig_b')
                                      ),
                                    ),
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          // SliverList for the ListView with animation
                          if (rank_data.length > 0)
                            SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1.2, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _controller,
                                      curve: Interval(
                                        index * 0.15,
                                        (index * 0.15 + 0.6).clamp(0.0, 1.0),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height: 73,
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      image: PSDImg('ps_home_list_bg'),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                      },
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 18,),
                                              PSStrokeText(text: "${4 + index}", size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#4B030E'.color()),
                                              SizedBox(width: 12),
                                              PSImg(name: 'ps_user_n_${rank_data[index + 3].id}', width: 49, height: 49),
                                              SizedBox(
                                                width: 120,
                                                height: 66,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 12),
                                                    PSText(text: rank_data[index + 3].username, size: 10, color: '#0C3D8C'.color(), weight: FontWeight.w900),
                                                    SizedBox(height: 6),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Black_mianfeiziti',
                                                          color: '#873709'.color(),
                                                        ),
                                                        children: [
                                                          TextSpan(text: 'Total earning:'),
                                                          TextSpan(
                                                            text: '${0.dolasType()}${rank_data[index + 3].totalEarning}',
                                                            style: TextStyle(color: '#0B7C1C'.color(), fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Black_mianfeiziti',
                                                          color: '#873709'.color(),
                                                        ),
                                                        children: [
                                                          TextSpan(text: 'Ads watched:       '),
                                                          TextSpan(
                                                            text: '${rank_data[index + 3].adsWatched}',
                                                            style: TextStyle(color: '#7212CC'.color(), fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              ParticleButton(
                                                onTap: (){
                                                  ps_event_fire('home_list_showpig', {});
                                                  context.tipShow2(PSPopCunCashDog(is_gold: false, userData: rank_data[index + 3]));
                                                },
                                                child: Container(
                                                  width: 74,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    image: PSDImg('ps_show_pig_b')
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 28)
                                            ],
                                          ),
                                          Positioned(right: 16,top: 4,child: PSImg(name: 'ps_pig_0', width: 33, height: 33)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: itemCount,
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(left: 8.w,top: 161.h,child: ParticleButton(onTap: () async {
            ps_event_fire(' h5_c', {});
            ps_event_fire(' h5_page', {});
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (builder) {
            //       ps_event_fire('h5_page', {});
            //       return PSWebkitview(
            //         url: "https://tinyurl.com/5n6u64vn",
            //         title: 'Game',
            //       );
            //     },
            //   ),
            // );
            String gaids = await FlutterTbaInfo.instance.getGaid();
            'gaids=$gaids'.log();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (builder) {
                  ps_event_fire('link_page', {});
                  return PSWebkitview(
                    url: "https://s.gamifyspace.com/tml?pid=21501&appk=FmjwhY8YKjAAQXsvW0FxfEctUF30Qdtg&did=${gaids}",
                    title: 'GamePlay',
                  );
                },
              ),
            );
          },child: PSImg(name: 'ps_h5_btn', width: 56, height: 45))),
          /// =================== 6 个按钮渐显 + 缩放 ===================
          Consumer<PSLocalProvider>(
            builder: (context, provider, child) {
              return Positioned(
                left: (0.width(context) - 211) * 0.5,
                top: 148.h, width: 211, height: 208,
                child: Container(
                  width: 211, height: 208,
                   decoration: BoxDecoration(
                     image: PSDImg('ps_b_pig_icon_${provider.ps_pig_level}')
                   ),
                  child: Column(
                    children: [
                      Spacer(),
                      Padding(padding: EdgeInsetsGeometry.only(left: provider.ps_pig_level == 1 ? 38 : 52),child: PSImg(name: 'ps_${provider.ps_pig_level}_${getIntervalValue(provider.ps_pig_level, provider.ps_pig_level == 0 ? provider.ps_dolas_number : provider.ps_pig_level_index)}', width: 78.02, height: 67.21)),
                      if (provider.ps_pig_level == 1)
                       SizedBox(height: 50),
                      if (provider.ps_pig_level == 2)
                        SizedBox(height: 52),
                      if (provider.ps_pig_level == 0)
                        SizedBox(height: 50),
                    ],
                  ),
                ));
            },
          ),
          Positioned(top: 330.h, left: (0.width(context) - 141) * 0.53,child: Container(
            width: 141,
            height: 34,
            decoration: BoxDecoration(
              image: PSDImg('ps_act_bg')
            ),
            child:Consumer<PSLocalProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: .center,
                  children: [
                    PSImg(name: provider.ps_pig_level == 0 ? 'ps_dolas_2' : provider.ps_pig_level == 1 ? 'ps_domand_icon' : 'ps_zhuan_smail', width: 26, height: 21),
                    SizedBox(width: 5,),
                    PSText(text: '${provider.ps_pig_level == 0 ? '${0.dolasType()}' : ''}${provider.ps_pig_level == 0 ? 0.to2Double(provider.ps_dolas_number) : provider.ps_pig_level == 1 ? 0.to2Double(provider.ps_pig_level_index) : 0.to2Double(provider.ps_pig_level_index)}', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
                  ],
                );
              },
            ),
          )),
          Positioned(top: 368.h,left: (0.width(context) - 328.w) * 0.5,child: Container(
            width: 328.w, height:30.h,
            decoration: BoxDecoration(
                image: PSDImg('ps_pao_bg')
            ),
            child: Center(
              child: PSMarqueeText()
            ),
          )),
          Positioned(
            right: 50.w,
            top: 160.h,
            width: 60.44,
            height: 60.2,
            child: FadeTransition(
              opacity: _fadeAnimations[0],
              child: ScaleTransition(
                scale: _scaleAnimations[0],
                child: ParticleButton(
                  onTap: () async {
                    ps_event_fire('home_float_apple', {});
                      PSPigAds().ps_showAd(context, 'asd_rv', onCacheResponse: (onCacheResponse) async {
                      }, adDidClosed: (adDidClosed) async {
                        if (PSLocalProvider.instance.ps_pig_level == 0) {
                          int code = await context.tipShow(PSPopAwardToolDialog(type: .apple, isGuide: false, award: PSNumberHelpers().getPrizeWithDolasNum()));
                          if (code >= 0){
                          }
                        } else {
                          int code = await context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .apple, is_rv: false, award: PSNumberHelpers().getPrizeWithDomandGoldNum(), is_wheel: false));
                          if (code >= 0){
                          }
                        }
                      });
                  },
                  child: Stack(
                    children: [
                      PSBouncyImage(
                        imagePath: 'ps_apple_bubble',
                        width: 60.44,
                        height: 60.2,
                        enableAnimation: true,
                      ),
                      Positioned(
                        top: -8,
                        right: -4,
                        child: PSBouncyImage(
                          imagePath: 'ps_ad_icon',
                          width: 37,
                          height: 40,
                          enableAnimation: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Consumer<PSLocalProvider>(
            builder: (context, provider, child) {
              return Positioned(
                left: 50.w,
                top: 160.h,
                child: FadeTransition(
                  opacity: _fadeAnimations[1],
                  child: ScaleTransition(
                    scale: _scaleAnimations[1],
                    child: ParticleButton(
                      onTap: () async {
                        ps_event_fire('home_float_c', {});
                        if (PSLocalProvider.instance.ps_pig_level == 0) {
                          int code = await context.tipShow(PSPopAwardToolDialog(type: .buble, isGuide: false, award: bubble_award_one));
                          if (code >= 0){
                          }
                        } else {
                          int code = await context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .buble, is_rv: false, award: bubble_award_one, is_wheel: false));
                          if (code >= 0){
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          PSBouncyImage(
                            imagePath: 'ps_home_pop_${provider.ps_pig_level}',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: PSStrokeText(
                              text: provider.ps_pig_level == 0 ? '${0.dolasType()}${bubble_award_one}' : provider.ps_pig_level == 1 ? 'X${bubble_award_one}' : 'X${bubble_award_one}',
                              size: 18,
                              color: '#FFFDE1'.color(),
                              weight: FontWeight.w900,
                              skWidth: 2,
                              skColor: '#5F2605'.color(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<PSLocalProvider>(
            builder: (context, provider, child) {
              return Positioned(
                right: 12.w,
                top: 220.h,
                child: FadeTransition(
                  opacity: _fadeAnimations[2],
                  child: ScaleTransition(
                    scale: _scaleAnimations[2],
                    child: ParticleButton(
                      onTap: () async {
                        ps_event_fire('home_float_c', {});
                        PSPigAds().ps_showAd(context, 'nskdh_moneybub_rv', onCacheResponse: (onCacheResponse) async {
                        }, adDidClosed: (adDidClosed) async {
                          if (PSLocalProvider.instance.ps_pig_level == 0) {
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, bubble_award_two);
                          } else {
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_pig_level_indexName,PSLocalProvider.instance.ps_pig_level_index + bubble_award_two);
                          }
                          if (!context.mounted) return;
                          context.showAutoDismissDialog(context: context, child: PSPoGetAwardDog(award: bubble_award_two));
                          Future.delayed(Duration(seconds: 2),(){
                            setState(() {
                              bubble_award_two = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();
                            });
                            if (PSLocalProvider.instance.ps_pig_level == 0) {
                              context.tipShow(PSPopAwardToolDialog(type: .buble, isGuide: false, award: bubble_award_two));
                            } else {
                             context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .buble, is_rv: false, award: bubble_award_two, is_wheel: false));
                            }
                          });
                        });
                      },
                      child: Stack(
                        children: [
                          PSBouncyImage(
                            imagePath: 'ps_home_pop_${provider.ps_pig_level}',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          ),
                          Positioned(
                            top: -8,
                            right: -4,
                            child: PSBouncyImage(
                              imagePath: 'ps_ad_icon',
                              width: 37,
                              height: 40,
                              enableAnimation: true,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: PSStrokeText(
                              text: provider.ps_pig_level == 0 ? ' ${0.dolasType()}$bubble_award_two' : ' X$bubble_award_two',
                              size: 18,
                              color: '#FFFDE1'.color(),
                              weight: FontWeight.w900,
                              skWidth: 2,
                              skColor: '#5F2605'.color(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Consumer<PSLocalProvider>(
            builder: (context, provider, child) {
              return Positioned(
                left: 12.w,
                top: 220.h,
                child: FadeTransition(
                  opacity: _fadeAnimations[3],
                  child: ScaleTransition(
                    scale: _scaleAnimations[3],
                    child: ParticleButton(
                      onTap: () async {
                        ps_event_fire('home_float_c', {});
                        PSPigAds().ps_showAd(context, 'nskdh_moneybub_rv', onCacheResponse: (onCacheResponse) async {
                        }, adDidClosed: (adDidClosed) async {
                          if (PSLocalProvider.instance.ps_pig_level == 0) {
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, bubble_award_three);
                          } else {
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_pig_level_indexName,PSLocalProvider.instance.ps_pig_level_index + bubble_award_three);
                          }
                          if (!context.mounted) return;
                          context.showAutoDismissDialog(context: context, child: PSPoGetAwardDog(award: bubble_award_three));
                          Future.delayed(Duration(seconds: 2),(){
                            setState(() {
                              bubble_award_three = PSLocalProvider.instance.ps_pig_level == 0 ? PSNumberHelpers().getPrizeWithDolasNum() : PSNumberHelpers().getPrizeWithDomandGoldNum();
                            });
                            if (PSLocalProvider.instance.ps_pig_level == 0) {
                              context.tipShow(PSPopAwardToolDialog(type: .buble, isGuide: false, award: bubble_award_three));
                            } else {
                              context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .buble, is_rv: false, award: bubble_award_three, is_wheel: false));
                            }
                          });
                        });
                      },
                      child: Stack(
                        children: [
                          PSBouncyImage(
                            imagePath: 'ps_home_pop_${provider.ps_pig_level}',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          ),
                          Positioned(
                            top: -8,
                            right: -4,
                            child: PSBouncyImage(
                              imagePath: 'ps_ad_icon',
                              width: 37,
                              height: 40,
                              enableAnimation: true,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: PSStrokeText(
                              text: provider.ps_pig_level == 0 ? ' ${0.dolasType()}???' : ' X???',
                              size: 20,
                              color: '#FFFDE1'.color(),
                              weight: FontWeight.w900,
                              skWidth: 2,
                              skColor: '#5F2605'.color(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            right: 40.w,
            top: 290.h,
            child: FadeTransition(
              opacity: _fadeAnimations[4],
              child: ScaleTransition(
                scale: _scaleAnimations[4],
                child: ParticleButton(
                  onTap: () {
                    PigTabController.switchTo(1);
                    ps_event_fire('home_float_quiz', {});
                  },
                  child: PSBouncyImage(
                    imagePath: 'ps_quzi_btn_pop',
                    width: 70.44,
                    height: 70.2,
                    enableAnimation: true,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40.w,
            top: 290.h,
            child: FadeTransition(
              opacity: _fadeAnimations[5],
              child: ScaleTransition(
                scale: _scaleAnimations[5],
                child: ParticleButton(
                  onTap: () {
                    PigTabController.switchTo(2);
                    ps_event_fire('home_float_wheel', {});
                  },
                  child: Stack(
                    children: [
                      PSBouncyImage(
                        imagePath: 'ps_wheel_bubble',
                        width: 70.44,
                        height: 70.2,
                        enableAnimation: true,
                      ),
                      Positioned(bottom: 8,left: 2,child: PSStrokeText(
                        text: 'Wheel Cash',
                        size: 11,
                        color: '#FFFDE1'.color(),
                        weight: FontWeight.w900,
                        skWidth: 2,
                        skColor: '#5F2605'.color(),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.w,
            top: 380.h,
            width: 50,
            height: 50,
            child: ParticleButton(
              child: Center(
                child: PSImg(name: 'ps_privary_icon', width: 20, height: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) {
                      return PSWebkitview(
                        url: "https://sites.google.com/view/piggywallet-pp/home",
                        title: 'Privacy Policy',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class PigblancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PSLocalProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 349,
          height: 119,
          decoration: BoxDecoration(
            image: PSDImg('ps_t_center_bg'),
          ),
          child: ParticleButton(
            onTap: (){
              ps_event_fire('home_page_withdraw', {});
              PigTabController.switchTo(3);
            },
            child: Stack(
              children: [
                Positioned(
                  left: 32,
                  top: 0,
                  child: Container(
                    width: 141,
                    height: 32,
                    decoration: BoxDecoration(image: PSDImg('ps_act_bg')),
                    child: Center(
                      child: PSImg(
                        name: 'ps_act_${provider.ps_account_seled_index}',
                        width: 128,
                        height: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 32,
                  top: 17,
                  child: Container(
                    width: 118,
                    height: 29,
                    decoration: BoxDecoration(image: PSDImg('ps_wtd_btn')),
                    child: InkWell(
                      onTap: () {
                        PigTabController.switchTo(3);
                      },
                      child: Center(
                        child: PSStrokeText(
                          text: 'Withdraw',
                          size: 12,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w900,
                          skWidth: 1,
                          skColor: '#025003'.color(),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 34,
                  left: 32,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Black_mianfeiziti',
                        color: '#873709'.color(),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Growing Balance: '),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 28,
                    left: 138,
                    child: PSGradientNumberRoller(
                  value: provider.ps_dolas_number,
                  duration: 800,
                  fontSize: 17.0,
                  gradientColors: ['#0BA408'.color(), '#0BA408'.color()],
                  borderColor: Colors.transparent,
                  borderWidth: 0.0,
                  decimalPlaces: 2,
                )),
                Positioned(
                  bottom: 21.5,
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
                            TextSpan(text: '${0.dolasType()}${(0.to2Double(provider.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first ? 0 : PSNumberHelpers().intModel!.eqRange.first - provider.ps_dolas_number))}'), // Static or dynamic based on provider
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
                              text: '${0.dolasType()}${(0.to2Double(provider.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first ? 0 : PSNumberHelpers().intModel!.eqRange.first - provider.ps_dolas_number))}', // Static or dynamic based on provider
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
                  bottom: 38,
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class PigblancePage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PSLocalProvider>(
        builder: (context, provider, child) {
          return Container(
            width: 349,
            height: 119,
            decoration: BoxDecoration(
              image: PSDImg('ps_wheel_top_bg'),
            ),
            child: ParticleButton(
              onTap: (){
                ps_event_fire('home_page_withdraw', {});
                PigTabController.switchTo(3);
              },
              child: Stack(
                children: [
                  Positioned(
                    left: 68,
                    top: 16,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w900,
                          color: '#DA5001'.color(),
                          fontFamily: text_fontName,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: 'Money’s in—ready to withdraw！'),
                        ],
                      ),
                    ),
                  ),
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
                              image: PSDImg('ps_pro_bg_t', fit: BoxFit.fill),
                            ),
                          ),
                          Positioned(
                            left: 7,
                            child: Container(
                              width:
                              251 *
                                  (provider.ps_pig_level == 0
                                      ? (provider.ps_dolas_number /
                                      PSNumberHelpers().intModel!.eqRange.first)
                                      : (provider.ps_pig_level_index /
                                      (provider.ps_pig_level == 1
                                          ? 20
                                          : 10))),
                              height: 12,
                              decoration: BoxDecoration(
                                color: '#39B101'.color(),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.ps_pig_level == 0)
                    Positioned(
                      left: 180.w,
                      top: 35,
                      child: PSGradientNumberRoller(
                        value: provider.ps_dolas_number,
                        duration: 800,
                        fontSize: 10.0,
                        gradientColors: ['#FFFFFF'.color(), '#FFFFFF'.color()],
                        borderColor: '#5235B'.color(),
                        borderWidth: 0.0,
                        decimalPlaces: 2,
                      ),
                    ),
                  if (provider.ps_pig_level == 1 || provider.ps_pig_level == 2)
                    Positioned(
                      left: 180.w,
                      top: 37,
                      child: PSStrokeText(text: '${0.to2Double(provider.ps_pig_level_index)}/${PSLocalProvider.instance
                          .ps_pig_level == 1 ? 20 : 10}',
                          size: 10,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w900,
                          skWidth: 1,
                          skColor: '#15235B'.color()),
                    ),
                  Positioned(
                    left: 158.w,
                    top: provider.ps_pig_level == 0 ? 33 : 36,
                    child: PSImg(
                      name: provider.ps_pig_level == 0 ? 'ps_dolas_2' : provider
                          .ps_pig_level == 1 ? 'ps_domand_s' : 'ps_zhuan_smail',
                      width: provider.ps_pig_level == 0 ? 18 : 13,
                      height: provider.ps_pig_level == 0 ? 17 : 11,
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 12,
                    child: PSImg(
                      name: 'ps_pig_${provider.ps_pig_level}',
                      width: 47,
                      height: 47,
                    ),
                  ),
                  Positioned(
                    left: 29,
                    top: 42,
                    child: PSStrokeText(text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}',
                        size: 12,
                        color: '#FFE711'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#042267'.color()),
                  ),
                  Positioned(
                    right: 16,
                    top: 30,
                    child: PSImg(name: 'ps_act_top_${provider
                        .ps_account_seled_index}${isBrazilianPortuguese(
                        context) == true ? 'pt' : ''}', width: 72, height: 25),
                  ),
                  Positioned(
                    left: 40,
                    bottom: 32,
                    child: PSImg(name: provider.ps_pig_level == 0
                        ? 'ps_dolas_2' : provider.ps_pig_level == 1
                        ? 'ps_domand_b_icon'
                        : 'ps_zhuan_b_icon', width: 19, height: 17),
                  ),
                  Positioned(
                    left: 63,
                    bottom: 33,
                    child: PSStrokeText(text: 'Collected: ',
                        size: 12,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#670B04'.color()),
                  ),
                  Positioned(
                    left: 130,
                    bottom: 33,
                    child: PSStrokeText(
                        text: '${0.to2Double(provider.ps_pig_level_index)}',
                        size: 12,
                        color: '#FFE711'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#670B04'.color()),
                  ),
                  Positioned(
                    right: 146,
                    bottom: 32,
                    child: PSImg(name: provider.ps_pig_level == 0
                        ? 'ps_dolas_2' : provider.ps_pig_level == 1
                        ? 'ps_domand_b_icon'
                        : 'ps_zhuan_b_icon', width: 19, height: 17),
                  ),
                  Positioned(
                    right: 108,
                    bottom: 33,
                    child: PSStrokeText(text: 'Left: ',
                        size: 12,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#670B04'.color()),
                  ),
                  Positioned(
                    right: 80,
                    bottom: 33,
                    child: PSStrokeText(
                        text: provider
                            .ps_pig_level == 1 ? '${20 - provider.ps_pig_level_index <= 0 ? 0 : 0.to2Double(20 - provider.ps_pig_level_index)}' : '${10 - provider.ps_pig_level_index <= 0 ? 0 : 0.to2Double(10 - provider.ps_pig_level_index)}',
                        size: 12,
                        color: '#FFE711'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#670B04'.color()),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }

}

class PSPigDolasUpdateNotificationService {
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