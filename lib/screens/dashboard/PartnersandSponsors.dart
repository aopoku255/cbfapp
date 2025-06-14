import 'package:cbfapp/App.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class PartnersandSponsors extends StatefulWidget {
  const PartnersandSponsors({super.key});

  @override
  State<PartnersandSponsors> createState() => _PartnersandSponsorsState();
}

class _PartnersandSponsorsState extends State<PartnersandSponsors> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MainText(text: "Sponsors and Partners",),
      ),
    );
  }
}
