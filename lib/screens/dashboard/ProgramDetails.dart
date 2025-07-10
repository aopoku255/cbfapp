import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart'; // Keep if used for other widgets, otherwise can remove

class ProgramDetails extends StatefulWidget {
  const ProgramDetails({super.key});

  @override
  State<ProgramDetails> createState() => _ProgramDetailsState();
}

// Add TickerProviderStateMixin for AnimationController to support live animation
class _ProgramDetailsState extends State<ProgramDetails> with TickerProviderStateMixin {
  // AnimationController for the pulsing effect
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1), // Duration for one pulse cycle
    )..repeat(reverse: true); // Repeat the animation in reverse (pulse in and out)

    // Define the animation (fades from 0.5 opacity to 1.0 and back)
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ModalRoute.of(context)!.settings.arguments as List<SessionData>;
    final firstSession = sessions.first;

    Future<void> launchUrlIfPossible(String url) async {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication); // opens in browser
      } else {
        throw 'Could not launch $url';
      }
    }


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

          final speakerNames = session.speakers.map((s) => "${s.fname}  ${s.lname}").join(", ");

          // Determine if session is live or ended
          bool isLive = false;
          bool isEnded = false;
          if (session.session?.date != null && session.starttime != null && session.endtime != null) {
            final now = DateTime.now();
            final sessionDate = DateTime.parse(session.session!.date!.toString());

            final startParts = session.starttime!.split(":").map(int.parse).toList();
            final endParts = session.endtime!.split(":").map(int.parse).toList();

            final startDateTime = DateTime(
              sessionDate.year,
              sessionDate.month,
              sessionDate.day,
              startParts[0],
              startParts[1],
            );
            final endDateTime = DateTime(
              sessionDate.year,
              sessionDate.month,
              sessionDate.day,
              endParts[0],
              endParts[1],
            );

            isLive = now.isAfter(startDateTime) && now.isBefore(endDateTime);
            isEnded = now.isAfter(endDateTime); // Session has ended
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MainText(
                        text: session.topic ?? "No topic",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],

                ),
                const SizedBox(height: 12),
                MainText(text: session.name == "Parallel Session" ? _cleanSessionName(session.session.name): session.name),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    MainText(
                      text: "${_formatTime(session.starttime) ?? ''} - ${_formatTime(session.endtime) ?? ''}",
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
                SizedBox(height: 10,),
                session.hall!.isNotEmpty ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.room, size: 18, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: MainText(
                        text: session.hall! ?? "N/A",
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ) : Container(),
                if(isLive)
                  session.zoomlink!.isNotEmpty ? Button(label: "Join Zoom"): Container(),
                SizedBox(height: 20,),
                if (isLive)
                // Apply the pulsing animation to the LIVE container
                  FadeTransition(
                    opacity: _pulseAnimation,
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.circle,
                              color: Colors.white, size: 10),
                          SizedBox(width: 5),
                          Text(
                            'LIVE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!isLive && isEnded) // Display 'ENDED' if the session has ended and is not live
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red, // Use a different color for ended sessions
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, // Or another suitable icon
                            color: Colors.white, size: 10),
                        SizedBox(width: 5),
                        Text(
                          'ENDED',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, fontSize: 10),
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
