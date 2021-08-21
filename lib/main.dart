import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'colors.dart';

const double GradientHeight = 32;

void main() => runApp(GradientGenerator());

Container buildColorContainer(List<Color> colors, int index) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 64,
          width: 64,
          alignment: Alignment.center,
          child: Text(
            ((index * GradientHeight) + GradientHeight / 2).toString(),
          ),
        ),
        ...colors
            .map((color) => Container(
                  height: 64,
                  width: 64,
                  color: color,
                ))
            .toList(),
        Container(height: 64, width: 64)
      ],
    ),
  );
}

Container buildGradientContainer(List<Color> colors) {
  return Container(
    width: 2048,
    height: GradientHeight,
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
        children: colors
            .map((color) => buildGradientContainer(color))
            .toList()
            .reversed
            .toList(),
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
                  ...colors
                      .mapIndexed(
                          (color, index) => buildColorContainer(color, index))
                      .toList()
                      .reversed,
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
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }
}
