import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/pages/home/provider.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../widgets/loading.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('每日推荐'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final album = ref.watch(recommendSongsProvider);
          return album.when(
            data: (today) {
              // 如果没有推荐歌曲，显示空状态
              if (today.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(HugeIcons.strokeRoundedMusicNote01, size: 64.w, color: Colors.grey),
                      SizedBox(height: 16.w),
                      Text(
                        '暂无推荐歌曲',
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) => index == today.length
                    ? DynamicPadding(hasBottom: false)
                    : MediaItemWidget(
                        mediaItem: today[index],
                        onTap: () => BujuanMusicHandler().updateQueue(today, index: index),
                      ),
                itemCount: today.length + 1,
              );
            },
            loading: () => const Center(child: LoadingIndicator()),
            error: (error, stackTrace) {
              print('[TodayPage] Error loading recommendations: $error');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64.w, color: Colors.red),
                    SizedBox(height: 16.w),
                    Text(
                      '加载失败',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                    SizedBox(height: 8.w),
                    Text(
                      error.toString(),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
