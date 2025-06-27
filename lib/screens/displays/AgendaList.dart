import 'package:cbfapp/models/ongoing_model.dart';
import 'package:cbfapp/services/ongoing_service.dart';
import 'package:cbfapp/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/MainText.dart';

class AgendaList extends StatefulWidget {
  const AgendaList({super.key});

  @override
  State<AgendaList> createState() => _AgendaListState();
}

class _AgendaListState extends State<AgendaList> with TickerProviderStateMixin {
  late Future<ParallelSessionsResponse> _sessionsFuture;
  String? _selectedDate;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = ParallelSessionsService().fetchParallelSessions();

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ParallelSessionsResponse>(
      future: _sessionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: MainText(text: "Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: MainText(text: "No agenda found."));
        }

        final sessions = snapshot.data!.data;

        final uniqueDates = sessions
            .where((s) => s.session?.date != null)
            .map((s) => _formatDate(DateTime.parse(s.session!.date!.toString())))
            .toSet()
            .toList()
          ..sort();

        final filteredSessions = (_selectedDate == null
            ? sessions
            : sessions.where((s) {
          final date = s.session?.date != null
              ? _formatDate(DateTime.parse(s.session!.date!.toString()))
              : '';
          return date == _selectedDate;
        }).toList())
          ..sort((a, b) {
            final aDate = a.session?.date != null ? DateTime.parse(a.session!.date!.toString()) : null;
            final bDate = b.session?.date != null ? DateTime.parse(b.session!.date!.toString()) : null;

            final aTime = a.starttime != null
                ? TimeOfDay(
              hour: int.parse(a.starttime!.split(':')[0]),
              minute: int.parse(a.starttime!.split(':')[1]),
            )
                : null;

            final bTime = b.starttime != null
                ? TimeOfDay(
              hour: int.parse(b.starttime!.split(':')[0]),
              minute: int.parse(b.starttime!.split(':')[1]),
            )
                : null;

            final aDateTime = (aDate != null && aTime != null)
                ? DateTime(aDate.year, aDate.month, aDate.day, aTime.hour, aTime.minute)
                : DateTime.now();

            final bDateTime = (bDate != null && bTime != null)
                ? DateTime(bDate.year, bDate.month, bDate.day, bTime.hour, bTime.minute)
                : DateTime.now();

            return aDateTime.compareTo(bDateTime);
          });

        final Map<String, List<SessionData>> groupedSessions = {};
        for (var session in filteredSessions) {
          final sessionId = session.session.id.toString();
          groupedSessions.putIfAbsent(sessionId, () => []).add(session);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedDate,
                      hint: const Text("Filter by Date"),
                      items: uniqueDates.map((date) {
                        return DropdownMenuItem<String>(
                          value: date,
                          child: Text(date),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDate = value;
                        });
                      },
                    ),
                  ),
                  if (_selectedDate != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      tooltip: 'Clear filter',
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (groupedSessions.isEmpty)
              const Center(child: MainText(text: "No sessions found for this date."))
            else
              ...groupedSessions.entries.map((entry) {
                final sessionGroup = entry.value;
                final first = sessionGroup.first;
                final title = first.name == "Parallel Session" ? first.session.name : first.name;
                final date = first.session?.date != null
                    ? DateTime.parse(first.session!.date!.toString())
                    : null;

                final startTime = first.starttime;
                final endTime = first.endtime;

                bool isLive = false;
                bool isEnded = false;
                if (date != null && startTime != null && endTime != null) {
                  final now = DateTime.now();

                  final startParts = startTime.split(":").map(int.parse).toList();
                  final endParts = endTime.split(":").map(int.parse).toList();

                  final startDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    startParts[0],
                    startParts[1],
                  );
                  final endDateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    endParts[0],
                    endParts[1],
                  );

                  isLive = now.isAfter(startDateTime) && now.isBefore(endDateTime);
                  isEnded = now.isAfter(endDateTime);
                }

                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/program-details",
                          arguments: sessionGroup,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Column(
                                  children: [
                                    MainText(text: _formatTime(startTime)),
                                    const SizedBox(height: 10),
                                    MainText(text: _formatTime(endTime)),
                                    const SizedBox(height: 5),
                                    if (isLive)
                                      FadeTransition(
                                        opacity: _pulseAnimation,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.circle, color: Colors.white, size: 10),
                                              SizedBox(width: 5),
                                              Text(
                                                'LIVE',
                                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (!isLive && isEnded)
                                      Container(
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
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                width: 3,
                                height: double.infinity,
                                color: AppColors.primaryColor,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MainText(
                                      text: _cleanSessionName(title),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    const SizedBox(height: 10),
                                    if (date != null)
                                      MainText(
                                        text: _formatDate(date),
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    const SizedBox(height: 4),
                                    sessionGroup.length > 1
                                        ? MainText(
                                      text: "${sessionGroup.length} ${sessionGroup.first.name == "Parallel Session" ? "Presentations":"Activities"}",
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${_getMonth(date.month)} ${date.day}";
  }

  String _getMonth(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
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
