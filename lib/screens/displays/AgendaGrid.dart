import 'package:cbfapp/widgets/ExpandedText.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class AgendaGrid extends StatefulWidget {
  const AgendaGrid({super.key});

  @override
  State<AgendaGrid> createState() => _AgendaGridState();
}

class _AgendaGridState extends State<AgendaGrid> {
  @override
  Widget build(BuildContext context) {
    return  Center(child: Text("Grid"),);
  }
}
