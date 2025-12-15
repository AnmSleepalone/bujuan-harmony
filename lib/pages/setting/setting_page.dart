import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hugeicons/hugeicons.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DesktopSetting();
  }
}

class DesktopSetting extends ConsumerWidget {
  const DesktopSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var themeMode = ref.watch(themeModeNotifierProvider);
    var homeStyle = ref.watch(homeStyleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('设置', style: TextStyle(fontSize: 18.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 外观设置部分
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              child: Text(
                '外观',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),

            // 主题模式切换
            ListTile(
              leading: Icon(
                themeMode == ThemeMode.dark
                    ? HugeIcons.strokeRoundedMoon01
                    : themeMode == ThemeMode.light
                        ? HugeIcons.strokeRoundedSunCloud02
                        : HugeIcons.strokeRoundedSmartPhone01,
                size: 24.sp,
              ),
              title: Text('主题模式'),
              subtitle: Text(
                themeMode == ThemeMode.dark
                    ? '深色模式'
                    : themeMode == ThemeMode.light
                        ? '浅色模式'
                        : '跟随系统',
              ),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('选择主题模式'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile<ThemeMode>(
                          title: Text('浅色模式'),
                          value: ThemeMode.light,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(themeModeNotifierProvider.notifier).setTheme(value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text('深色模式'),
                          value: ThemeMode.dark,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(themeModeNotifierProvider.notifier).setTheme(value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        RadioListTile<ThemeMode>(
                          title: Text('跟随系统'),
                          value: ThemeMode.system,
                          groupValue: themeMode,
                          onChanged: (value) {
                            if (value != null) {
                              ref.read(themeModeNotifierProvider.notifier).setTheme(value);
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            Divider(height: 1.w),

            // 首页样式切换
            ListTile(
              leading: Icon(
                homeStyle == HomeStyleType.draw
                    ? HugeIcons.strokeRoundedSidebarLeft
                    : HugeIcons.strokeRoundedMenuSquare,
                size: 24.sp,
              ),
              title: Text('首页布局'),
              subtitle: Text(homeStyle == HomeStyleType.draw ? '侧边栏模式' : '底部栏模式'),
              onTap: () {
                ref.read(homeStyleProvider.notifier).setIndex(
                    homeStyle == HomeStyleType.draw ? HomeStyleType.bottomBar : HomeStyleType.draw);
                context.replace(AppRouter.home);
              },
              trailing: Icon(Icons.chevron_right),
            ),

            SizedBox(height: 16.w),

            // 账号设置部分
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              child: Text(
                '账号',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),

            // 退出登录
            Consumer(builder: (context, ref, child) {
              return ListTile(
                leading: Icon(HugeIcons.strokeRoundedLogout01, size: 24.sp, color: Colors.red),
                title: Text('退出登录', style: TextStyle(color: Colors.red)),
                onTap: () async {
                  // 显示确认对话框
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('确认退出'),
                      content: Text('确定要退出登录吗？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('取消'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('确定', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    // 执行退出登录
                    await BujuanMusicManager().usc.onLogout();
                    // 清除 Hive 中的用户信息
                    GetIt.I<Box>().delete(AppConfig.userInfoKey);
                    if (context.mounted) {
                      context.replace(AppRouter.login);
                    }
                  }
                },
              );
            }),

            SizedBox(height: 16.w),

            // 关于部分
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
              child: Text(
                '关于',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ),

            // 版本信息
            ListTile(
              leading: Icon(HugeIcons.strokeRoundedInformationCircle, size: 24.sp),
              title: Text('版本信息'),
              subtitle: Text('倦了 v1.0.0'),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                // 可以跳转到关于页面或显示对话框
                showAboutDialog(
                  context: context,
                  applicationName: '倦了',
                  applicationVersion: '1.0.0',
                  applicationLegalese: '😀 2025 倦了',
                  children: [
                    SizedBox(height: 16.w),
                    Text('基于开源项目bujuan_music,一款简洁优雅的音乐播放应用'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
