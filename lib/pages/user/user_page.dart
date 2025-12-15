import 'package:bujuan_music/pages/user/provider.dart';
import 'package:bujuan_music/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../router/app_router.dart';
import '../../utils/adaptive_screen_utils.dart';
import '../../widgets/cache_image.dart';
import '../../widgets/loading.dart';
import '../main/phone/widgets.dart';

class UserPage extends ConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final album = ref.watch(newAlbumProvider);
    bool desktop = medium(context) || expanded(context);
    return Scaffold(
      appBar: desktop ? null : mainAppBar(context),
      body: album.when(
        data: (playlist) =>
            desktop ? DesktopUser(playlist: playlist) : MobileUser(playlist: playlist),
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, __) => const Center(child: Text('Oops, something unexpected happened')),
      ),
    );
  }
}

class MobileUser extends StatelessWidget {
  final UserData playlist;

  const MobileUser({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    // 检查是否有用户信息
    final hasUserInfo = playlist.userInfo.nickname?.isNotEmpty ?? false;
    final playlistItems = playlist.likeList.playlist ?? [];

    // 如果没有用户信息，显示未登录提示
    if (!hasUserInfo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 64.w, color: Colors.grey),
            SizedBox(height: 16.w),
            Text(
              '请先登录',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.w),
            ElevatedButton(
              onPressed: () => context.push(AppRouter.login),
              child: Text('去登录'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.w),
              child: Column(
                children: [
                  CachedImage(
                    imageUrl: playlist.userInfo.avatarUrl ?? "",
                    width: 60.w,
                    height: 60.w,
                    pHeight: 150,
                    pWidth: 150,
                    borderRadius: 30.w,
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    playlist.userInfo.nickname ?? "未知用户",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // 快捷入口按钮
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _QuickEntryButton(
                    icon: HugeIcons.strokeRoundedCalendar03,
                    label: '每日推荐',
                    onTap: () => context.push(AppRouter.today),
                  ),
                  _QuickEntryButton(
                    icon: HugeIcons.strokeRoundedCloud,
                    label: '云盘',
                    onTap: () => context.push(AppRouter.cloud),
                  ),
                  _QuickEntryButton(
                    icon: HugeIcons.strokeRoundedRadio01,
                    label: '私人FM',
                    onTap: () => context.push(AppRouter.fm),
                  ),
                ],
              ),
            ),
          ),
          // 如果播放列表为空，显示空状态提示
          if (playlistItems.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note_outlined, size: 64.w, color: Colors.grey),
                    SizedBox(height: 16.w),
                    Text(
                      '暂无歌单',
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverGrid.builder(
              itemCount: playlistItems.length,
              itemBuilder: (context, index) {
                final song = playlistItems[index];
                return GestureDetector(
                  child: Column(
                    children: [
                      CachedImage(
                        imageUrl: song.coverImgUrl?.toString() ?? '',
                        width: 108.w,
                        height: 108.w,
                        borderRadius: 0.w,
                        pHeight: 200,
                        pWidth: 200,
                      ),
                      Text(
                        song.name ?? '',
                        style: TextStyle(fontSize: 14.sp, overflow: TextOverflow.ellipsis),
                        maxLines: 1,
                      )
                    ],
                  ),
                  onTap: () => context.push(AppRouter.playlist, extra: song.id),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: .8,
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 15.w),
            ),
          SliverToBoxAdapter(
            child: DynamicPadding(),
          )
        ],
      ),
    );
  }
}

class DesktopUser extends StatelessWidget {
  final UserData playlist;

  const DesktopUser({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    // 检查是否有用户信息
    final hasUserInfo = playlist.userInfo.nickname?.isNotEmpty ?? false;
    final playlistItems = playlist.likeList.playlist ?? [];

    // 如果没有用户信息，显示未登录提示
    if (!hasUserInfo) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80.w, color: Colors.grey),
            SizedBox(height: 20.w),
            Text(
              '请先登录',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
            SizedBox(height: 20.w),
            ElevatedButton(
              onPressed: () => context.push(AppRouter.login),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                child: Text('去登录'),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
          child: SizedBox(
            width: 260.w,
            child: Column(
              children: [
                CachedImage(
                  imageUrl: playlist.userInfo.avatarUrl ?? '',
                  width: 200.w,
                  height: 200.w,
                  borderRadius: 100.w,
                ),
                SizedBox(height: 15.w),
                Text(
                  playlist.userInfo.nickname ?? '',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10.w),
                Text(
                  playlist.userInfo.signature ?? '',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: playlistItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.music_note_outlined, size: 80.w, color: Colors.grey),
                      SizedBox(height: 20.w),
                      Text(
                        '暂无歌单',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.only(bottom: 45.w),
                  itemCount: playlistItems.length,
                  itemBuilder: (context, index) {
                    final song = playlistItems[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.w),
                      leading: CachedImage(
                        imageUrl: song.coverImgUrl?.toString() ?? '',
                        width: 48.w,
                        height: 48.w,
                        borderRadius: 24.w,
                      ),
                      title: Text(song.name ?? ''),
                      subtitle: Text('${song.trackCount ?? 0} songs'),
                      onTap: () => context.push(AppRouter.playlist, extra: song.id),
                    );
                  },
                ),
        )
      ],
    );
  }
}

/// 快捷入口按钮组件
class _QuickEntryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickEntryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(vertical: 12.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28.w),
            SizedBox(height: 6.w),
            Text(
              label,
              style: TextStyle(fontSize: 12.sp),
            ),
          ],
        ),
      ),
    );
  }
}
