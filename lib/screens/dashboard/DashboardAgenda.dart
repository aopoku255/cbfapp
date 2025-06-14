import 'package:cbfapp/screens/dashboard/Agenda/Day2.dart';
import 'package:cbfapp/screens/dashboard/Agenda/Day3.dart';
import 'package:cbfapp/screens/displays/AgendaGrid.dart';
import 'package:cbfapp/screens/displays/AgendaList.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../../widgets/MainText.dart';
import 'Agenda/Day1.dart';

class DashboardAgenda extends StatefulWidget {
  final Future<UserInfoModel>? userDetailsFuture;
  const DashboardAgenda({super.key, this.userDetailsFuture});

  @override
  State<DashboardAgenda> createState() => _DashboardAgendaState();
}

class _DashboardAgendaState extends State<DashboardAgenda> {

  final _tabs = [Day1(), Day1(), Day1()];


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,

          title: MainText(
            text: "Agenda",
          ),
          centerTitle: true,
          // bottom: TabBar(tabs: [
          //   Tab(text: "DAY 1",),
          //   Tab(text: "DAY 2",),
          //   Tab(text: "DAY 3",)
          // ],),
        ),
        body: Day1(),
          // Day2(),
          // Day3(),

      ),
    );
  }
}
