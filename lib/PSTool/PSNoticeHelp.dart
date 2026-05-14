import 'package:flutter/cupertino.dart';
import 'package:flutter_lifecycle_detector/flutter_lifecycle_detector.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigHome.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import '../PSBase/PSTbaBar.dart';
import '../main.dart';
import 'PSFKManger.dart';
import 'PSTBAEventTool.dart';


class PSNoticeHelp {

  static final PSNoticeHelp _instance = PSNoticeHelp._internal();

  factory PSNoticeHelp() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  PSNoticeHelp._internal();

  Future<void> initNotice(BuildContext context) async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ps_logo'); // 不加 .png

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        'nf click response:${response}'.log();
        final String? payload = response.payload;
        ps_event_fire('all_noti_c', {'type': payload ?? ''});
        if(payload == null)return;
      },
    );


    NotificationAppLaunchDetails? notificationAppLaunchDetails =
    await AndroidFlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    '=initNotification====getNotificationAppLaunchDetails==notificationAppLaunchDetails:$notificationAppLaunchDetails='.log();

    if (notificationAppLaunchDetails != null) {
      NotificationResponse? notificationResponse =
          notificationAppLaunchDetails.notificationResponse;
      bool didNotificationLaunchApp =
          notificationAppLaunchDetails.didNotificationLaunchApp ?? false;
      if (didNotificationLaunchApp) {
        ps_event_fire('inform_c', {'type': notificationResponse?.payload ?? ''});
      }
    }

    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      ps_event_fire('push_status', {});
    }else{
      "nf no permission".log();
      context.tipShow(PSPopTipsToolDialog(adStatus: .noticeOpen));
    }
    "nf has permission".log();
    _initLifecycleListener();
    _repeatNotification1();
    _repeatNotification2();
    _repeatNotification3();
    _repeatNotification4();
    // _subscribeFcmTopic();
    // _subscribeFcmTopic2();
    _showUnlockNotification();
    _showScreenOnNotification();
    showSJNotificationMediaStyle1();
    showSJNotificationMediaStyle2();
    showSJNotificationMediaStyle3();
    showSJNotificationMediaStyle4();
    _spinitNotificationCount(flutterLocalNotificationsPlugin);
  }

  _spinitNotificationCount(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      int locals = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti1");
      "==initNotificationCount==localcount:$locals==".log();
      if (locals > 0) {
        for (int i = 0; i < locals; i++) {
          ps_event_fire('inform_p', {'type' : "noti1"});
        }
      }
      int locals2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti2");
      "==initNotificationCount==localcount:$locals2==".log();
      if (locals2 > 0) {
        for (int i = 0; i < locals2; i++) {
          ps_event_fire('inform_p', {'type' : "noti2"});
        }
      }
      int locals3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti3");
      "==initNotificationCount==localcount:$locals3==".log();
      if (locals3 > 0) {
        for (int i = 0; i < locals3; i++) {
          ps_event_fire('inform_p', {'type' : "noti3"});
        }
      }
      int locals4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti4");
      "==initNotificationCount==localcount:$locals4==".log();
      if (locals4 > 0) {
        for (int i = 0; i < locals4; i++) {
          ps_event_fire('inform_p', {'type' : "noti4"});
        }
      }
      int fcms = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fcm");
      "==initNotificationCount==localcount:$fcms==".log();
      if (fcms > 0) {
        for (int i = 0; i < fcms; i++) {
          ps_event_fire('inform_p', {'type' : "fcm"});
        }
      }

      int unlocks = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("unlock");
      "==initNotificationCount==localcount:$unlocks==".log();
      if (unlocks > 0) {
        for (int i = 0; i < unlocks; i++) {
          ps_event_fire('inform_p', {'type' : "unlock"});
        }
      }

      int screenon = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("screenon");
      "==initNotificationCount==localcount:$screenon==".log();
      if (screenon > 0) {
        for (int i = 0; i < screenon; i++) {
          ps_event_fire('inform_p', {'type' : "screenon"});
        }
      }

      int foreground = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("foreground");
      "==initNotificationCount==localcount:$foreground==".log();
      if (foreground > 0) {
        for (int i = 0; i < foreground; i++) {
          ps_event_fire('inform_p', {'type' : "foreground"});
        }
      }

      int media = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media1");
      "==initNotificationCount==localcount:$media==".log();
      if (media > 0) {
        for (int i = 0; i < media; i++) {
          ps_event_fire('inform_p', {'type' : "media"});
        }
      }

      int media2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media2");
      "==initNotificationCount==localcount:$media==".log();
      if (media2 > 0) {
        for (int i = 0; i < media2; i++) {
          ps_event_fire('inform_p', {'type' : "media"});
        }
      }

      int media3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media3");
      "==initNotificationCount==localcount:$media==".log();
      if (media3 > 0) {
        for (int i = 0; i < media3; i++) {
          ps_event_fire('inform_p', {'type' : "media"});
        }
      }

      int media4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media4");
      "==initNotificationCount==localcount:$media==".log();
      if (media4 > 0) {
        for (int i = 0; i < media4; i++) {
          ps_event_fire('inform_p', {'type' : "media"});
        }
      }

    } catch (e) {
      "===initNotificationCount==error:$e=".log();
    }
  }

  Future<void> setNoticeStatus() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      ps_event_fire('push_status', {});
    }else{
      "nf no permission".log();
    }

  }

  // 前台服务
  Future<void> startSJForegroundService() async {
    //自定义通知ID
    final int id = 1200;
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'pigwalletForeground',
        'pigwalletForeground',
        ongoing: true,
        importance: Importance.min,
        priority: Priority.min,
        styleInformation: ForegroundStyleInformation(value: '${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number.toStringAsFixed(2)}', image:'ps_freground')
    );
    await AndroidFlutterLocalNotificationsPlugin().startForegroundService(id, '', '',
        notificationDetails: androidNotificationDetails, payload: 'foreground');
  }

  // 媒体通知
  Future<void> showSJNotificationMediaStyle1() async {
    //自定义通知ID
    final int id = 478;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice0',
      'PigWalletSPine0',
      styleInformation:MediaStyleInformation(
        //支持网络图片链接
        image:'ps_sm_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 40),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "Media1"
    );
  }

  Future<void> showSJNotificationMediaStyle2() async {
    //自定义通知ID
    final int id = 2488;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice21',
      'PigWalletSPine21',
      styleInformation:MediaStyleInformation(
        //支持网络图片链接
        image:'ps_sm_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 80),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "Media2"
    );
  }

  Future<void> showSJNotificationMediaStyle3() async {
    //自定义通知ID
    final int id = 2914;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice31',
      'PigWalletSPine31',
      styleInformation:MediaStyleInformation(
        //支持网络图片链接
        image:'ps_sm_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 160),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "Media3"
    );
  }

  Future<void> showSJNotificationMediaStyle4() async {
    //自定义通知ID
    final int id = 1020;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice41',
      'PigWalletSPine41',
      styleInformation:MediaStyleInformation(
        //支持网络图片链接
        image:'ps_sm_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 190),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "Media4"
    );
  }

  // Future<void> _tapMediasNotice(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  //
  //   await flutterLocalNotificationsPlugin.cancel(3744);
  //
  //   final NotificationDetails media = NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'scratchjoy Media',
  //       'scratchjoy',
  //       styleInformation: MediaStyleInformation(image: 'ps_sm_logo'),
  //     ),
  //   );
  //
  //   final int id = 3744;
  //   final randomMotivation = StepMotivationManager.getRandomMotivation();
  //   final String title = randomMotivation.title;
  //   final String body = randomMotivation.body;
  //   await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
  //       id,
  //       title,
  //       body,
  //       //间隔时长根据需求设置
  //       Duration(minutes: 30),
  //       notificationDetails: media.android,
  //       scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
  //       payload: "media"
  //   );
  // }

  // 本地通知
  Future<void> _repeatNotification1() async {
    //自定义通知ID
    final int id = 5290;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice1',
      'PigWalletSPine1',
      styleInformation: BeautyStyleInformation(
        title: title,
        body: body,
        image:'ps_notice_big',
        button:'Withdraw',
        appIcon:'ps_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 30),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti1"
    );
  }

  Future<void> _repeatNotification2() async {
    //自定义通知ID
    final int id = 4562;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice2',
      'PigWalletSPine2',
      styleInformation: BeautyStyleInformation(
        title: title,
        body: body,
        image:'ps_notice_big',
        button:'Withdraw',
        appIcon:'ps_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 60),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti2"
    );
  }

  Future<void> _repeatNotification3() async {
    //自定义通知ID
    final int id = 6552;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice3',
      'PigWalletSPine3',
      styleInformation: BeautyStyleInformation(
        title: title,
        body: body,
        image:'ps_notice_big',
        button:'Withdraw',
        appIcon:'ps_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 90),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti3"
    );
  }

  Future<void> _repeatNotification4() async {
    //自定义通知ID
    final int id = 9175;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    final String title = randomMotivation.title;
    final String body = randomMotivation.body;
    AndroidNotificationDetails details = AndroidNotificationDetails(
      '152notice4',
      'PigWalletSPine4',
      styleInformation: BeautyStyleInformation(
        title: title,
        body: body,
        image:'ps_notice_big',
        button:'Withdraw',
        appIcon:'ps_logo',
      ),
      priority: Priority.high,
      importance: Importance.high,
      icon: 'ps_sm_logo',
      //“groupKey”：防止通知被系统折叠
      groupKey: "$id",
    );
    await AndroidFlutterLocalNotificationsPlugin().periodicallyShowWithDuration(
        id,
        title,
        body,
        //间隔时长根据需求设置
        const Duration(minutes: 120),
        notificationDetails: details,
        scheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: "noti4"
    );
  }

  Future<void> _subscribeFcmTopic() async {
    await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      '',
      AndroidNotificationDetails(
        '',
        'PigWalletSPine',
        styleInformation: BeautyStyleInformation(
          title: '',
          body: '',
          image:'',
          button:'Withdraw',
          appIcon:'ps_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
        icon: 'ps_sm_logo',
      ),
    );
  }

  // Future<void> _subscribeFcmTopic2() async {
  //   await AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
  //     'C130_us_normal_fcm',
  //     AndroidNotificationDetails(
  //       '130_us_normal_fcm',
  //       'PigWalletSPine2',
  //       styleInformation: BeautyStyleInformation(
  //         title: '',
  //         body: '',
  //         image:'',
  //         button:'Claim',
  //         appIcon:'ps_logo',
  //       ),
  //       priority: Priority.high,
  //       importance: Importance.high,
  //       icon: 'ps_sm_logo',
  //     ),
  //   );
  // }

  Future<void> _showUnlockNotification() async {
    //自定义通知ID
    final int ids = 2829;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 30),
      'android.intent.action.USER_PRESENT',
      AndroidNotificationDetails(
        '152PigWalletSPines',
        'PigWalletSPines',
        priority: Priority.high,
        importance: Importance.high,
        icon: 'ps_sm_logo',
        styleInformation: BeautyStyleInformation(
          title: randomMotivation2.title,
          body: randomMotivation2.body,
          image:'ps_notice_big',
          button:'Withdraw',
          appIcon:'ps_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'unlock',
    );
  }

  Future<void> _showScreenOnNotification() async {
    //自定义通知ID
    final int ids = 1029;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 = StepMotivationManager.getRandomMotivation();;
    await AndroidFlutterLocalNotificationsPlugin().showBroadcastNotification(
      ids,
      randomMotivation.title,
      randomMotivation.body,
      //两次发送解锁通知的间隔，根据需求设置
      const Duration(seconds: 30),
      'android.intent.action.SCREEN_ON',
      AndroidNotificationDetails(
        '152PigWalletSPinescreen',
        'PigWalletSPineScreen',
        priority: Priority.high,
        importance: Importance.high,
        icon: 'ps_sm_logo',
        styleInformation: BeautyStyleInformation(
          title: randomMotivation2.title,
          body: randomMotivation2.body,
          image:'ps_notice_big',
          button:'Withdraw',
          appIcon:'ps_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'screenon',
    );
  }


  Future<void> _initLifecycleListener() async {

    FlutterLifecycleDetector().onBackgroundChange.listen((isBackground) async {
      /// `isBackground` is true => background
      /// `isBackground` is false => foreground
      print('Status background $isBackground');
      if (isBackground == true) {
        print('App进入后台');
        // SJAudioUtils().pauseBGM();
        PSFKManger().ps_add_tabsession_custom();
        // 执行后台逻辑
        ps_session_fire();
        ps_event_fire('session_back_get', {'"pak_version' : PSLocalProvider.instance.ps_login_status ? 1 : 0});
      } else {
        print('App进入前台');
        // if (PSLocalProvider.instance.ps_bg_music && !SJJoyAds().someAdIsShowing()){
        //   SJAudioUtils().playBGM();
        // }
        PSFKManger().ps_add_tabsession_custom();
        ps_event_fire('session_front_get', {'"pak_version' : PSLocalProvider.instance.ps_login_status ? 1 : 0});
        // 执行前台逻辑
        ps_session_fire();
        PSPigAds().ps_showAd(homeKey.currentState!.context, 'nskdh_launch', onCacheResponse: (onCacheResponse){
        }, adDidClosed: (adDidClosed){
        });
      }
    });
  }

}
/// 步行激励文案数据模型
class StepMotivation {
  final String title;
  final String body;

  StepMotivation({
    required this.title,
    required this.body,
  });
}

/// 步行激励文案工具类
class StepMotivationManager {
  // 文案数据列表
  static final List<StepMotivation> _motivations = [
    StepMotivation(
      title: "Piggy Almost Full!",
      body: 'You’ve saved ${0.dolasType()}4.80—cash out before it spills!',
    ),
    StepMotivation(
      title: "Cash-Out Time 🎉",
      body: "Spin & play—your balance is ready to grab!",
    ),
    StepMotivation(
      title: "Your Payout Is Ready! 💰",
      body: "Piggy bank is full and ready to pop—open the app to collect your cash.",
    ),
    StepMotivation(
      title: "Advertiser Just Paid You! 🎁",
      body: "Tap to feed your piggy & claim today’s payout.",
    ),
    StepMotivation(
      title: " Balance Near Max 💵",
      body: "Almost full—withdraw before it’s gone!",
    ),
    // StepMotivation(
    //   title: "Congrats! You've Earned a lot! 🎉",
    //   body: "Another \$ 500 cash in your pocket! Keep playing for more!",
    // ),
    // StepMotivation(
    //   title: "Feeling Lucky Today? 🍀",
    //   body: "Come and try your luck, win a fortune!",
    // ),
    // StepMotivation(
    //   title: "Pending withdraw amount💰",
    //   body: "\$500 has arrived in your account",
    // ),
    // StepMotivation(
    //   title: "Your Next Cash Reward is Ready! 👉",
    //   body: "Just a few more games to claim your \$800 cash!",
    // ),
    // StepMotivation(
    //   title: "\$1,000,000 Spectacular",
    //   body: "🎰 Congrats! Your \$1,000,000 Spectacular ticket is activated!",
    // ),
    // StepMotivation(
    //   title: "💥Fast \$50s – Speed Boost Activated!",
    //   body: "💸 Your Fast \$50s ticket is ready!",
    // ),
    // StepMotivation(
    //   title: "💰Multiplier Rewards Available!",
    //   body: "24-hour special: Next multiplier DOUBLED!",
    // ),
  ];

  /// 随机获取一条激励文案
  static StepMotivation getRandomMotivation() {
    final random = DateTime.now().microsecond % _motivations.length;
    return _motivations[random];
  }

}