import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:habit/components/nav.dart';
import 'package:habit/pages/edit.dart';
import 'package:habit/pages/home.dart';
import 'package:habit/utils/store.dart';

void main() async {
  runApp(const MainApp());
}

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

class NavigatedPage extends StatefulWidget {
  final Widget child;

  const NavigatedPage({super.key, required this.child});

  @override
  NavigatedPageState createState() => NavigatedPageState();
}

class NavigatedPageState extends State<NavigatedPage> {
  @override
  Widget build(BuildContext context) {
    DataLoader dataLoader = Get.find<DataLoader>();
    return Obx(() {
      if (!dataLoader.loaded) {
        return Loader();
      }
      return SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Get.back(closeOverlays: true);
            return false;
          },
          child: Scaffold(
            body: Column(
              children: [
                const Navigation(),
                Expanded(
                  child: widget.child,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(
        () {
          Get.put(TaskModel());
          Get.put(DataLoader());
        },
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
        colorScheme: const ColorScheme.light(
          primary: Colors.black,
          secondary: Colors.blue,
        ),
        fontFamily: 'Inter',
        fontFamilyFallback: const ['Roboto', 'sans-serif'],
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        if (settings.name == '/') {
          builder = (_) => NavigatedPage(child: const HomePage());
        } else if (settings.name == '/edit') {
          builder = (_) => NavigatedPage(child: const EditPage());
        } else {
          return null;
        }
        return NoAnimationPageRoute(
          builder: builder,
          settings: settings,
        );
      },
      onUnknownRoute: (settings) {
        return NoAnimationPageRoute(
          builder: (context) =>
              NavigatedPage(child: Text("404 Not Found: ${settings.name}")),
          settings: settings,
        );
      },
    );
  }
}

class NoAnimationPageRoute<T> extends PageRouteBuilder<T> {
  NoAnimationPageRoute({required this.builder, required RouteSettings settings})
      : super(
          settings: settings,
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return builder(context);
          },
          transitionDuration: const Duration(milliseconds: 0),
        );

  final WidgetBuilder builder;
}
