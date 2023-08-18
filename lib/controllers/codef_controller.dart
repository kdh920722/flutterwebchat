import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/app_config.dart';
import '../utils/common_utils.dart';

class CodeFController{

  static final CodeFController _instance = CodeFController._internal();
  factory CodeFController() => _instance;
  CodeFController._internal();

  /// CODEF API ------------------------------------------------------------------------------------------------------------------------ ///
  static HostStatus hostStatus = HostStatus.prod;
  static String token = "";

  static void setHostStatus(HostStatus host){
    hostStatus = host;
  }

  static Future<void> initAccessToken(Function(bool) callback) async {
    const oauthDomain = "https://oauth.codef.io"; // Replace with the actual OAuth domain.
    const getTokenPath = "/oauth/token"; // Replace with the actual path to get the token.
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(oauthDomain + getTokenPath)}';
    }else{
      targetUrl = oauthDomain + getTokenPath;
    }

    try {
      final url = Uri.parse(targetUrl);
      const params = "grant_type=client_credentials&scope=read";

      final auth = hostStatus.value == HostStatus.prod.value
          ? '${Host.clientId.value}:${Host.clientSecret.value}'
          : '${HostDev.clientId.value}:${HostDev.clientSecret.value}';
      final authEncBytes = utf8.encode(auth);
      final authStringEnc = base64.encode(authEncBytes);
      final authHeader = "Basic $authStringEnc";

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": authHeader,
        },
        body: params,
      );

      if (response.statusCode == 200) { // HTTP_OK
        final decodedResponse = utf8.decode(response.bodyBytes);
        final decodedJson = json.decode(Uri.decodeComponent(decodedResponse));
        if (decodedJson.containsKey('access_token')) {
          token = decodedJson['access_token'];
          callback(true);
        } else {
          CommonUtils.log('e', 'json error : no value');
          callback(false);
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false);
    }
  }

  static Future<void> getDataFromApiOnApp(Apis apiInfo, Map<String, dynamic> inputJson,
      void Function(bool isSuccess, bool is2WayProcess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray) callback) async {
    final baseUrl = hostStatus.value == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
    final url = baseUrl + endPoint;
    final tokenHeader = 'Bearer $token';

    try {
      CommonUtils.log('i', 'call start');
      final response = await http.post(Uri.parse(url),
          headers: {
            'Authorization': tokenHeader,
            'Content-Type': 'application/json'
          },
          body: jsonEncode(inputJson)
      );

      if(response.statusCode == 200) {
        CommonUtils.log('i', 'call response here');
        final decodedResponseBody = Uri.decodeFull(response.body);
        final json = jsonDecode(decodedResponseBody);
        if(json.containsKey('result') && json.containsKey('data')){
          final result = json['result'];
          final resultCode = result['code'];
          CommonUtils.log('i', 'out full : \n$json');

          // CF-00000 : 성공, CF-03002 : 추가 인증 필요
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
            final resultData = json['data'];
            CommonUtils.log('i', 'out resultCode : $resultCode\nresultData : \n${resultData.toString()}');
            if (resultData is Map<String, dynamic>) {
              if(resultCode == 'CF-03002') {
                callback(true, true, resultData, null);
              } else {
                callback(true, false, resultData, null);
              }
            } else if (resultData is List<dynamic>) {
              if(resultCode == 'CF-03002') {
                callback(true, true, null, resultData);
              } else {
                callback(true, false, null, resultData);
              }
            } else{
              CommonUtils.log('i', '???');
            }

          } else {
            CommonUtils.log('e', 'out resultCode error : $resultCode');
            callback(false, false, null, null);
          }
        }
      } else {
        CommonUtils.log('e', response.statusCode.toString());
        callback(false, false, null, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, false, null, null);
    }
  }

  static Future<void> getDataFromApi(Apis apiInfo, Map<String, dynamic> inputJson,
      void Function(bool isSuccess, bool is2WayProcess, Map<String, dynamic>? outputJson, List<dynamic>? outputJsonArray) callback) async {
    final baseUrl = hostStatus.value == HostStatus.prod.value ? Host.baseUrl.value : HostDev.baseUrl.value;
    final endPoint = apiInfo.value;
    final url = baseUrl + endPoint;
    var targetUrl = "";
    if(Config.isWeb){
      targetUrl = 'https://corsproxy.io/?${Uri.encodeComponent(url)}';
    }else{
      targetUrl = url;
    }

    final tokenHeader = 'Bearer $token';

    try {
      final response = await http.post(Uri.parse(targetUrl),
          headers: {
            'Authorization': tokenHeader,
            'Content-Type': 'application/json'
          },
          body: jsonEncode(inputJson)
      );

      if(response.statusCode == 200) {
        final decodedResponseBody = Uri.decodeFull(response.body);
        final json = jsonDecode(decodedResponseBody);
        if(json.containsKey('result') && json.containsKey('data')){
          final result = json['result'];
          final resultCode = result['code'];
          CommonUtils.log('i', 'out full : \n$json');

          // CF-00000 : 성공, CF-03002 : 추가 인증 필요
          if(resultCode == 'CF-00000' || resultCode == 'CF-03002'){
            final resultData = json['data'];
            CommonUtils.log('i', 'out resultCode : $resultCode\nresultData : \n${resultData.toString()}');
            if (resultData is Map<String, dynamic>) {
              if(resultCode == 'CF-03002') {
                callback(true, true, resultData, null);
              } else {
                callback(true, false, resultData, null);
              }
            } else if (resultData is List<dynamic>) {
              if(resultCode == 'CF-03002') {
                callback(true, true, null, resultData);
              } else {
                callback(true, false, null, resultData);
              }

            }
          } else {
            CommonUtils.log('e', 'out resultCode error : $resultCode');
            callback(false, false, null, null);
          }
        }
      } else {
        CommonUtils.log('e', 'http error code : ${response.statusCode}');
        callback(false, false, null, null);
      }
    } catch (e) {
      CommonUtils.log('e', e.toString());
      callback(false, false, null, null);
    }
  }
  /// ------------------------------------------------------------------------------------------------------------------------ ///
}

