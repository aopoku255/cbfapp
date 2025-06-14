import 'package:cbfapp/models/speakers_model.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/Button.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this is imported

class SpeakerDetails extends StatefulWidget {
  const SpeakerDetails({super.key});

  @override
  State<SpeakerDetails> createState() => _SpeakerDetailsState();
}

class _SpeakerDetailsState extends State<SpeakerDetails> {
  // Helper to launch LinkedIn URL
  Future<void> _launchLinkedIn(String linkedinUrl) async {
    final url = Uri.parse(linkedinUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch $url');
    }
  }

  // Helper to format date for display
  String _formatDate(DateTime date) {
    return "${_getMonth(date.month)} ${date.day}";
  }

  // Helper to get month abbreviation
  String _getMonth(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final speaker = ModalRoute.of(context)!.settings.arguments as SpeakerModel;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: MainText(text: "${speaker.fname ?? ''} ${speaker.lname ?? ''}", color: Colors.white,),
        centerTitle: true,
        backgroundColor: AppColors.primaryVoilet,
        foregroundColor: Colors.white,
        elevation: 0, // Remove shadow for a flatter look
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section with AppBar-like background color
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20, bottom: 80), // Increased bottom padding for avatar overlap
              decoration: BoxDecoration(
                color: AppColors.primaryVoilet,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70, // Larger avatar
                    backgroundColor: Colors.white, // White background for avatar border effect
                    backgroundImage: (speaker.image != null && speaker.image!.isNotEmpty)
                        ? NetworkImage("http://10.0.2.2:8081${speaker.image}")
                        : null,
                    child: (speaker.image == null || speaker.image!.isEmpty)
                        ? MainText(
                      text: speaker.fname?.isNotEmpty == true ? speaker.fname![0] : "",
                      fontSize: 50,
                      color: AppColors.primaryColor,
                    )
                        : null,
                  ),
                  const SizedBox(height: 15),
                  MainText(
                    text: "${speaker.fname ?? ''} ${speaker.lname ?? ''}",
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                    color: Colors.white, // White text for speaker name
                  ),
                  const SizedBox(height: 5),
                  MainText(
                    text: speaker.company ?? "Affiliation not available",
                    fontSize: 18,
                    color: Colors.white70, // Lighter white for company
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Main Content Area (Cards)
            Transform.translate(
              offset: const Offset(0, -60), // Move content up to overlap with top section
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Connect Button Card
                    if (speaker.linkedin != null && speaker.linkedin!.isNotEmpty)
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Button(
                            label: "Connect on LinkedIn",
                            onTap: () => _launchLinkedIn(speaker.linkedin!),
                            // You can add more styling to the Button widget itself if needed
                          ),
                        ),
                      ),

                    // Speaker Bio Card
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainText(
                              text: "Biography",
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryVoilet,
                            ),
                            const Divider(height: 20, thickness: 1.5, color: Colors.grey),
                            if (speaker.bio != null && speaker.bio!.isNotEmpty)
                              Html(data: speaker.bio!),
                            if (speaker.bio == null || speaker.bio!.isEmpty)
                              MainText(
                                text: "No biography available for this speaker.",
                                color: Colors.grey.shade600,

                              ),
                          ],
                        ),
                      ),
                    ),

                    // Sessions Card
                    if (speaker.parallelSessions != null && speaker.parallelSessions!.isNotEmpty)
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                text: "Sessions",
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryVoilet,
                              ),
                              const Divider(height: 20, thickness: 1.5, color: Colors.grey),
                              Column(
                                children: speaker.parallelSessions!.map((session) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        MainText(
                                          text: session.topic ?? "Untitled Session",
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.primaryVoilet, // Use an accent color for topic
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time_rounded, size: 16, color: Colors.black),
                                            const SizedBox(width: 6),
                                            MainText(
                                              text: "${session.startTime ?? ''} - ${session.endTime ?? ''}",
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(width: 15),

                                          ],
                                        ),
                                        if (speaker.parallelSessions!.last != session) // Add divider for all but last
                                          const Padding(
                                            padding: EdgeInsets.only(top: 15.0),
                                            child: Divider(height: 1, thickness: 0.8, color: Colors.black12),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (speaker.parallelSessions == null || speaker.parallelSessions!.isEmpty)
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: MainText(
                            text: "No sessions scheduled for this speaker.",
                            color: Colors.grey.shade600,
                          ),
                        ),
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
