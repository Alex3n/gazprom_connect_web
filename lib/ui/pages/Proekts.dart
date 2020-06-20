

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gazpromconnectweb/ui/widgets/myAppBar.dart';

class Proekts extends StatefulWidget{
  @override
  _ProektsState createState() => _ProektsState();
}

class _ProektsState extends State<Proekts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(child: Text('ПРОЕКТЫЫ'),),
    );
  }
}