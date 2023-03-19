import 'dart:async';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart' as link;

import '../store/theme.dart';
import '../components/popup.dart';
import '../utils/functions.dart';
import '../utils/identicon.dart';
import '../utils/screen.dart';
import 'name_with_emoji.dart';

class UserAvatar extends StatelessWidget {
  final String avatarSrc;
  final bool online;
  final double avatarWidth;
  final Color? bg;
  final Color? color;
  const UserAvatar(this.avatarSrc, this.online, this.avatarWidth, {Key? key, this.bg, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imgw = (avatarWidth * 0.7).toInt();
    var imgbg = color ?? ConstTheme.centerChannelColor;
    var boxBg = bg ?? ConstTheme.centerChannelColor.withOpacity(0.1);
    var img = Identicon(fg: [imgbg.red, imgbg.green, imgbg.blue]).generate(avatarSrc, size: 50);
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.w), color: boxBg),
      padding: EdgeInsets.all((avatarWidth - imgw) / 2),
      alignment: Alignment.topLeft,
      child: Image.memory(
        img,
        width: imgw.toDouble(),
        height: imgw.toDouble(),
        fit: BoxFit.contain,
      ),
    );
  }
}

class UserAvatarWithPop extends StatefulWidget {
  final link.User user;
  final bool online;
  final double avatarWidth;
  final Color? bg;
  final Color? color;

  const UserAvatarWithPop(this.user, this.online, this.avatarWidth, {Key? key, this.bg, this.color}) : super(key: key);

  @override
  State<UserAvatarWithPop> createState() => _UserAvatarWithPopState();
}

class _UserAvatarWithPopState extends State<UserAvatarWithPop> {
  final BasePopupMenuController menuController = BasePopupMenuController();

  @override
  Widget build(BuildContext context) {
    var imgw = (widget.avatarWidth * 0.7).toInt();
    var imgbg = widget.color ?? ConstTheme.centerChannelColor;
    var boxBg = widget.bg ?? ConstTheme.centerChannelColor.withOpacity(0.1);
    var img = Identicon(fg: [imgbg.red, imgbg.green, imgbg.blue]).generate(getUserShortId(widget.user.id), size: 50);
    return BasePopupMenu(
      verticalMargin: 5.w,
      horizontalMargin: -1.w,
      showArrow: false,
      controller: menuController,
      position: PreferredPosition.topLeft,
      pressType: PressType.mouseHover,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.w), color: boxBg),
        padding: EdgeInsets.all((widget.avatarWidth - imgw) / 2),
        alignment: Alignment.topLeft,
        child: Image.memory(
          img,
          width: imgw.toDouble(),
          height: imgw.toDouble(),
          fit: BoxFit.contain,
        ),
      ),
      menuBuilder: () => Container(
        width: 320.w,
        height: 170.w,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: ConstTheme.centerChannelBg,
          borderRadius: BorderRadius.all(Radius.circular(5.w)),
          border: Border.all(color: ConstTheme.centerChannelColor.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w, top: 2.w, bottom: 2.w),
                  child: UserAvatar(
                    getUserShortId(widget.user.id),
                    true,
                    65.w,
                    bg: ConstTheme.sidebarText.withOpacity(0.1),
                    color: ConstTheme.sidebarText,
                  ),
                ),
                WidgetUserNameEmoji(getUserShortName(widget.user.displayName ?? "-"), null),
              ],
            ),
            SizedBox(height: 15.w),
            Divider(
              height: 1.w,
              color: ConstTheme.centerChannelColor.withOpacity(0.1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.w),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.chat, size: 24.w, color: ConstTheme.centerChannelColor.withOpacity(0.5)),
                    label: Text(
                      '消息',
                      style: TextStyle(fontSize: 14.w, color: ConstTheme.centerChannelColor.withOpacity(0.5)),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) => ConstTheme.centerChannelBg),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.w, horizontal: 30.w)),
                      side: MaterialStateProperty.all(BorderSide(
                        color: ConstTheme.centerChannelColor.withOpacity(0.5),
                        width: 1,
                      )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
