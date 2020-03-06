import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage({this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final _controller = Completer<WebViewController>();

  _loadHtmlFromAssets() async {
    String fileHtmlContents =
        await rootBundle.loadString("assets/web/js_bridge.html");
    _controller.future.then((v) => v?.loadUrl(Uri.dataFromString(
            fileHtmlContents,
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("webView Demo"),
      ),
      body: Builder(
          builder: (context) => WebView(
                initialUrl: widget.url ?? "",
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (controller) {
                  _controller.complete(controller);
                  if (widget.url?.isEmpty ?? true) _loadHtmlFromAssets();
                },
                navigationDelegate: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
                javascriptChannels:
                    [NativeBridge(context, _controller.future)].toSet(),
              )),
    );
  }
}

class NativeBridge implements JavascriptChannel {
  BuildContext context;
  Future<WebViewController> _controller;

  NativeBridge(this.context, this._controller);

  Map<String, dynamic> _getValue(data) => {"value": 1};

  Future<Map<String, dynamic>> _inputText(data) async {
    String text = await showDialog(
        context: context,
        builder: (_) {
          final textController = TextEditingController();
          return AlertDialog(
            content: TextField(controller: textController),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.pop(context, textController.text),
                  child: Icon(Icons.done)),
            ],
          );
        });
    return {"text": text ?? ""};
  }

  Map<String, dynamic> _showSnackBar(data) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(data["text"] ?? "")));
    return null;
  }

  Map<String, dynamic> _newWebView(data) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => WebViewPage(url: data["url"])));
    return null;
  }

  get _functions => <String, Function>{
        "getValue": _getValue,
        "inputText": _inputText,
        "showSnackBar": _showSnackBar,
        "newWebView": _newWebView,
      };

  @override
  String get name => "nativeBridge";

  @override
  get onMessageReceived => (msg) async {
        Map<String, dynamic> message = json.decode(msg.message);
        final data = await _functions[message["api"]](message["data"]);
        message["data"] = data;
        _controller.then((v) => v.evaluateJavascript(
            "window.jsBridge.receiveMessage(${json.encode(message)})"));
      };
}
