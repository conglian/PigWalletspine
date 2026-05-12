import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:http/http.dart' as http;
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:pigwalletspineFK/pigwalletspineFK.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../PSModel/PSFkModel.dart';
import 'PSTBAEventTool.dart';

class PSFKManger {
  static final PSFKManger _instance = PSFKManger._internal();

  factory PSFKManger() {
    return _instance;
  }

  PSFKManger._internal();

  PSFkModel fkModel = PSFkModel();

  Future<void> initFKJson() async {
    'fkModel=$fkModel'.log();
    if (fkModel.behavior.ad_daily_show == 0) {
      String jsonString = await rootBundle.loadString("ps_control152".jsons());
      'risk_control=$jsonString'.log();
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      fkModel = PSFkModel.fromJson(jsonMap);
    }
    "pigwalletspine fk json = ${fkModel.behavior.ad_daily_show}".log();
  }


  Future<void> initFK() async {
    ps_checkRoot();
    ps_checkVpn();
    ps_checkSim();
    ps_checkSimulator();
    ps_checkDeveloper();
    ps_checkStore();
    ps_checkIP();
    ps_checkNum();
  }

  // 是否需要打开风控
  Future<bool> ps_checkAllStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String types = 'number';
    // behavior
    bool behavior = await ps_checkUser();
    'behavior=$behavior'.log();
    if (behavior){
      types = 'behavior';
    }
    // number
    bool number = prefs.getBool('ps_fk_number_status') ?? false;
    'number=$number'.log();
    if (number){
      types = 'number';
    }
    // device
    bool device = prefs.getBool('ps_fk_decvice_status') ?? false;
    'device=$device'.log();
    if (device){
      types = 'device';
    }
    if (behavior || number || device){
      ps_event_fire(
        "nskdh_fk_head_off",
        {
          "type": types,
        },
      );
      return true;
    }
    return false;
  }

  // 获取用户异常行为状态
  Future<bool> ps_checkUser() async {
    // 开关未打开
    if(fkModel.ui.behavior == 0){
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    'PSLocalProvider.instance.ps_fk_ad_short_show2 = ${PSLocalProvider.instance.ps_fk_ad_short_show}'.log();
    // 两次rv间隔时间小于30s，3次以上
    if(prefs.getBool('ps_fk_ad_short_show') == true){
      return true;
    }
    // RV 从播放到收到关闭回调时间小于20s，3次以上
    if(prefs.getBool('ps_fk_ad_short_close') == true){
      return true;
    }
    // //现金金额达到提现门槛,视频数少于3次
    if((prefs.getInt('ps_ad_all_number') ?? 0) < fkModel.behavior.wrong_deem_ad_less && (prefs.getInt('ps_dolas_old_number') ?? 0) >= 1000){
      ps_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_less'});
      return true;
    }
    // 用户观看90次RV(不包含插屏)，未到提现门槛
    if((prefs.getInt('ps_ad_reawrd_all_number') ?? 0) >= fkModel.behavior.wrong_deem_ad_more && (prefs.getInt('ps_dolas_old_number') ?? 0) < 1000){
      ps_event_fire('risk_chance', {'risk_from' : 'wrong_deem_ad_more'});
      return true;
    }
    return false;
  }

  // 数字联盟
  ps_checkNum()async{
    var numberUnitID = await PigwalletspineFK.instance.ps_getNumberUnitID();
    var url = Uri.parse('https://sg-ddi.shuzilm.cn/q');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({"protocol":2,"pkg":await FlutterTbaInfo.instance.getBundleId(),"did":numberUnitID}),
      );
      print("upload event [Number] success ${response.body}");

      try{
        //{"protocol":2,"ver":"1.0.1","err":0,"device_type":0,"normal_times":0,
        // "duplicate_times":0,"update_times":1,"recall_times":0}
        var json = jsonDecode(response.body);
        if(json["err"] == 0 && json["device_type"] != 0 && fkModel.ui.number == 1){
          ps_event_fire('risk_chance', {'risk_from' : 'number'});
          await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_number_statusName,true);
        }else{
          await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_number_statusName,false);
        }
      }catch(e){
        await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_number_statusName,false);
      }

    } catch (e) {
      await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_number_statusName,false);
      "upload event [Number] faild".log();
    }

  }

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  // 设备 Ip
  ps_checkIP()async{

    var url = Uri.parse('https://ip-prod.piggywalletspinfunpro.com/api/clion');
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode({
          "aduck" : await FlutterTbaInfo.instance.getAndroidId(),
        }),
      );
      print("upload event [IP] success ${response.body}");
      //{"code":200,"msg":"Success","data":{"blion":false}}
      var result = BoomUniqueStringUtil.decrypt(response.body, 45);
      print("upload event [IP] success ${result}");
      try{
        var bfrog = jsonDecode(result)["data"]["bfrog"];
        if(bfrog && fkModel.device.contains('ip') && fkModel.ui.device == 1){
          ps_event_fire('risk_chance', {'risk_from' : 'ip'});
          await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_ip_statusName,true);
        }
      }catch(e){
        await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_ip_statusName,false);
      }

    } catch (e) {
      await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_ip_statusName,false);
      "upload event [IP] faild".log();
    }
  }

  ps_add_tabsession_custom() async {

    bool root = await ps_checkRoot();
    bool vpn = await ps_checkVpn();
    bool sim = await ps_checkSim();
    bool simulator = await ps_checkSimulator();
    bool developer = await ps_checkDeveloper();
    bool googleplay = await ps_checkStore();
    Map<String, dynamic> customer = {
      'root' : root ? 1 : 0,
      'vpn' : vpn ? 1 : 0,
      'sim' : sim ? 1 : 0,
      'simulator' : simulator ? 1 : 0,
      'developer' : developer ? 1 : 0,
      'googleplay' : googleplay ? 1 : 0,
    };
    ps_event_fire('session_custom', customer);

  }

  Future<bool> ps_checkRoot() async {
    var result = await PigwalletspineFK.instance.ps_root();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('root')){
      ps_event_fire('risk_chance', {'risk_from' : 'root'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ps_checkVpn() async {
    var result = await PigwalletspineFK.instance.ps_vpn();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('vpn')){
      ps_event_fire('risk_chance', {'risk_from' : 'vpn'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ps_checkSim() async {
    var result = await PigwalletspineFK.instance.ps_sim();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('sim')){
      ps_event_fire('risk_chance', {'risk_from' : 'sim'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ps_checkSimulator() async {
    var result = await PigwalletspineFK.instance.ps_simulator();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('simulator')){
      ps_event_fire('risk_chance', {'risk_from' : 'simulator'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ps_checkDeveloper() async {
    var result = await PigwalletspineFK.instance.ps_developer();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(result && fkModel.device.contains('developer')){
      ps_event_fire('risk_chance', {'risk_from' : 'developer'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }

  Future<bool> ps_checkStore() async {
    var result = await PigwalletspineFK.instance.ps_store();
    if(fkModel.ui.device == 0){
      return false;
    }
    if(!result && fkModel.device.contains('googleplay')){
      ps_event_fire('risk_chance', {'risk_from' : 'googleplay'});
      PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_decvice_statusName,true);
      return true;
    }
    return false;
  }
}