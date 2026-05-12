import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PSUserData {
  final int id;
  final String username;
  final double totalEarning;
  final int adsWatched;

  PSUserData({
    required this.id,
    required this.username,
    required this.totalEarning,
    required this.adsWatched,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'totalEarning': totalEarning,
    'adsWatched': adsWatched,
  };

  factory PSUserData.fromJson(Map<String, dynamic> json) {
    return PSUserData(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      username: json['username'].toString(),
      totalEarning: json['totalEarning'] is double
          ? json['totalEarning']
          : double.parse(json['totalEarning'].toString()),
      adsWatched: json['adsWatched'] is int
          ? json['adsWatched']
          : int.parse(json['adsWatched'].toString()),
    );
  }
}

class PSUserDataManager {
  static const String _lastUpdateKey = 'lastUpdate';
  static const String _dataKey = 'PSUserData';
  static final Random _random = Random();

  /// 生成随机用户数据
  static List<PSUserData> generatePSUserData() {
    List<PSUserData> list = [];
    List<double> earnings = [];
    List<int> ads = [];

    // 生成 Total earning
    // 前三条 > 100 且 < 200
    for (int i = 0; i < 3; i++) {
      earnings.add(100 + _random.nextDouble() * 100); // 100~200
      ads.add(100 + _random.nextInt(100)); // 100~199
    }

    // 后面 53 条 < 100
    for (int i = 3; i < 56; i++) {
      earnings.add(_random.nextDouble() * 100); // 0~100
      ads.add(_random.nextInt(100)); // 0~99
    }

    // 按从大到小排序
    earnings.sort((b, a) => a.compareTo(b));
    ads.sort((b, a) => a.compareTo(b));

    List<String> regions = ['Texas', 'Brazil'];

    for (int i = 0; i < 56; i++) {
      String username =
          'User ****${1000 + _random.nextInt(9000)} (${regions[_random.nextInt(2)]})';
      list.add(PSUserData(
        id: i,
        username: username,
        totalEarning: double.parse(earnings[i].toStringAsFixed(2)),
        adsWatched: ads[i],
      ));
    }

    return list;
  }

  /// 保存数据到本地
  static Future<void> savePSUserData(List<PSUserData> data) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = data.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_dataKey, jsonList);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  /// 加载本地数据
  static Future<List<PSUserData>> loadPSUserData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_dataKey);
    if (jsonList == null) return [];

    return jsonList.map((e) {
      Map<String, dynamic> map = jsonDecode(e);
      return PSUserData.fromJson(map);
    }).toList();
  }

  /// 获取数据，如果当天没更新则刷新
  static Future<List<PSUserData>> getPSUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? lastUpdateStr = prefs.getString(_lastUpdateKey);

    bool needUpdate = true;
    if (lastUpdateStr != null) {
      DateTime lastUpdate = DateTime.parse(lastUpdateStr);
      DateTime now = DateTime.now();
      // 如果上次更新是今天则不更新
      if (lastUpdate.year == now.year &&
          lastUpdate.month == now.month &&
          lastUpdate.day == now.day) {
        needUpdate = false;
      }
    }

    if (needUpdate) {
      List<PSUserData> newData = generatePSUserData();
      await savePSUserData(newData);
      return newData;
    } else {
      return await loadPSUserData();
    }
  }
}