/// CODEF API CONFIG ------------------------------------------------------------------------------------------------------------------------ ///
enum HostStatus {
  dev, prod
}

extension HostStatusExtension on HostStatus {
  String get value {
    switch (this) {
      case HostStatus.dev:
        return 'DEV';
      case HostStatus.prod:
        return 'PROD';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum Host {
  clientId, clientSecret, baseUrl,
}

extension HostExtension on Host {
  String get value {
    switch (this) {
      case Host.clientId:
        return 'ad589fbb-9ecb-4b90-8619-bed250751c2f';
      case Host.clientSecret:
        return '39f186a7-cdf8-4d3c-9c83-ce7bdabd1c30';
      case Host.baseUrl:
        return 'https://api.codef.io';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum HostDev {
  clientId, clientSecret, baseUrl,
}

extension HostDevExtension on HostDev {
  String get value {
    switch (this) {
      case HostDev.clientId:
        return '8d16c7c8-b60a-44d5-a30d-2c2699fe10ff';
      case HostDev.clientSecret:
        return 'cf4c6ed3-1a2d-49c6-8cac-b901314452b5';
      case HostDev.baseUrl:
        return 'https://development.codef.io';
      default:
        throw Exception('Unknown host value');
    }
  }
}

enum Apis {
  addressApi1, addressApi2, carRegistration1Api, carRegistration2Api, bankruptApi1, bankruptApi2,
  residentRegistrationAbstract, residentRegistrationCopy
}

extension ApisExtension on Apis {
  String get value {
    switch (this) {
      case Apis.addressApi1:
        return '/v1/kr/etc/ld/kb/serial-number';
      case Apis.addressApi2:
        return '/v1/kr/etc/ld/kb/market-price-information';
      case Apis.carRegistration1Api:
        return '/v1/kr/public/mw/car-registration-a/issuance';
      case Apis.carRegistration2Api:
        return '/v1/kr/public/mw/car-registration-b/issuance';
      case Apis.bankruptApi1:
        return '/v1/kr/public/ck/rehab-bankruptcy/list';
      case Apis.bankruptApi2:
        return '/v1/kr/public/ck/scourt-events/search';
      case Apis.residentRegistrationAbstract:
        return '/v1/kr/public/mw/resident-registration-abstract/issuance';
      case Apis.residentRegistrationCopy:
        return '/v1/kr/public/mw/resident-registration-copy/issuance';
      default:
        throw Exception('Unknown host value');
    }
  }
}
/// ------------------------------------------------------------------------------------------------------------------------ ///