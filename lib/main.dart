import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("overlay demo")),
        extendBodyBehindAppBar: true,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OverlayDemo1())),
                child: Text("demo1"),
              )
            ],
          ),
        ),
      );
}

class OverlayDemo1 extends StatefulWidget {
  @override
  _OverlayDemo1State createState() => _OverlayDemo1State();
}

class _OverlayDemo1State extends State<OverlayDemo1> {
  OverlayEntry _overlayEntry;
  int current = 0;
  final buttonRowKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OverlayDemo1"),
      ),
      body: Column(
        children: [
          Row(
              key: buttonRowKey,
              children: List.generate(
                3,
                (i) => RaisedButton(
                  onPressed: () {
                    final index = i + 1;
                    if (current == index) {
                      _overlayEntry?.remove();
                      _overlayEntry = null;
                      current = 0;
                      return;
                    }
                    current = index;
                    _overlayEntry?.remove();
                    final box = buttonRowKey.currentContext.findRenderObject() as RenderBox;
                    final dy = box.localToGlobal(Offset(0, box.size.height)).dy;
                    _overlayEntry = OverlayEntry(
                        builder: (context) => Positioned.fill(
                              top: dy,
                              child: Material(
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Container(
                                      color: Theme.of(context).backgroundColor,
                                      alignment: Alignment.center,
                                      constraints: BoxConstraints.expand(height: 500),
                                      child: Text("menu$index"),
                                    ),
                                    Expanded(child: GestureDetector(onTap: () {
                                      _overlayEntry.remove();
                                      _overlayEntry = null;
                                      current = 0;
                                    })),
                                  ],
                                ),
                              ),
                            ));
                    Overlay.of(context).insert(_overlayEntry);
                  },
                  child: Text("menu${i + 1}"),
                ),
              )),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }
}
