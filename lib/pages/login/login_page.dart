import 'dart:async';
import 'dart:convert';

import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:pinput/pinput.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneController = TextEditingController();
  Timer? _qrCheckTimer;

  final defaultPinTheme = PinTheme(
    width: 56.w,
    height: 56.w,
    textStyle: TextStyle(
        fontSize: 18.sp, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20.w),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(AppImages.logo, width: 120.w, height: 120.w),
            SizedBox(height: 20.w),
            Text(
              '倦了',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 60.w),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.symmetric(vertical: 2.w),
              decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(15), borderRadius: BorderRadius.circular(30.w)),
              child: TextField(
                controller: phoneController,
                cursorColor: Color(0XFF1ED760),
                style: TextStyle(fontSize: 18.sp),
                decoration: InputDecoration(
                    hintText: '手机号登录暂不可用',
                    hintStyle: TextStyle(fontSize: 18.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w)),
              ),
            ),
            SizedBox(height: 30.w),
            // SMS 登录暂时禁用
            // ElevatedButton(
            //   onPressed: () => showCodeBottomSheet(),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Color(0XFF1ED760),
            //     foregroundColor: Colors.white,
            //     elevation: 0,
            //     padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.w),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(30.w), // 圆角
            //     ),
            //     textStyle: const TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            //   child: Text('Get SMS verification code'),
            // ),
            // SizedBox(height: 60.w),
            ElevatedButton(
              onPressed: () => showQrCodeBottomSheet(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0XFF1ED760),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(HugeIcons.strokeRoundedQrCode),
                  SizedBox(width: 10.w),
                  Text('二维码登录'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showCodeBottomSheet() async {
    if (phoneController.text.isEmpty) {
      print('Phone number is empty');
      return;
    }

    print('Sending SMS code to: ${phoneController.text}');

    try {
      var boolEntity = await BujuanMusicManager().captchaSend(phoneController.text);
      print('SMS API response: $boolEntity');

      if (boolEntity != null && boolEntity.code == 200 && mounted) {
        print('Showing verification bottom sheet');
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30.w),
                Text('Verification',
                    style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 30.w),
                Text('Enter the code sent to the number', style: TextStyle(fontSize: 16.sp)),
                SizedBox(height: 30.w),
                Text(phoneController.text,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 60.w),
                Pinput(
                  autofocus: true,
                  defaultPinTheme: defaultPinTheme,
                  onCompleted: (v) {
                    print('Pinput onCompleted triggered with value: $v');
                    goToHome(v);
                  },
                ),
                SizedBox(height: 30.w),
                Text(
                  "Didn't receive code?",
                  style: TextStyle(color: Color(0XFF1ED760)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    showCodeBottomSheet();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.w),
                    child: Text('Resend',
                        style: TextStyle(
                          color: Color(0XFF1ED760),
                          decoration: TextDecoration.underline,
                        )),
                  ),
                )
              ],
            );
          },
          isScrollControlled: true,
          useSafeArea: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w))));
      } else {
        print('SMS API returned error, cannot show bottom sheet');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('发送失败'),
              content: Text('发送验证码失败，请稍后重试'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('确定'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('SMS sending error: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('发送异常'),
            content: Text('发送验证码时发生异常，请检查网络连接'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  void goToHome(String code) async {
    print('goToHome called with code: $code and phone: ${phoneController.text}');

    try {
      var verifyEntity = await BujuanMusicManager()
          .captchaVerify(phoneController.text, code);

      print('Verification API response: ${verifyEntity?.toJson()}');

      if (verifyEntity != null && verifyEntity.code == 200) {
        phoneController.text = '';

        // 保存用户信息
        bool saved = await _saveUserInfoAfterLogin();

        if (mounted) {
          if (saved) {
            print('Verification success, navigating to home');
            context.replace(AppRouter.home);
          } else {
            // 保存失败但验证成功,仍然跳转(重启后可恢复)
            print('User info save failed, but proceeding to home');
            context.replace(AppRouter.home);
          }
        }
      } else {
        final errorCode = verifyEntity?.code;
        print('Verification failed: code=$errorCode');

        String errorMessage;
        switch (errorCode) {
          case 400:
            errorMessage = '请求错误，请检查输入信息';
            break;
          case 503:
            errorMessage = '验证码错误或已过期';
            break;
          default:
            errorMessage = '验证失败 (错误码: $errorCode)';
        }

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('验证失败'),
              content: Text(errorMessage),
              actions: [
                if (errorCode == 503) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // 关闭对话框
                      Navigator.pop(context); // 关闭底部弹窗
                      showCodeBottomSheet(); // 重新获取验证码
                    },
                    child: Text('重新获取'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消'),
                  ),
                ] else
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('确定'),
                  ),
              ],
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('Verification error: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('验证异常'),
            content: Text('验证时发生异常，请检查网络连接后重试'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  void showQrCodeBottomSheet() async {
    print('Starting QR code login flow');

    try {
      // 获取二维码key
      var qrKeyEntity = await BujuanMusicManager().loginQrCodeKey();
      print('QR key response: ${qrKeyEntity?.toJson()}');

      if (qrKeyEntity == null || qrKeyEntity.unikey == null || qrKeyEntity.unikey!.isEmpty) {
        print('Failed to get QR key');
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('获取二维码失败'),
              content: Text('无法生成二维码,请稍后重试'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('确定'),
                ),
              ],
            ),
          );
        }
        return;
      }

      final qrKey = qrKeyEntity.unikey!;
      final qrCodeUrl = BujuanMusicManager().loginQrCodeUrl(qrKey);
      print('QR code URL: $qrCodeUrl');

      if (mounted) {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('扫码登录',
                          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600)),
                      SizedBox(height: 20.w),
                      Text('请使用网易云音乐APP扫描二维码',
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
                      SizedBox(height: 30.w),
                      // 二维码
                      Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.w),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrCodeUrl,
                          version: QrVersions.auto,
                          size: 200.w,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 30.w),
                    ],
                  ),
                );
              },
            );
          },
          isScrollControlled: true,
          useSafeArea: true,
          enableDrag: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.w), topRight: Radius.circular(20.w))),
        ).then((_) {
          // 当底部弹窗关闭时,取消轮询
          _qrCheckTimer?.cancel();
          _qrCheckTimer = null;
          print('QR code bottom sheet closed, timer cancelled');
        });

        // 开始轮询检查二维码状态
        startQrCodePolling(qrKey);
      }
    } catch (e, stackTrace) {
      print('QR code generation error: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('二维码生成异常'),
            content: Text('生成二维码时发生异常,请检查网络连接'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('确定'),
              ),
            ],
          ),
        );
      }
    }
  }

  void startQrCodePolling(String qrKey) {
    print('Starting QR code polling with key: $qrKey');

    // 每3秒检查一次二维码状态
    _qrCheckTimer = Timer.periodic(Duration(seconds: 3), (timer) async {
      try {
        print('Checking QR code status...');
        var checkResult = await BujuanMusicManager().loginQrCodeCheck(qrKey);
        print('QR check result: ${checkResult?.toJson()}');

        if (checkResult != null) {
          final code = checkResult.code;

          // 800: 二维码已过期
          // 801: 等待扫码
          // 802: 待确认
          // 803: 授权登录成功
          switch (code) {
            case 800:
              print('QR code expired');
              timer.cancel();
              _qrCheckTimer = null;
              if (mounted) {
                Navigator.pop(context); // 关闭底部弹窗
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('二维码已过期'),
                    content: Text('请重新获取二维码'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('确定'),
                      ),
                    ],
                  ),
                );
              }
              break;

            case 803:
              print('QR code login success');
              timer.cancel();
              _qrCheckTimer = null;

              // 保存用户信息
              bool saved = await _saveUserInfoAfterLogin();

              if (mounted) {
                Navigator.pop(context); // 关闭底部弹窗
                if (saved) {
                  print('Navigating to home after QR login success');
                  context.replace(AppRouter.home);
                } else {
                  // 保存失败,提示用户
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('提示'),
                      content: Text('登录成功,但获取用户信息失败,请重启应用'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            context.replace(AppRouter.home);
                          },
                          child: Text('确定'),
                        ),
                      ],
                    ),
                  );
                }
              }
              break;

            case 802:
              print('QR code scanned, waiting for confirmation');
              break;

            case 801:
              print('Waiting for QR code scan');
              break;

            default:
              print('Unknown QR code status: $code');
          }
        }
      } catch (e) {
        print('Error checking QR code: $e');
        // 不中断轮询,继续检查
      }
    });
  }

  /// 登录成功后保存用户信息
  /// 返回值表示是否成功保存
  Future<bool> _saveUserInfoAfterLogin() async {
    try {
      print('Fetching user info after login...');
      var userInfo = await BujuanMusicManager().loginAccountInfo();

      if (userInfo != null && userInfo.account != null) {
        // 保存到Hive
        GetIt.I<Box>().put(
          AppConfig.userInfoKey,
          jsonEncode(userInfo.profile?.toJson()),
        );
        print('User info saved successfully');
        return true;
      } else {
        print('Failed to get user info: invalid response');
        return false;
      }
    } catch (e, stackTrace) {
      print('Error saving user info: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    _qrCheckTimer?.cancel();
    super.dispose();
  }
}
