import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgramDetails extends StatefulWidget {
  const ProgramDetails({super.key});

  @override
  State<ProgramDetails> createState() => _ProgramDetailsState();
}

class _ProgramDetailsState extends State<ProgramDetails> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> launchUrlIfPossible(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ModalRoute.of(context)!.settings.arguments as List<SessionData>;
    final firstSession = sessions.first;

    return Scaffold(
      appBar: AppBar(
        title: MainText(text: firstSession.name),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final speakerNames = session.speakers.map((s) => "${s.fname} ${s.lname}").join(", ");

          bool isLive = false;
          bool isEnded = false;

          if (session.session?.date != null && session.starttime != null && session.endtime != null) {
            final now = DateTime.now();
            final sessionDate = DateTime.parse(session.session!.date!.toString());
            final startParts = session.starttime!.split(":").map(int.parse).toList();
            final endParts = session.endtime!.split(":").map(int.parse).toList();

            final startDateTime = DateTime(sessionDate.year, sessionDate.month, sessionDate.day, startParts[0], startParts[1]);
            final endDateTime = DateTime(sessionDate.year, sessionDate.month, sessionDate.day, endParts[0], endParts[1]);

            isLive = now.isAfter(startDateTime) && now.isBefore(endDateTime);
            isEnded = now.isAfter(endDateTime);
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: session.topic ?? "No topic",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                MainText(text: session.name == "Parallel Session" ? _cleanSessionName(session.session!.name) : session.name),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    MainText(
                      text: "${_formatTime(session.starttime)} - ${_formatTime(session.endtime)}",
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (speakerNames.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: MainText(
                          text: speakerNames,
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                if (session.hall != null && session.hall!.isNotEmpty)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.room, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: MainText(
                          text: session.hall!,
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                if (isLive && session.zoomlink != null && session.zoomlink!.isNotEmpty)
                  Button(
                    label: "Join Zoom",
                    onTap: () => launchUrlIfPossible(session.zoomlink!),
                  ),
                const SizedBox(height: 20),
                if (isLive)
                  FadeTransition(
                    opacity: _pulseAnimation,
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.circle, color: Colors.white, size: 10),
                          SizedBox(width: 5),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isLive && isEnded)
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white, size: 10),
                        SizedBox(width: 5),
                        Text(
                          'ENDED',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null) return '';
    try {
      final parsedTime = DateFormat("HH:mm").parse(time);
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  String _cleanSessionName(String name) {
    final cleaned = name.replaceAll(RegExp(r'\bDay\s*\d+\b', caseSensitive: false), '');
    return cleaned.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
  }
}
