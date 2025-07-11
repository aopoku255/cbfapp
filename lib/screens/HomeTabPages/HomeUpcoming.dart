import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/ExpandedText.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ongoing_session_model.dart';
import '../../services/ongoing_service.dart';

class HomeUpcoming extends StatefulWidget {
  const HomeUpcoming({super.key});

  @override
  State<HomeUpcoming> createState() => _HomeUpcomingState();
}

class _HomeUpcomingState extends State<HomeUpcoming> {
  late Future<ParallelSessionsResponse> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ParallelSessionsService().fetchUpcomingSessions();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildTag(String text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(50),
        ),
        child: MainText(text: text, color: Colors.black),
      );
    }

    Widget _buildAction(String iconPath, String label) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Image.asset(iconPath, height: 20),
            const SizedBox(width: 5),
            MainText(text: label),
          ],
        ),
      );
    }

    String formatDate(String isoDateString) {
      final date = DateTime.parse(isoDateString);
      return DateFormat("MMM d").format(date); // e.g., May 27
    }

    return FutureBuilder<ParallelSessionsResponse>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: MainText(text: 'No upcoming sessions for today. You can view agenda for full sessions', textAlign: TextAlign.center,));
        }

        final sessions = snapshot.data!.data;

        // Group by sessionId
        final Map<String, List<SessionData>> groupedSessions = {};
        for (var session in sessions) {
          final sessionId = session.session.id.toString();
          if (!groupedSessions.containsKey(sessionId)) {
            groupedSessions[sessionId] = [];
          }
          groupedSessions[sessionId]!.add(session);
        }

        final groupedList = groupedSessions.entries.toList();


        return SizedBox(
          height: 220,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: groupedList.map((entry) {
                final sessionGroup = entry.value;
                final firstSession = sessionGroup[0];
                final sessionCount = sessionGroup.length;
                final sessionId = sessionGroup[0].session.id;

                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/program-details",
                      arguments: entry.value,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    padding: const EdgeInsets.all(10),
                    width: 320,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/background.png"),
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        opacity: 0.7,
                        repeat: ImageRepeat.repeatY,
                      ),
                      color: AppColors.primaryGold.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildTag(formatDate(firstSession.session.date.toString())),
                            const SizedBox(width: 10),
                            _buildTag("${_formatTime(firstSession.starttime)} - ${_formatTime(firstSession.endtime)}"),
                            const SizedBox(width: 10),
                          ],
                        ),
                        const SizedBox(height: 20),
                        MainText(
                          text: firstSession.name,
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        ExpandableText(
                          text: firstSession.name == "Parallel Session" ? _cleanSessionName(firstSession.session.name) : firstSession.name,
                          maxLines: 1,
                          color: Colors.black,
                        ),
                        const Spacer(),
                        // Optional actions
                        // Row(
                        //   children: [
                        //     _buildAction("assets/images/qrcode.png", "Check in"),
                        //     const SizedBox(width: 5),
                        //     _buildAction("assets/images/vote.png", "Vote"),
                        //     const SizedBox(width: 5),
                        //     _buildAction("assets/images/live.png", "Join live"),
                        //   ],
                        // ),
                        sessionCount > 1 ? _buildTag("$sessionCount Presentations") : Container(),

                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
  String _formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String _cleanSessionName(String name) {
    // Removes 'Day <number>' at the end or surrounded by spaces
    final cleaned = name.replaceAll(RegExp(r'\bDay\s*\d+\b', caseSensitive: false), '');
    return cleaned.replaceAll(RegExp(r'\s{2,}'), ' ').trim(); // clean up extra spaces
  }


}
