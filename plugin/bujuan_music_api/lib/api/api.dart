class Api {
  //用户部分
  //手机号登录
  static const String loginCellPhone = '/weapi/w/login/cellphone';

  //邮箱号登录
  static const String loginCellEmail = '';

  //发送验证码
  static const String sendSmsCode = '/weapi/sms/captcha/sent';

  //验证验证码
  static const String verifySmsCode = '/weapi/sms/captcha/verify';

  //用户信息
  static const String userInfo = '/weapi/nuser/account/get';

  //生成二维码key
  static const String qrCodeKey = '/weapi/login/qrcode/unikey';

  //检测二维码
  static const String checkQrCode = '/weapi/login/qrcode/client/login';

  //退出登录
  static const String logout = '/weapi/logout';

  //用户歌单
  static const String userPlaylist = '/weapi/user/playlist';

  //用户喜欢列表
  static const String userLikeList = '/weapi/song/like/get';

  ///推荐部分
  //每日推荐歌曲
  static const String recommendSongs = '/weapi/v3/discovery/recommend/songs';

  //每日推荐歌单
  static const String recommendResource = '/weapi/v1/discovery/recommend/resource';

  //对推荐不感兴趣
  static const String recommendDislike = '/weapi/v2/discovery/recommend/dislike';

  ///top系列
  //热门歌手
  static const String topArtist = '/weapi/artist/top';

  ///album
  //最新专辑
  static const String newAlbum = '/weapi/album/new';

  //专辑内容
  static const String albumInfo = '/weapi/v1/album';

  //歌手专辑
  static const String artistAlbum = '/weapi/artist/albums';

  ///playlist
  //歌单分类
  static const String playlistCatalogue = '/weapi/playlist/catalogue';

  //创建歌单
  static const String createPlaylist = '/weapi/playlist/create';

  //删除歌单
  static const String removePlaylist = '/weapi/playlist/remove';

  //更新歌单描述
  static const String updatePlaylistDesc = '/weapi/playlist/desc/update';

  //歌单详情
  static const String playlistDetail = '/weapi/v6/playlist/detail';

  //歌单动态详情
  static const String playlistDetailDynamic = '/weapi/playlist/detail/dynamic';

  //相关歌单推荐
  static const String recommendByPlaylist = '/weapi/playlist/detail/rcmd/get';

  //精品歌单tags
  static const String highQualityTags = '/weapi/playlist/highquality/tags';

  /// song
  //新歌速递
  static const String newSongs = '/weapi/v1/discovery/new/songs';
  //歌曲地址
  static const String songUrl = '/weapi/song/enhance/player/url/v1';
  //歌曲详情
  static const String songDetail = '/weapi/v3/song/detail';
  //检查歌曲是否喜欢
  static const String songLikeCheck = '/weapi/song/like/check';
  //歌曲音质详情
  static const String songQualityDetail = '/weapi/song/music/detail/get';
  //歌曲被喜欢数量
  static const String songLikeCount = '/weapi/song/red/count';

  /// mv
  //Mv播放地址
  static const String mvUrl = '/weapi/song/enhance/play/mv/url';

}
