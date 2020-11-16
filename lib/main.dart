import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Random Namo Memes App',
      home: MyHomePage(title: 'Flutter Random Namo Memes App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String _url = "https://namo-memes.herokuapp.com/memes/1";
  StreamController _streamController;
  Stream _stream;
  Response response;

  getmemes() async {
    _streamController.add("waiting");
    response = await get(_url);
    _streamController.add(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    getmemes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text(widget.title)),
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return getmemes();
          },
          child: Center(
            child: StreamBuilder(
              stream: _stream,
              builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                if (snapshot.data == "waiting") {
                  return Center(child: Text("Waiting of the Memes....."));
                }
                return Center(
                  child: ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Center(
                          child: ListBody(
                            children: [
                              Center(
                                child: Card(
                                    elevation: 8.0,
                                    child: Center(
                                        child:FadeInImage.assetNetwork(
                                          placeholder: 'assets/loading.gif',
                                          image:  snapshot.data[0]['url'],
                                        ),),),
                              )
                            ],
                          ),
                        );
                      }),
                );
              },
            ),
          ),
        ));
  }
}
