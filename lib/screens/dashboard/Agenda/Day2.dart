import 'package:flutter/material.dart';

import '../../../theme/colors.dart';
import '../../displays/AgendaGrid.dart';
import '../../displays/AgendaList.dart';

class Day2 extends StatefulWidget {
  const Day2({super.key});

  @override
  State<Day2> createState() => _Day2State();
}

class _Day2State extends State<Day2> {
  int selectedIndex = 0;

  final List<IconData> tabs = [Icons.grid_view, Icons.list_rounded];
  final List<String> tabText = ["Grid", "List"];
  final tabPages = [AgendaGrid(), AgendaList()];
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        // const SizedBox(height: 20),
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
                          decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  .withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)),
                          padding: EdgeInsets.all(8),
                          child: Icon(tabs[index]))
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 20),
        tabPages[selectedIndex]
      ],
    );
  }
}
