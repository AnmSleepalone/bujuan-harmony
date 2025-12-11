import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/widgets/rive_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce/hive.dart';
import 'package:hugeicons/hugeicons.dart';
// import 'package:rive_native/rive_native.dart' as rive;

class BackgroundSettingDialog extends StatefulWidget {
  const BackgroundSettingDialog({super.key});

  @override
  State<BackgroundSettingDialog> createState() => _BackgroundSettingDialogState();
}

class _BackgroundSettingDialogState extends State<BackgroundSettingDialog> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: SizedBox(
        width: 600.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400.w,
              child: PageView(
                controller: pageController,
                children: [
                  BackgroundEnums.happy,
                  BackgroundEnums.dragon,
                  BackgroundEnums.littleBoy,
                  BackgroundEnums.boy,
                  BackgroundEnums.girl,
                ]
                    .map((background) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () => pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.decelerate),
                                    icon: Icon(
                                      HugeIcons.strokeRoundedArrowLeft01,
                                      size: 32.sp,
                                    )),
                                SizedBox(width: 30.w),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150.w),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    width: 300.w,
                                    height: 300.w,
                                    // child: RivePlayer(
                                    //   asset: background.background,
                                    //   fit: rive.Fit.cover,
                                    // ),
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                IconButton(
                                    onPressed: () => pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.decelerate),
                                    icon: Icon(
                                      HugeIcons.strokeRoundedArrowRight01,
                                      size: 32.sp,
                                    )),
                              ],
                            ),
                            SizedBox(height: 20.w),
                            Consumer(builder: (c, ref, child) {
                              var watch = ref.watch(backgroundModeNotifierProvider);
                              var backgroundModeNotifier =
                                  ref.read(backgroundModeNotifierProvider.notifier);
                              var themeModeNotifier = ref.read(themeModeNotifierProvider.notifier);
                              return GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 40.w),
                                  decoration: BoxDecoration(
                                      color: Color(0XFF1ED760)
                                          .withAlpha(watch == background.background ? 160 : 100),
                                      borderRadius: BorderRadius.circular(30.w)),
                                  child: Text(
                                    watch == background.background ? 'Selected' : 'Click to select',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onTap: () {
                                  backgroundModeNotifier.changeBackground(background.background);
                                  themeModeNotifier.setTheme(background.themeMode);
                                  var isDark = background.themeMode == ThemeMode.dark;
                                  GetIt.I<Box>().put(AppConfig.isDarkTheme, isDark);
                                  GetIt.I<Box>()
                                      .put(AppConfig.backgroundPath, background.background);
                                },
                              );
                            })
                          ],
                        ))
                    .toList(),
              ),
            ),
            // IconButton(
            //     onPressed: () => context.pop(),
            //     icon: Icon(
            //       HugeIcons.strokeRoundedCancelCircleHalfDot,
            //       size: 30.sp,
            //     )),
          ],
        ),
      ),
    );
  }
}

enum BackgroundEnums {
  happy(AppImages.happy, ThemeMode.light),
  dragon(AppImages.dagger, ThemeMode.light),
  girl(AppImages.girl, ThemeMode.dark),
  littleBoy(AppImages.littleBoy, ThemeMode.dark),
  boy(AppImages.boy, ThemeMode.light);

  final String background;
  final ThemeMode themeMode;

  const BackgroundEnums(this.background, this.themeMode);
}
