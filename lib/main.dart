import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'colors.dart';

void main() => runApp(GradientGenerator());

Container buildColorContainer(List<Color> colors) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: colors
          .map((e) => Container(
                height: 64,
                width: 64,
                color: e,
              ))
          .toList(),
    ),
  );
}

Container buildGradientContainer(List<Color> colors) {
  return Container(
    width: 2048,
    height: 8,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        colors: colors,
      ),
    ),
  );
}

void saveWidgetAsImage(Uint8List capturedImage) {
  html.document.createElement('a') as html.AnchorElement
    ..href = html.Url.createObjectUrlFromBlob(html.Blob([capturedImage]))
    ..attributes
    ..style.display = 'none'
    ..download = 'ColorPalette.png'
    ..click();
}

class GradientGenerator extends StatefulWidget {
  GradientGenerator({Key? key}) : super(key: key);

  @override
  _GradientGeneratorState createState() => _GradientGeneratorState();
}

class _GradientGeneratorState extends State<GradientGenerator> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    var gradientsWidget = SizedBox(
      height: 2048,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: colors.map((color) => buildGradientContainer(color)).toList(),
      ),
    );

    return MaterialApp(
      title: 'Gradient Generator',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Scrollbar(
          isAlwaysShown: true,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  ...colors.map((color) => buildColorContainer(color)).toList(),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: Text('Save as Gradient'),
                    onPressed: () {
                      screenshotController
                          .captureFromWidget(
                              InheritedTheme.captureAll(
                                context,
                                gradientsWidget,
                              ),
                              delay: Duration(seconds: 1))
                          .then((capturedImage) {
                        saveWidgetAsImage(capturedImage);
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  gradientsWidget
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
