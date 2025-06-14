import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class DashboardResources extends StatefulWidget {
  const DashboardResources({super.key});

  @override
  State<DashboardResources> createState() => _DashboardResourcesState();
}

class _DashboardResourcesState extends State<DashboardResources> {
  int selectedIndex = 0;

  final List<IconData> tabs = [Icons.grid_view, Icons.list_rounded];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        backgroundColor: AppColors.primaryBackground,
        appBar: AppBar(
          title: const MainText(text: "Resources"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          bottom: TabBar(

            tabs: [
              Tab(icon: Image.asset("assets/images/files.png"), text: "Files",),
              Tab(icon: Image.asset("assets/images/galleryicon.png"), text: "Photos",),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), alignment: Alignment.bottomLeft)),
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(
                          children: List.generate(tabs.length, (index) {
                            final bool isSelected = selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Row(
                                children: [
                                  // isSelected ? Icon(Icons.check, color: AppColors.primaryColor,) : MainText(text: ""),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20, right: 20),
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryColor.withOpacity(0.2)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(8),
                                      child: index == 0 ? Icon(tabs[index]) : Image.asset("assets/images/listview.png"))
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/background.png"), alignment: Alignment.bottomLeft)),
              child: Center(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        Row(
                          children: List.generate(tabs.length, (index) {
                            final bool isSelected = selectedIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Row(
                                children: [
                                  // isSelected ? Icon(Icons.check, color: AppColors.primaryColor,) : MainText(text: ""),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 20, right: 20),
                                      decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryColor.withOpacity(0.2)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(5)),
                                      padding: EdgeInsets.all(8),
                                      child: index == 0 ? Icon(tabs[index]) : Image.asset("assets/images/listview.png"))
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
