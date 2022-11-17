import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:music_app/src/blocs/global.dart';
import 'package:music_app/src/helpers/foreground_task_helper.dart';
import 'package:music_app/src/ui/music_homepage/music_homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ChillifyApp extends StatefulWidget {
  @override
  State<ChillifyApp> createState() => _ChillifyAppState();
}

class _ChillifyAppState extends State<ChillifyApp> {
  final GlobalBloc _globalBloc = GlobalBloc();

  @override
  void initState() {
    super.initState();
    ForegroundTaskHelper.initForegroundTask();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = await FlutterForegroundTask.receivePort;
        ForegroundTaskHelper.registerReceivePort(newReceivePort);
      }
    });
  }

  @override
  void dispose() {
    ForegroundTaskHelper.closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>(
      create: (context) => _globalBloc,
      builder: (BuildContext context, Widget? child) {
        _globalBloc.permissionsBloc.storagePermissionStatus$.listen(
          (data) {
            if (data == PermissionStatus.granted) {
              _globalBloc.musicPlayerBloc.fetchSongs().then(
                (_) {
                  _globalBloc.musicPlayerBloc.retrieveFavorites();
                },
              );
            }
          },
        );
        return child ??
            Container(
              height: 100.0,
              width: 100.0,
              color: Colors.red,
            );
      },
      dispose: (BuildContext context, GlobalBloc value) => value.dispose(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          sliderTheme: SliderThemeData(
            trackHeight: 1,
          ),
        ),
        home: SafeArea(
          child: StreamBuilder<PermissionStatus>(
            stream: _globalBloc.permissionsBloc.storagePermissionStatus$,
            builder: (BuildContext context,
                AsyncSnapshot<PermissionStatus> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final PermissionStatus _status = snapshot.data!;
              if (_status == PermissionStatus.denied) {
                _globalBloc.permissionsBloc.requestStoragePermission();
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return MusicHomepage();
              }
            },
          ),
        ),
      ),
    );
  }
}
