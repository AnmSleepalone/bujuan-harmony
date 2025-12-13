import 'package:bujuan_music/pages/play/provider.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

/// 评论Sheet
void showCommentSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
          ),
          child: Column(
            children: [
              // 顶部指示条
              Container(
                margin: EdgeInsets.only(top: 8.w),
                width: 40.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              // Header
              Consumer(builder: (context, ref, child) {
                final commentsAsync = ref.watch(currentSongCommentsProvider);
                final total = commentsAsync.value?.total ?? 0;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                  child: Row(
                    children: [
                      Text('评论', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('共$total条', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  ),
                );
              }),
              Divider(height: 1.w),
              // 评论列表
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final commentsAsync = ref.watch(currentSongCommentsProvider);

                  return commentsAsync.when(
                    data: (commentData) {
                      if (commentData == null) {
                        return _buildEmptyState('暂无评论');
                      }

                      final allComments = <CommentItem>[
                        ...?commentData.hotComments,
                        ...?commentData.comments,
                      ];

                      if (allComments.isEmpty) {
                        return _buildEmptyState('暂无评论，快来抢沙发');
                      }

                      return ListView.separated(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                        itemCount: allComments.length,
                        separatorBuilder: (_, __) => Divider(height: 1.w),
                        itemBuilder: (context, index) {
                          final comment = allComments[index];
                          final isHot = commentData.hotComments != null &&
                              index < commentData.hotComments!.length;

                          return _CommentItemWidget(
                            comment: comment,
                            isHot: isHot,
                          );
                        },
                      );
                    },
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16.w),
                          Text('加载中...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    error: (_, __) => _buildEmptyState('加载失败，请重试'),
                  );
                }),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// 评论列表项
class _CommentItemWidget extends StatelessWidget {
  final CommentItem comment;
  final bool isHot;

  const _CommentItemWidget({
    required this.comment,
    this.isHot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 用户头像
          CachedImage(
            imageUrl: comment.user?.avatarUrl ?? '',
            width: 36.w,
            height: 36.w,
            borderRadius: 18.w,
            pWidth: 100,
            pHeight: 100,
          ),
          SizedBox(width: 12.w),
          // 评论内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 昵称和时间
                Row(
                  children: [
                    Text(
                      comment.user?.nickname ?? '未知用户',
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    ),
                    if (isHot) ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                        decoration: BoxDecoration(
                          color: Color(0XFF1ED760).withAlpha(30),
                          borderRadius: BorderRadius.circular(4.w),
                        ),
                        child: Text(
                          '热门',
                          style: TextStyle(fontSize: 10.sp, color: Color(0XFF1ED760)),
                        ),
                      ),
                    ],
                    Spacer(),
                    Text(
                      _formatCommentTime(comment.time ?? 0),
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 6.w),
                // 评论内容
                Text(
                  comment.content ?? '',
                  style: TextStyle(fontSize: 14.sp, height: 1.4),
                ),
                SizedBox(height: 8.w),
                // 点赞数
                Row(
                  children: [
                    Icon(HugeIcons.strokeRoundedThumbsUp, size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      '${comment.likedCount ?? 0}',
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  ],
                ),
                // 回复列表
                if (comment.beReplied != null && comment.beReplied!.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 8.w),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha(30),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comment.beReplied!.map((reply) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4.w),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 13.sp, color: Theme.of(context).textTheme.bodyMedium?.color),
                              children: [
                                TextSpan(
                                  text: '@${reply.user?.nickname ?? ""}：',
                                  style: TextStyle(color: Color(0XFF1ED760)),
                                ),
                                TextSpan(text: reply.content ?? ''),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 空状态组件
Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(HugeIcons.strokeRoundedComment02, size: 64.sp, color: Colors.grey),
        SizedBox(height: 16.w),
        Text(message, style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
      ],
    ),
  );
}

/// 格式化评论时间
String _formatCommentTime(int timestamp) {
  if (timestamp == 0) return '';

  final now = DateTime.now();
  final commentTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final diff = now.difference(commentTime);

  if (diff.inMinutes < 1) return '刚刚';
  if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
  if (diff.inDays < 1) return '${diff.inHours}小时前';
  if (diff.inDays < 30) return '${diff.inDays}天前';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}个月前';
  return '${(diff.inDays / 365).floor()}年前';
}
