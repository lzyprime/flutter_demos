import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
              ),
              RaisedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => OverlayDemo2())),
                child: Text("demo2"),
              ),
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

class OverlayDemo2 extends StatefulWidget {
  @override
  createState() => OverlayDemo2State();
}

class OverlayDemo2State extends State<OverlayDemo2> {
  final _layerLink = LayerLink();
  final _buttonKey = GlobalKey();
  OverlayEntry _overlayEntry;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("OverlayDemo2")),
      body: ListView(
        children: [
          Container(
            constraints: BoxConstraints.expand(height: size.height),
            alignment: Alignment.center,
            child: ListTile(
              title: CompositedTransformTarget(
                link: _layerLink,
                child: RaisedButton(
                  color: Colors.amberAccent,
                  key: _buttonKey,
                    onPressed: () {
                  if (_overlayEntry != null) {
                    _overlayEntry.remove();
                    _overlayEntry = null;
                    return;
                  }
                  final buttonSize = (_buttonKey.currentContext.findRenderObject() as RenderBox).size;

                  Overlay.of(context).insert(_overlayEntry = OverlayEntry(
                      builder: (context) => Positioned(child: CompositedTransformFollower(
                        link: _layerLink,
                        showWhenUnlinked: false,
                        offset: Offset(0, buttonSize.height),
                        child: Container(color: Colors.blue),
                      ),width: buttonSize.width,
                        height: 300,
                      )));
                }),
              ),
            ),
          ),
          SizedBox.fromSize(size: size),
          SizedBox.fromSize(size: size),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }
}
