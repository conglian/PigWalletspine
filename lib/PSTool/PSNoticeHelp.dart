import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class PSNoticeHelp with WidgetsBindingObserver {
  static final PSNoticeHelp _instance = PSNoticeHelp._internal();

  factory PSNoticeHelp() {
    return _instance;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  PSNoticeHelp._internal();

  bool _initialized = false;
  Future<bool>? _permissionRequest;

  // 冷启动由启动页和首页共享同一次系统权限申请，避免拒绝后连续重复弹窗。
  Future<bool> requestPermissionOnce() =>
      _permissionRequest ??= AndroidFlutterLocalNotificationsPlugin()
          .requestNotificationsPermission()
          .then((value) => value ?? false);
  bool _ready = false;
  bool _notificationsEnabled = false;
  Future<void> _permissionRefresh = Future.value();

  Future<void> initNotice(BuildContext context) async {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addObserver(this);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ps_logo'); // 不加 .png

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        'nf click response:${response}'.log();
        final String? payload = response.payload;
        ps_event_fire('inform_c', {'type': payload ?? ''});
        if (payload == null) return;
      },
    );

    NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await AndroidFlutterLocalNotificationsPlugin()
            .getNotificationAppLaunchDetails();
    '=initNotification====getNotificationAppLaunchDetails==notificationAppLaunchDetails:$notificationAppLaunchDetails='
        .log();

    if (notificationAppLaunchDetails != null) {
      NotificationResponse? notificationResponse =
          notificationAppLaunchDetails.notificationResponse;
      bool didNotificationLaunchApp =
          notificationAppLaunchDetails.didNotificationLaunchApp;
      if (didNotificationLaunchApp) {
        ps_event_fire('inform_c', {
          'type': notificationResponse?.payload ?? '',
        });
      }
    }

    final nfPermission =
        await AndroidFlutterLocalNotificationsPlugin()
                .areNotificationsEnabled() ==
            true ||
        await requestPermissionOnce();
    _notificationsEnabled = nfPermission;
    if (_notificationsEnabled) {
      ps_event_fire('push_status', {});
    } else {
      "nf no permission".log();
      if (context.mounted)
        context.tipShow(PSPopTipsToolDialog(adStatus: .noticeOpen));
    }
    _initLifecycleListener();
    unawaited(syncFcmTopics());
    if (_notificationsEnabled) await _scheduleFutureNotifications();
    await _spinitNotificationCount(flutterLocalNotificationsPlugin);
    _ready = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_ready && state == AppLifecycleState.resumed)
      refreshNotificationPermission();
  }

  /// 从系统设置授权后只恢复未来任务，不读取、重放历史通知。
  Future<void> refreshNotificationPermission() {
    _permissionRefresh = _permissionRefresh.then((_) async {
      try {
        final enabled =
            await AndroidFlutterLocalNotificationsPlugin()
                .areNotificationsEnabled() ??
            false;
        final granted = enabled && !_notificationsEnabled;
        _notificationsEnabled = enabled;
        if (granted) {
          unawaited(syncFcmTopics());
          await _scheduleFutureNotifications();
        }
      } catch (error) {
        'Notification permission refresh failed: $error'.log();
      }
    });
    return _permissionRefresh;
  }

  Future<void> _scheduleFutureNotifications() async {
    await startSJForegroundService();
    await _repeatNotification1();
    await _repeatNotification2();
    await _repeatNotification3();
    await _repeatNotification4();
    await _showUnlockNotification();
    await _showScreenOnNotification();
    await showSJNotificationMediaStyle1();
    await showSJNotificationMediaStyle2();
    await showSJNotificationMediaStyle3();
    await showSJNotificationMediaStyle4();
  }

  _spinitNotificationCount(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    try {
      int locals = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti1");
      "==initNotificationCount==localcount:$locals==".log();
      if (locals > 0) {
        for (int i = 0; i < locals; i++) {
          ps_event_fire('inform_p', {'type': "noti1"});
        }
      }
      int locals2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti2");
      "==initNotificationCount==localcount:$locals2==".log();
      if (locals2 > 0) {
        for (int i = 0; i < locals2; i++) {
          ps_event_fire('inform_p', {'type': "noti2"});
        }
      }
      int locals3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti3");
      "==initNotificationCount==localcount:$locals3==".log();
      if (locals3 > 0) {
        for (int i = 0; i < locals3; i++) {
          ps_event_fire('inform_p', {'type': "noti3"});
        }
      }
      int locals4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("noti4");
      "==initNotificationCount==localcount:$locals4==".log();
      if (locals4 > 0) {
        for (int i = 0; i < locals4; i++) {
          ps_event_fire('inform_p', {'type': "noti4"});
        }
      }
      int fcms = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("fcm");
      "==initNotificationCount==localcount:$fcms==".log();
      if (fcms > 0) {
        for (int i = 0; i < fcms; i++) {
          ps_event_fire('inform_p', {'type': "fcm"});
        }
      }

      int unlocks = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("unlock");
      "==initNotificationCount==localcount:$unlocks==".log();
      if (unlocks > 0) {
        for (int i = 0; i < unlocks; i++) {
          ps_event_fire('inform_p', {'type': "unlock"});
        }
      }

      int screenon = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("screenon");
      "==initNotificationCount==localcount:$screenon==".log();
      if (screenon > 0) {
        for (int i = 0; i < screenon; i++) {
          ps_event_fire('inform_p', {'type': "screenon"});
        }
      }

      int foreground = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("foreground");
      "==initNotificationCount==localcount:$foreground==".log();
      if (foreground > 0) {
        for (int i = 0; i < foreground; i++) {
          ps_event_fire('inform_p', {'type': "foreground"});
        }
      }

      int media = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media1");
      "==initNotificationCount==localcount:$media==".log();
      if (media > 0) {
        for (int i = 0; i < media; i++) {
          ps_event_fire('inform_p', {'type': "media"});
        }
      }

      int media2 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media2");
      "==initNotificationCount==localcount:$media==".log();
      if (media2 > 0) {
        for (int i = 0; i < media2; i++) {
          ps_event_fire('inform_p', {'type': "media"});
        }
      }

      int media3 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media3");
      "==initNotificationCount==localcount:$media==".log();
      if (media3 > 0) {
        for (int i = 0; i < media3; i++) {
          ps_event_fire('inform_p', {'type': "media"});
        }
      }

      int media4 = await AndroidFlutterLocalNotificationsPlugin()
          .extractMessageReceivedNum("media4");
      "==initNotificationCount==localcount:$media==".log();
      if (media4 > 0) {
        for (int i = 0; i < media4; i++) {
          ps_event_fire('inform_p', {'type': "media"});
        }
      }
    } catch (e) {
      "===initNotificationCount==error:$e=".log();
    }
  }

  Future<void> setNoticeStatus() async {
    final granted = await requestPermissionOnce();
    if (granted) {
      ps_event_fire('push_status', {});
      if (_ready)
        await refreshNotificationPermission();
      else
        _notificationsEnabled = true;
    } else {
      _notificationsEnabled = false;
    }
  }

  // 前台服务
  Future<void> startSJForegroundService() async {
    const channelId = 'pigwalletForeground';
    final country = PSLocale.current;
    final brand = PSLocale.paymentAssets[country.payments.first] ?? 'paypal';
    final balance = PSLocale.money(
      PSLocalProvider.instance.ps_dolas_number,
      country: country,
    );
    final channelName = PSLocale.translate('Wallet balance', country);
    final title = PSLocale.translate(
      '{p0} is waiting in your wallet.',
      country,
      {'p0': balance},
    );
    final withdraw = PSLocale.translate('Withdraw', country);
    final plugin = AndroidFlutterLocalNotificationsPlugin();
    // Reuse the channel ID so system notification preferences are preserved.
    await plugin.createNotificationChannel(
      AndroidNotificationChannel(
        channelId,
        channelName,
        importance: Importance.min,
      ),
    );
    await plugin.startForegroundService(
      1200,
      title,
      null,
      notificationDetails: AndroidNotificationDetails(
        channelId,
        channelName,
        ongoing: true,
        importance: Importance.min,
        priority: Priority.min,
        styleInformation: ForegroundStyleInformation(
          value: balance,
          image: 'ps_freground',
          logo: 'ps_foreground_$brand',
          button: withdraw,
        ),
      ),
      payload: 'foreground',
    );
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
      styleInformation: MediaStyleInformation(
        //支持网络图片链接
        image: 'ps_sm_logo',
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
      payload: "Media1",
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
      styleInformation: MediaStyleInformation(
        //支持网络图片链接
        image: 'ps_sm_logo',
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
      payload: "Media2",
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
      styleInformation: MediaStyleInformation(
        //支持网络图片链接
        image: 'ps_sm_logo',
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
      payload: "Media3",
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
      styleInformation: MediaStyleInformation(
        //支持网络图片链接
        image: 'ps_sm_logo',
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
      payload: "Media4",
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
        image: 'ps_notice_big',
        button: PSLocale.tr('Withdraw'),
        appIcon: 'ps_logo',
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
      payload: "noti1",
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
        image: 'ps_notice_big',
        button: PSLocale.tr('Withdraw'),
        appIcon: 'ps_logo',
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
      payload: "noti2",
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
        image: 'ps_notice_big',
        button: PSLocale.tr('Withdraw'),
        appIcon: 'ps_logo',
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
      payload: "noti3",
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
        image: 'ps_notice_big',
        button: PSLocale.tr('Withdraw'),
        appIcon: 'ps_logo',
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
      payload: "noti4",
    );
  }

  Future<void> _topicSync = Future.value();

  Future<void> syncFcmTopics() {
    _topicSync = _topicSync.then((_) async {
      try {
        final plugin = AndroidFlutterLocalNotificationsPlugin();
        final prefs = await SharedPreferences.getInstance();
        final topics = PSLocale.current.topics;
        final active =
            (prefs.getStringList('ps_fcm_topics') ?? PSLocale.fallback.topics)
                .toSet();
        for (final topic
            in active.where((topic) => !topics.contains(topic)).toList()) {
          if (await plugin.unsubscribeFromTopic(topic) == true) {
            active.remove(topic);
            await prefs.setStringList('ps_fcm_topics', active.toList());
          }
        }
        for (var i = 0; i < topics.length; i++) {
          if (await _subscribeFcmTopic(topics[i], secondary: i == 1) == true) {
            active.add(topics[i]);
            await prefs.setStringList('ps_fcm_topics', active.toList());
          }
        }
      } catch (error) {
        'FCM topic sync failed: $error'.log();
      }
    });
    return _topicSync;
  }

  Future<void> refreshLocalization() async {
    if (!Platform.isAndroid) return;
    unawaited(syncFcmTopics());
    _notificationsEnabled =
        await AndroidFlutterLocalNotificationsPlugin()
            .areNotificationsEnabled() ??
        false;
    if (_notificationsEnabled) {
      await _scheduleFutureNotifications();
    }
  }

  Future<bool?> _subscribeFcmTopic(String topic, {bool secondary = false}) {
    return AndroidFlutterLocalNotificationsPlugin().subscribeToTopic(
      topic,
      AndroidNotificationDetails(
        topic,
        secondary ? 'PigWalletSPine2' : 'PigWalletSPine',
        styleInformation: BeautyStyleInformation(
          title: '',
          body: '',
          image: '',
          button: PSLocale.tr(secondary ? 'Claim' : 'Withdraw'),
          appIcon: 'ps_logo',
        ),
        priority: Priority.high,
        importance: Importance.high,
        icon: 'ps_sm_logo',
      ),
    );
  }

  Future<void> _showUnlockNotification() async {
    //自定义通知ID
    final int ids = 2829;
    final randomMotivation = StepMotivationManager.getRandomMotivation();
    StepMotivation randomMotivation2 =
        StepMotivationManager.getRandomMotivation();
    ;
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
          image: 'ps_notice_big',
          button: PSLocale.tr('Withdraw'),
          appIcon: 'ps_logo',
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
    StepMotivation randomMotivation2 =
        StepMotivationManager.getRandomMotivation();
    ;
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
          image: 'ps_notice_big',
          button: PSLocale.tr('Withdraw'),
          appIcon: 'ps_logo',
        ),
        //“groupKey”：防止通知被系统折叠
        groupKey: "$ids",
      ),
      'screenon',
    );
  }

  bool _lifecycleListening = false;

  Future<void> _initLifecycleListener() async {
    if (_lifecycleListening) return;
    _lifecycleListening = true;

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
        ps_event_fire('session_back_get', {
          '"pak_version': PSLocalProvider.instance.ps_login_status ? 1 : 0,
        });
      } else {
        print('App进入前台');
        syncFcmTopics();
        // if (PSLocalProvider.instance.ps_bg_music && !SJJoyAds().someAdIsShowing()){
        //   SJAudioUtils().playBGM();
        // }
        PSFKManger().ps_add_tabsession_custom();
        ps_event_fire('session_front_get', {
          '"pak_version': PSLocalProvider.instance.ps_login_status ? 1 : 0,
        });
        // 执行前台逻辑
        ps_session_fire();
        if (!PSPigAds().is_showAd) {
          PSPigAds().ps_showAd(
            homeKey.currentState!.context,
            'nskdh_launch',
            showDialog: false,
            onCacheResponse: (onCacheResponse) {},
            adDidClosed: (adDidClosed) {},
          );
        }
      }
    });
  }
}

/// 步行激励文案数据模型
class StepMotivation {
  final String title;
  final String body;

  StepMotivation({required this.title, required this.body});
}

/// 步行激励文案工具类
class StepMotivationManager {
  // 文案数据列表
  static List<StepMotivation> get _motivations => [
    StepMotivation(
      title: PSLocale.tr("Piggy Almost Full!"),
      body: PSLocale.tr("You’ve saved {p0}—cash out before it spills!", {
        'p0': PSLocale.money(4.80),
      }),
    ),
    StepMotivation(
      title: PSLocale.tr("Cash-Out Time 🎉"),
      body: PSLocale.tr("Spin & play—your balance is ready to grab!"),
    ),
    StepMotivation(
      title: PSLocale.tr("Your Payout Is Ready! 💰"),
      body: PSLocale.tr(
        "Piggy bank is full and ready to pop—open the app to collect your cash.",
      ),
    ),
    StepMotivation(
      title: PSLocale.tr("Advertiser Just Paid You! 🎁"),
      body: PSLocale.tr("Tap to feed your piggy & claim today’s payout."),
    ),
    StepMotivation(
      title: " " + PSLocale.tr("Balance Near Max 💵"),
      body: PSLocale.tr("Almost full—withdraw before it’s gone!"),
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
