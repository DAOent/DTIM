import 'dart:async';
import 'package:dtim/application/store/app/org.dart';
import 'package:dtim/infra/pages/chat/channel_list.dart';
import 'package:dtim/infra/router/pop_router.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import 'package:dtim/application/store/app/webrtc.dart';
import 'package:dtim/domain/utils/screen/screen.dart';
import 'package:dtim/infra/components/components.dart';
import 'package:dtim/infra/components/popup.dart';
import 'package:dtim/domain/models/models.dart';
import 'package:dtim/application/store/app/app.dart';
import 'package:dtim/application/store/theme.dart';
// import 'package:dtim/domain/utils/webrtc/action.dart';
import 'chat_menu.dart';

class OrgViewPage extends StatefulWidget {
  final double width;
  const OrgViewPage({super.key, required this.width});

  @override
  State<OrgViewPage> createState() => _OrgViewPageState();
}

class _OrgViewPageState extends State<OrgViewPage> {
  late ExpandableController _controllerChannels;
  late ExpandableController _controllerUsers;

  final BasePopupMenuController menuController = BasePopupMenuController();
  final StreamController<bool> menuStreamController = StreamController<bool>();
  late AppCubit im;
  late AccountOrg org;
  bool showType = false;

  @override
  void initState() {
    super.initState();
    _controllerChannels = ExpandableController(initialExpanded: true);
    _controllerUsers = ExpandableController(initialExpanded: true);
    menuController.addListener(() {
      menuStreamController.add(menuController.menuIsShowing);
    });

    im = context.read<AppCubit>();
    org = im.currentState!.org;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerChannels.dispose();
    _controllerUsers.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // moveWindow(
        //   Row(
        //     children: [
        //       SizedBox(width: 14.w),
        //       BasePopupMenu(
        //         verticalMargin: -1.w,
        //         horizontalMargin: 5.w,
        //         showArrow: false,
        //         controller: menuController,
        //         pressType: PressType.singleClick,
        //         position: PreferredPosition.bottomLeft,
        //         child: StreamBuilder<bool>(
        //           stream: menuStreamController.stream,
        //           initialData: false,
        //           builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        //             final imc = context.watch<AppCubit>();
        //             return Container(
        //               height: 35.w,
        //               width: widget.width - 79.w,
        //               padding: EdgeInsets.only(left: 10.w, right: 7.w, top: 2.w, bottom: 2.w),
        //               decoration: BoxDecoration(
        //                 color: snapshot.data != null && snapshot.data!
        //                     ? constTheme.centerChannelColor.withOpacity(0.25)
        //                     : constTheme.centerChannelColor.withOpacity(0.1),
        //                 borderRadius: BorderRadius.all(Radius.circular(3.w)),
        //               ),
        //               child: Row(
        //                 children: [
        //                   Expanded(
        //                     child: Text(
        //                       imc.currentState!.org.nodeName ?? "",
        //                       softWrap: true,
        //                       overflow: TextOverflow.ellipsis,
        //                       style: TextStyle(
        //                         color: constTheme.centerChannelColor,
        //                         fontWeight: FontWeight.w800,
        //                         fontSize: 15.w,
        //                         height: 1.3,
        //                       ),
        //                     ),
        //                   ),
        //                   Icon(
        //                     Icons.keyboard_arrow_down_outlined,
        //                     color: constTheme.centerChannelColor,
        //                     size: 18.w,
        //                   ),
        //                 ],
        //               ),
        //             );
        //           },
        //         ),
        //         menuBuilder: () => orgMenuRender(menuController, widget.width - 30.w, im),
        //       ),
        //       SizedBox(width: 10.w),
        //       InkWell(
        //         onTap: () {
        //           var w = 0.8.sw > 700.w ? 700.w : 0.8.sw;
        //           showModelOrPage(context, "/search", width: w, top: 5.w);
        //         },
        //         child: Container(
        //           height: 35.w,
        //           width: 35.w,
        //           margin: EdgeInsets.only(left: 0.w, right: 15.w, top: 15.w, bottom: 15.w),
        //           // padding: EdgeInsets.only(left: 10.w),
        //           decoration: BoxDecoration(
        //             color: constTheme.centerChannelColor.withOpacity(0.1),
        //             borderRadius: BorderRadius.all(Radius.circular(3.w)),
        //           ),
        //           alignment: Alignment.center,
        //           child: Icon(AppIcons.search, size: 16.w, color: constTheme.centerChannelColor),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Divider(
        //   height: 1,
        //   color: constTheme.centerChannelColor.withOpacity(0.08),
        // ),
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Text(
            "Message",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14.w,
              color: constTheme.centerChannelColor,
            ),
          ),
        ),
        SingleChildScrollView(
          child: showType
              ? Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 8.w, top: 10.w, bottom: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              L10n.of(context)!.channel,
                              style: TextStyle(
                                color: constTheme.centerChannelColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.w,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                key: const Key("create_channel"),
                                onTap: () async {
                                  showModelOrPage(
                                    context,
                                    "/create_channel",
                                    width: 450.w,
                                    height: 300.w,
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 20.w,
                                  color: constTheme.centerChannelColor,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controllerChannels.toggle();
                                  });
                                },
                                child: Icon(
                                  _controllerChannels.expanded
                                      ? Icons.keyboard_arrow_down_outlined
                                      : Icons.keyboard_arrow_up_outlined,
                                  size: 25.w,
                                  color: constTheme.centerChannelColor.withAlpha(180),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ExpandablePanel(
                      key: const Key("room"),
                      controller: _controllerChannels,
                      collapsed: const SizedBox(),
                      expanded: const ChannelList(key: Key("ChannelList")),
                    ),
                    SizedBox(height: 5.w),
                    Divider(
                      height: 1,
                      color: constTheme.centerChannelColor.withOpacity(0.05),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 8.w, top: 10.w, bottom: 5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              L10n.of(context)!.directChat,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.w,
                                color: constTheme.centerChannelColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                key: const Key("create_private"),
                                onTap: () async {
                                  var w = 0.8.sw > 700.w ? 700.w : 0.8.sw;
                                  showModelOrPage(
                                    context,
                                    "/create_private",
                                    width: w,
                                    top: 5.w,
                                    height: 0.7.sh,
                                  );
                                },
                                child: Icon(
                                  Icons.add,
                                  size: 20.w,
                                  color: constTheme.centerChannelColor,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controllerUsers.toggle();
                                  });
                                },
                                child: Icon(
                                  _controllerUsers.expanded
                                      ? Icons.keyboard_arrow_down_outlined
                                      : Icons.keyboard_arrow_up_outlined,
                                  size: 25.w,
                                  color: constTheme.centerChannelColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ExpandablePanel(
                      key: const Key("droom"),
                      controller: _controllerUsers,
                      collapsed: const SizedBox(),
                      expanded: const DirectChats(key: Key("DirectChats")),
                    ),
                    SizedBox(height: 5.w),
                    Divider(
                      height: 1,
                      color: constTheme.centerChannelColor.withOpacity(0.05),
                    ),
                    BlocBuilder<WebRTCCubit, WebRTCState>(builder: (context, state) {
                      final voip = im.currentState!.webrtcTool!.voip;
                      print("voip.calls.length: ${voip.calls.length}");
                      print("voip.calls: ${voip.calls.toString()}");
                      print("voip.groupCalls: ${voip.groupCalls.toString()}");
                      List<Widget> calls = [];

                      if (voip.calls.isNotEmpty || voip.groupCalls.isNotEmpty) {
                        calls.add(Padding(
                          // decoration: BoxDecoration(
                          //   border: Border(bottom: BorderSide(color: constTheme.centerChannelColor.withOpacity(0.1))),
                          // ),
                          padding: EdgeInsets.only(left: 15.w, right: 8.w, top: 10.w, bottom: 5.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  L10n.of(context)!.mediaChats,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.w,
                                    color: constTheme.centerChannelColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ));
                      }

                      for (var k in voip.calls.keys) {
                        final call = voip.calls[k]!;
                        if (call.isGroupCall) continue;
                        calls.add(
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: constTheme.sidebarBg,
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide.none,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              im.currentState!.webrtcTool!.addCallingPopup(call.callId, call);
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.w, right: 0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 2.w),
                                  Icon(Icons.headphones_rounded, size: 16.w, color: constTheme.centerChannelColor),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: Text(
                                      call.room.getLocalizedDisplayname(),
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: constTheme.centerChannelColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => im.currentState!.webrtcTool!.addCallingPopup(call.callId, call),
                                    tooltip: 'open window',
                                    icon: Icon(
                                      AppIcons.fangda,
                                      size: 16.w,
                                      color: constTheme.centerChannelColor,
                                    ),
                                  ),
                                ],
                              ),
                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       for (var i = 0; i < actions.length; i++)
                              //         Container(
                              //           decoration: BoxDecoration(
                              //               borderRadius: BorderRadius.all(Radius.circular(8.w)),
                              //               color: actions[i].backgroundColor),
                              //           margin: EdgeInsets.only(right: i != actions.length - 1 ? 5.w : 0),
                              //           child: IconButton(
                              //             iconSize: 18.w,
                              //             constraints: BoxConstraints(
                              //                 minWidth: 30.w, maxWidth: 30.w, minHeight: 30.w, maxHeight: 30.w),
                              //             style: IconButton.styleFrom(
                              //               shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.circular(8.w),
                              //               ),
                              //             ),
                              //             padding: EdgeInsets.zero,
                              //             icon: actions[i].child,
                              //             color: Colors.white,
                              //             onPressed: () async {
                              //               actions[i].onPressed();
                              //             },
                              //           ),
                              //         ),
                              //     ],
                              //   ),
                            ),
                          ),
                        );
                      }

                      for (var k in voip.groupCalls.keys) {
                        final call = voip.groupCalls[k]!;
                        if (k.callId.contains(":")) continue;
                        // final callActions = CallAction(call);
                        // final actions = callActions.buildActionButtons();
                        calls.add(
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: constTheme.sidebarBg,
                              surfaceTintColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                                side: BorderSide.none,
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              final org = context.read<OrgCubit>();
                              org.setChannelId("meeting||$k");
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 12.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 2.w),
                                  Icon(AppIcons.meeting_board, size: 19.w, color: constTheme.centerChannelColor),
                                  SizedBox(width: 7.w),
                                  Expanded(
                                    child: Text(
                                      call.room.getLocalizedDisplayname(),
                                      style: TextStyle(
                                        fontSize: 14.w,
                                        color: constTheme.centerChannelColor,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // im.currentState!.webrtcTool!.addCallingPopup(call.callId, call)
                                    },
                                    tooltip: 'open window',
                                    icon: Icon(
                                      AppIcons.fangda,
                                      size: 16.w,
                                      color: constTheme.centerChannelColor,
                                    ),
                                  ),
                                ],
                              ),
                              //   Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       for (var i = 0; i < actions.length; i++)
                              //         Container(
                              //           decoration: BoxDecoration(
                              //               borderRadius: BorderRadius.all(Radius.circular(8.w)),
                              //               color: actions[i].backgroundColor),
                              //           margin: EdgeInsets.only(right: i != actions.length - 1 ? 5.w : 0),
                              //           child: IconButton(
                              //             iconSize: 18.w,
                              //             constraints: BoxConstraints(
                              //                 minWidth: 30.w, maxWidth: 30.w, minHeight: 30.w, maxHeight: 30.w),
                              //             style: IconButton.styleFrom(
                              //               shape: RoundedRectangleBorder(
                              //                 borderRadius: BorderRadius.circular(8.w),
                              //               ),
                              //             ),
                              //             padding: EdgeInsets.zero,
                              //             icon: actions[i].child,
                              //             color: Colors.white,
                              //             onPressed: () async {
                              //               actions[i].onPressed();
                              //             },
                              //           ),
                              //         ),
                              //     ],
                              //   ),
                            ),
                          ),
                        );
                      }

                      return Column(children: calls);
                    })
                  ],
                )
              : const ChannelList(key: Key("ChannelList")),
        ),
      ],
    );
  }
}
