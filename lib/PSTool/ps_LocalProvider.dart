import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class PSLocalProvider extends ChangeNotifier {
  // 1. 私有构造函数（禁止外部直接创建实例）
  PSLocalProvider._();

  // 2. 静态单例实例
  static final PSLocalProvider _instance = PSLocalProvider._();

  // 3. 提供全局访问点
  static PSLocalProvider get instance => _instance;

  // SJTXModel txEntity = SJTXModel();

  String ps_account_id = '';
  String ps_tx_list = "";
  String ps_ratio_str = "90";

  bool ps_bg_music = true; // 存储的本地值
  bool ps_sound_music = true; // 存储的本地值
  bool ps_login_status = false; // 存储的本地值
  bool ps_scratch_status_0 = true;
  bool ps_scratch_status_1 = true;
  bool ps_scratch_status_2 = true;
  bool ps_scratch_status_3 = true;
  bool ps_scratch_status_4 = true;
  bool ps_scratch_status_5 = true;
  bool ps_scratch_status_6 = true;
  bool ps_scratch_status_7 = true;
  bool ps_scratch_status_8 = true;
  bool ps_scratch_guide = true;
  bool ps_old_guide = true;
  bool ps_new_guide = false;
  bool is_end_Scratch = true;
  bool ps_show_dolas_ani = false;
  bool ps_show_bubble = false;
  bool ps_show_box_guide = false;
  bool ps_cloak_status = false;
  bool ps_fk_number_status = false;
  bool ps_fk_decvice_status = false;
  bool ps_fk_ip_status = false;
  bool ps_fk_ad_short_show = false;
  bool ps_fk_ad_short_close = false;
  bool ps_dolas_800 = false;
  bool ps_dolas_1000 = false;
  bool ps_yunying_3 = false;
  bool ps_yunying_1 = false;
  bool ps_100_timer_star = false;
  bool ps_txing_status = false;
  bool ps_tx_first_status = false;
  bool ps_tx_last_status = false;
  bool ps_show_box_tips = false;
  bool ps_first_box_tips = false;
  bool ps_first_show_cash = false;
  bool ps_open_tx = false;
  bool ps_tx_task2_tips = false;
  bool ps_last_tx_end = false;
  bool ps_show_box = false;
  bool ps_tx_task3_tips = false;
  bool ps_tx_task4_tips = false;
  bool ps_tx_end_status = false;
  bool ps_afSwitch = true;
  bool ps_set_root = false;
  bool ps_af_status = false;
  bool ps_newA_guide = false;
  bool ps_good_review_status = false;

  int ps_scrach_unlock_index_0 = 0; // 存储的本地值
  int ps_scrach_unlock_index_1 = 0; // 存储的本地值
  int ps_ad_all_number = 0;
  double ps_dolas_number = 0.0;
  double ps_dolas_old_number = 0.0;
  int ps_ad_reawrd_all_number = 0;
  int ps_ad_short_show_number = 0;
  int ps_ad_short_close_number = 0;
  int ps_ad_show_index = 0;
  int ps_ad_show_number = 0;
  int ps_key_number = 0;
  int ps_account_seled_index = 0;
  int ps_tx_ing_account = 0;
  int ps_tx_ing_number = 0;
  int ps_tx_task_index = 0;
  int ps_current_ranking = 99;
  int ps_all_ranking = 388;
  int ps_rank_ad_count = 0;
  int ps_tx_card_index = 0;
  int ps_tx_wheel_index = 0;
  int ps_tx_bubble_index = 0;
  int ps_tx_box_index = 0;
  int ps_box_index = 0;
  int ps_card_number = 0;
  int ps_Level_number = 1; // 存储的本地值
  int ps_Level_inedx = 1; // 存储的本地值
  int ps_dice_number = 0;
  int ps_card_a_number = 0;
  int ps_scrach_end_number_0 = 0; // 存储的本地值
  int ps_scrach_end_number_1 = 0; // 存储的本地值
  int ps_scrach_end_number_2 = 0; // 存储的本地值
  int ps_scrach_end_number_3 = 0; // 存储的本地值
  int ps_scrach_end_number_4 = 0; // 存储的本地值
  int ps_scrach_end_number_5 = 0; // 存储的本地值
  int ps_scrach_end_number_6 = 0; // 存储的本地值
  int ps_currentNumberIndex = 0;
  int ps_domand_number = 0;
  int ps_tx_card_first = 0;
  int ps_tx_dice_index = 0;

  // int ps_login_index = 0;
  // int ps_tx_probability_index = 0;
  int ps_scratch_not_award_number = 0;

  // 主题类型
  int ps_quiz_model_index = 0;

  // 当前第几题
  int ps_quiz_num_index = 0;
  int ps_quzi_row = 0;
  int ps_wheel_number = 3;
  int ps_pig_level = 0;
  int ps_pig_level_index = 2;

  String get ps_currentNumberIndexName => 'ps_currentNumberIndex';

  String get ps_dice_numberName => 'ps_dice_number';

  String get ps_domand_numberName => 'ps_domand_number';

  String get ps_sound_musicName => 'ps_sound_music';

  String get ps_bg_musicName => 'ps_bg_music';

  String get ps_Level_numberName => 'ps_Level_number';

  String get ps_Level_inedxName => 'ps_Level_inedx';

  String get ps_fk_number_statusName => 'ps_fk_number_status';

  String get ps_fk_ip_statusName => 'ps_fk_ip_status';

  String get ps_fk_decvice_statusName => 'ps_fk_decvice_status';

  String get ps_ad_show_numberName => 'ps_ad_show_number';

  String get ps_ad_all_numberName => 'ps_ad_all_number';

  String get ps_ad_show_indexName => 'ps_ad_show_index';

  String get ps_ad_reawrd_all_numberName => 'ps_ad_reawrd_all_number';

  String get ps_ad_short_show_numberName => 'ps_ad_short_show_number';

  String get ps_fk_ad_short_showName => 'ps_fk_ad_short_show';

  String get ps_ad_short_close_numberName => 'ps_ad_short_close_number';

  String get ps_fk_ad_short_closeName => 'ps_fk_ad_short_close';

  String get ps_new_guideName => 'ps_new_guide';

  String get ps_ratio_strName => 'ps_ratio_str';

  String get ps_dolas_1000Name => 'ps_dolas_1000';

  String get ps_dolas_800Name => 'ps_dolas_800';

  String get ps_100_timer_starName => 'ps_100_timer_star';

  String get ps_dolas_numberName => 'ps_dolas_number';

  String get ps_card_numberName => 'ps_card_number';

  String get ps_show_dolas_aniName => 'ps_show_dolas_ani';

  String get ps_box_indexName => 'ps_box_index';

  String get ps_txing_statusName => 'ps_txing_status';

  String get ps_tx_ing_numberName => 'ps_tx_ing_number';

  String get ps_account_seled_indexName => 'ps_account_seled_index';

  String get ps_tx_ing_accountName => 'ps_tx_ing_account';

  String get ps_tx_bubble_indexName => 'ps_tx_bubble_index';

  String get ps_tx_card_indexName => 'ps_tx_card_index';

  String get ps_tx_wheel_indexName => 'ps_tx_wheel_index';

  String get ps_tx_box_indexName => 'ps_tx_box_index';

  String get ps_tx_task_indexName => 'ps_tx_task_index';

  String get ps_tx_card_firstName => 'ps_tx_card_first';

  String get ps_account_idName => 'ps_account_id';

  String get ps_tx_dice_indexName => 'ps_tx_dice_index';

  // String get ps_login_indexName => 'ps_login_index';
  // String get ps_tx_probability_indexName => 'ps_tx_probability_index';
  String get ps_tx_first_statusName => 'ps_tx_first_status';

  String get ps_tx_last_statusName => 'ps_tx_last_status';

  String get ps_current_rankingName => 'ps_current_ranking';

  String get ps_all_rankingName => 'ps_all_ranking';

  String get ps_old_guideName => 'ps_old_guide';

  String get ps_scratch_not_award_numberName => 'ps_scratch_not_award_number';

  String get ps_cloak_statusName => 'ps_cloak_status';

  String get ps_show_box_tipsName => 'ps_show_box_tips';

  String get ps_first_box_tipsName => 'ps_first_box_tips';

  String get ps_first_show_cashName => 'ps_first_show_cash';

  String get ps_scratch_guideName => 'ps_scratch_guide';

  String get ps_open_txName => 'ps_open_tx';

  String get ps_tx_task2_tipsName => 'ps_tx_task2_tips';

  String get ps_last_tx_endName => 'ps_last_tx_end';

  String get is_end_ScratchName => 'is_end_Scratch';

  String get ps_yunying_1Name => 'ps_yunying_1';

  String get ps_yunying_3Name => 'ps_yunying_3';

  String get ps_show_boxName => 'ps_show_box';

  String get ps_tx_task3_tipsName => 'ps_tx_task3_tips';

  String get ps_tx_task4_tipsName => 'ps_tx_task4_tips';

  String get ps_tx_end_statusName => 'ps_tx_end_status';

  String get ps_dolas_old_numberName => 'ps_dolas_old_number';

  String get ps_afSwitchName => 'ps_afSwitch';

  String get ps_set_rootName => 'ps_set_root';

  String get ps_login_statusName => 'ps_login_status';

  String get ps_af_statusName => 'ps_af_status';

  String get ps_newA_guideName => 'ps_newA_guide';

  String get ps_good_review_statusName => 'ps_good_review_status';

  String get ps_card_a_numberName => 'ps_card_a_number';

  String get ps_quiz_model_indexName => 'ps_quiz_model_index';

  String get ps_quiz_num_indexName => 'ps_quiz_num_index';

  String get ps_quzi_rowName => 'ps_quzi_row';

  String get ps_wheel_numberName => 'ps_wheel_number';

  String get ps_pig_levelName => 'ps_pig_level';

  String get ps_pig_level_indexName => 'ps_pig_level_index';

  // 3. 初始化：从本地存储加载数据（组件初始化时调用）
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // 从本地读取值（key自定义，需与存储时一致）
    // ps_tx_probability_index = prefs.getInt('ps_tx_probability_index') ?? 0;
    // ps_login_index = prefs.getInt('ps_login_index') ?? 0;
    ps_tx_dice_index = prefs.getInt('ps_tx_dice_index') ?? 0;
    ps_tx_card_first = prefs.getInt('ps_tx_card_first') ?? 0;
    ps_domand_number = prefs.getInt('ps_domand_number') ?? 0;
    ps_dice_number = prefs.getInt('ps_dice_number') ?? 0;
    ps_card_number = prefs.getInt('ps_card_number') ?? 0;
    ps_box_index = prefs.getInt('ps_box_index') ?? 0;
    ps_tx_box_index = prefs.getInt('ps_tx_box_index') ?? 0;
    ps_wheel_number = prefs.getInt('ps_wheel_number') ?? 0;
    ps_pig_level = prefs.getInt('ps_pig_level') ?? 0;
    ps_pig_level_index = prefs.getInt('ps_pig_level_index') ?? 2;
    ps_tx_card_index = prefs.getInt('ps_tx_card_index') ?? 0;
    ps_tx_wheel_index = prefs.getInt('ps_tx_wheel_index') ?? 0;
    ps_tx_bubble_index = prefs.getInt('ps_tx_bubble_index') ?? 0;
    ps_current_ranking = prefs.getInt('ps_current_ranking') ?? 99;
    ps_all_ranking = prefs.getInt('ps_all_ranking') ?? 388;
    ps_rank_ad_count = prefs.getInt('ps_rank_ad_count') ?? 388;
    ps_tx_task_index = prefs.getInt('ps_tx_task_index') ?? 0;
    ps_tx_ing_account = prefs.getInt('ps_tx_ing_account') ?? 0;
    ps_tx_ing_number = prefs.getInt('ps_tx_ing_number') ?? 0;
    ps_card_a_number = prefs.getInt('ps_card_a_number') ?? 0;
    ps_quiz_model_index = prefs.getInt('ps_quiz_model_index') ?? 0;
    ps_quiz_num_index = prefs.getInt('ps_quiz_num_index') ?? 0;
    ps_scratch_not_award_number =
        prefs.getInt('ps_scratch_not_award_number') ?? 0;
    ps_account_seled_index = prefs.getInt('ps_account_seled_index') ?? 0;
    ps_scrach_unlock_index_0 = prefs.getInt('ps_scrach_unlock_index_0') ?? 0;
    ps_scrach_unlock_index_1 = prefs.getInt('ps_scrach_unlock_index_1') ?? 0;
    ps_ad_short_show_number = prefs.getInt('ps_ad_short_show_number') ?? 0;
    ps_ad_short_close_number = prefs.getInt('ps_ad_short_close_number') ?? 0;
    ps_ad_show_number = prefs.getInt('ps_ad_show_number') ?? 0;
    ps_key_number = prefs.getInt('ps_key_number') ?? 0;
    ps_quzi_row = prefs.getInt('ps_quzi_row') ?? 0;
    ps_wheel_number = prefs.getInt('ps_wheel_number') ?? 3;
    ps_bg_music = prefs.getBool('ps_bg_music') ?? true;
    ps_sound_music = prefs.getBool('ps_sound_music') ?? true;
    ps_tx_task3_tips = prefs.getBool('ps_tx_task3_tips') ?? false;
    ps_tx_task4_tips = prefs.getBool('ps_tx_task4_tips') ?? false;
    ps_txing_status = prefs.getBool('ps_txing_status') ?? false;
    ps_login_status = prefs.getBool('ps_login_status') ?? false;
    ps_good_review_status = prefs.getBool('ps_good_review_status') ?? false;
    ps_open_tx = prefs.getBool('ps_open_tx') ?? false;
    ps_show_box = prefs.getBool('ps_show_box') ?? false;
    ps_afSwitch = prefs.getBool('ps_afSwitch') ?? true;
    ps_set_root = prefs.getBool('ps_set_root') ?? false;
    ps_af_status = prefs.getBool('ps_af_status') ?? false;
    is_end_Scratch = prefs.getBool('is_end_Scratch') ?? true;
    ps_cloak_status = prefs.getBool('ps_cloak_status') ?? false;
    ps_show_box_tips = prefs.getBool('ps_show_box_tips') ?? false;
    ps_first_box_tips = prefs.getBool('ps_first_box_tips') ?? false;
    ps_fk_number_status = prefs.getBool('ps_fk_number_status') ?? false;
    ps_fk_decvice_status = prefs.getBool('ps_fk_decvice_status') ?? false;
    ps_fk_ad_short_show = prefs.getBool('ps_fk_ad_short_show') ?? false;
    ps_fk_ad_short_close = prefs.getBool('ps_fk_ad_short_close') ?? false;
    ps_fk_ip_status = prefs.getBool('ps_fk_ip_status') ?? false;
    ps_newA_guide = prefs.getBool('ps_newA_guide') ?? false;
    ps_scratch_guide = prefs.getBool('ps_scratch_guide') ?? true;
    ps_old_guide = prefs.getBool('ps_old_guide') ?? true;
    ps_new_guide = prefs.getBool('ps_new_guide') ?? false;
    ps_show_bubble = prefs.getBool('ps_show_bubble') ?? false;
    ps_show_dolas_ani = prefs.getBool('ps_show_dolas_ani') ?? false;
    ps_show_box_guide = prefs.getBool('ps_show_box_guide') ?? false;
    ps_dolas_800 = prefs.getBool('ps_dolas_800') ?? false;
    ps_dolas_1000 = prefs.getBool('ps_dolas_1000') ?? false;
    ps_100_timer_star = prefs.getBool('ps_100_timer_star') ?? false;
    ps_tx_first_status = prefs.getBool('ps_tx_first_status') ?? false;
    ps_tx_last_status = prefs.getBool('ps_tx_last_status') ?? false;
    ps_first_show_cash = prefs.getBool('ps_first_show_cash') ?? false;
    ps_tx_task2_tips = prefs.getBool('ps_tx_task2_tips') ?? false;
    ps_last_tx_end = prefs.getBool('ps_last_tx_end') ?? false;
    ps_yunying_3 = prefs.getBool('ps_yunying_3') ?? false;
    ps_yunying_1 = prefs.getBool('ps_yunying_1') ?? false;
    ps_tx_end_status = prefs.getBool('ps_tx_end_status') ?? false;
    ps_ad_reawrd_all_number = prefs.getInt('ps_ad_reawrd_all_number') ?? 0;
    ps_ad_all_number = prefs.getInt('ps_ad_all_number') ?? 0;
    ps_dolas_number = prefs.getDouble('ps_dolas_number') ?? 0.0;
    ps_dolas_old_number = prefs.getDouble('ps_dolas_old_number') ?? 0.0;
    ps_ad_show_index = prefs.getInt('ps_ad_show_index') ?? 0;
    ps_Level_number = prefs.getInt('ps_Level_number') ?? 1;
    ps_Level_inedx = prefs.getInt('ps_Level_inedx') ?? 1;
    ps_scrach_end_number_0 = prefs.getInt('ps_scrach_end_number_0') ?? 0;
    ps_scrach_end_number_1 = prefs.getInt('ps_scrach_end_number_1') ?? 0;
    ps_scrach_end_number_2 = prefs.getInt('ps_scrach_end_number_2') ?? 0;
    ps_scrach_end_number_3 = prefs.getInt('ps_scrach_end_number_3') ?? 0;
    ps_scrach_end_number_4 = prefs.getInt('ps_scrach_end_number_4') ?? 0;
    ps_scrach_end_number_5 = prefs.getInt('ps_scrach_end_number_5') ?? 0;
    ps_scrach_end_number_6 = prefs.getInt('ps_scrach_end_number_6') ?? 0;
    ps_currentNumberIndex = prefs.getInt('ps_currentNumberIndex') ?? 0;
    ps_scratch_status_0 = prefs.getBool('ps_scratch_status_0') ?? true;
    ps_scratch_status_1 = prefs.getBool('ps_scratch_status_1') ?? true;
    ps_scratch_status_2 = prefs.getBool('ps_scratch_status_2') ?? true;
    ps_scratch_status_3 = prefs.getBool('ps_scratch_status_3') ?? true;
    ps_scratch_status_4 = prefs.getBool('ps_scratch_status_4') ?? true;
    ps_scratch_status_5 = prefs.getBool('ps_scratch_status_5') ?? true;
    ps_scratch_status_6 = prefs.getBool('ps_scratch_status_6') ?? true;
    ps_scratch_status_7 = prefs.getBool('ps_scratch_status_7') ?? true;
    ps_scratch_status_8 = prefs.getBool('ps_scratch_status_8') ?? true;
    ps_ratio_str = prefs.getString('ps_ratio_str') ?? '90';
    ps_account_id = prefs.getString('ps_account_id') ?? '';
    ps_tx_list = prefs.getString("ps_tx_list") ?? "";
    // init tx
    // if (ps_tx_list.isEmpty) {
    //   String jsonTXString = await rootBundle.loadString("ps_tx_list".jsons());
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   prefs.setString('ps_tx_list',jsonTXString);
    //   txEntity = SJTXModel.fromJson(json_tx);
    // } else {
    //   String jsonTXString = prefs.getString('ps_tx_list') ?? "";
    //   Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    //   txEntity = SJTXModel.fromJson(json_tx);
    // }
    notifyListeners(); // 加载完成后通知UI更新
  }

  // 通用bool
  Future<void> updateBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    init();
    notifyListeners();
  }

  // 通用int
  Future<void> updateint(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
    init();
    notifyListeners();
  }

  // 通用double
  Future<void> updatedouble(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    if (key == PSLocalProvider.instance.ps_dolas_numberName &&
        ps_dolas_number <= 0) {
      await updateBool(ps_first_show_cashName, true);
    }
    if (key == PSLocalProvider.instance.ps_dolas_numberName && value > 0) {
      await updatedouble(ps_dolas_old_numberName, ps_dolas_old_number + value);
    }
    if (key == PSLocalProvider.instance.ps_dolas_numberName) {
      value += ps_dolas_number;
    }
    await prefs.setDouble(key, value);
    // if (key == PSLocalProvider.instance.ps_dolas_numberName && value > 0){
    //   trigger.check(PSLocalProvider.instance.ps_dolas_number.toInt(), onTrigger: (level) {
    //     print("触发 → 达到 $level");
    //     ps_event_fire('cash_dall', {'money' : level});
    //   });
    //   await updateBool(ps_show_dolas_aniName, true);
    // }
    if (key == PSLocalProvider.instance.ps_dolas_numberName) {
      // SJNoticeHelp().startSJForegroundService();
    }
    init();
    notifyListeners();
  }

  // 通用String
  Future<void> updateString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    init();
    notifyListeners();
  }

  Future<void> updateTXInStatus(int status) async {
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // txEntity.tx_info[ps_tx_ing_account].tx_list[ps_tx_ing_number].status = status;
    // sharedPreferences.setString('ps_tx_list', jsonEncode(txEntity.toJson()));
    // String jsonTXString = sharedPreferences.getString('ps_tx_list') ?? "";
    // Map<String, dynamic> json_tx = jsonDecode(jsonTXString);
    // txEntity = SJTXModel.fromJson(json_tx);
  }
}
