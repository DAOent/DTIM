import 'dart:io';
import 'dart:ui';

import 'package:dtim/domain/utils/platform_infos.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';


showtray() async {
  // print("window.platformBrightness => " + window.platformBrightness.toString());
  await trayManager.setIcon(
    'assets/images/top_bar${(window.platformBrightness != Brightness.dark && PlatformInfos.isWindows) ? "" : "_dark"}${PlatformInfos.isWindows ? '.ico' : '.png'}',
  );

  List<MenuItem> items = [
    MenuItem(
      key: 'show_window',
      label: 'Show Window',
      onClick: (e) {
        windowManager.show();
      },
    ),
    MenuItem(
      key: 'exit_app',
      label: 'Exit App',
      onClick: (e) {
        windowManager.destroy();
      },
    ),
  ];

  await trayManager.setContextMenu(Menu(items: items));
  trayManager.addListener(TrayManagerListener());
  if (Platform.isMacOS) {
    trayManager.setToolTip("DTIM");
  }

  await windowManager.setPreventClose(true);
  // windowManager.addListener(WindowManagerListener());
}

class TrayManagerListener implements TrayListener {
  @override
  void onTrayIconMouseDown() {
    windowManager.show();
  }

  @override
  void onTrayIconMouseUp() {}

  @override
  void onTrayIconRightMouseDown() {
    trayManager.popUpContextMenu();
  }

  @override
  void onTrayIconRightMouseUp() {}

  @override
  void onTrayMenuItemClick(MenuItem menuItem) {}
}

// class WindowManagerListener implements WindowListener {
//   @override
//   void onWindowBlur() {}

//   @override
//   void onWindowFocus() {}

//   @override
//   void onWindowMaximize() {}

//   @override
//   void onWindowMinimize() {}

//   @override
//   void onWindowMove() {}

//   @override
//   void onWindowResize() {
//     windowManager.getSize().then((value) async {
//       final systemStore = await SystemApi.create();
//       await systemStore.save(value.width, value.height);
//     });
//   }

//   @override
//   void onWindowRestore() {}

//   @override
//   void onWindowClose() {
//     windowManager.hide();
//   }

//   @override
//   void onWindowEnterFullScreen() {}

//   @override
//   void onWindowEvent(String eventName) {}

//   @override
//   void onWindowLeaveFullScreen() {}

//   @override
//   void onWindowMoved() {}

//   @override
//   void onWindowResized() {}

//   @override
//   void onWindowUnmaximize() {}
  
//   @override
//   void onWindowDocked() {
//     // TODO: implement onWindowDocked
//   }
  
//   @override
//   void onWindowUndocked() {
//     // TODO: implement onWindowUndocked
//   }
// }
