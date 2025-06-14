import 'package:cbfapp/models/speakers_model.dart';
import 'package:cbfapp/services/speaker_service.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';

class KeynoteSpeakers extends StatefulWidget {
  const KeynoteSpeakers({super.key});

  @override
  State<KeynoteSpeakers> createState() => _KeynoteSpeakersState();
}

class _KeynoteSpeakersState extends State<KeynoteSpeakers> {
  late Future<SpeakersResponseModel> _sessionsFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSpeakerType;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = SpeakerService().fetchSpeakers();
  }

  List<SpeakerModel> _filterSpeakers(List<SpeakerModel> speakers) {
    return speakers.where((speaker) {
      final fullName = '${speaker.prefix ?? ''} ${speaker.fname ?? ''} ${speaker.lname ?? ''}';
      final topic = speaker.parallelSessions.isNotEmpty
          ? speaker.parallelSessions.first.topic ?? ''
          : '';
      final speakerType = speaker.custom ?? '';

      final matchesSearch = _searchQuery.isEmpty ||
          fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          topic.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType = _selectedSpeakerType == null || _selectedSpeakerType == 'All Types'
          ? true
          : speakerType.toLowerCase() == _selectedSpeakerType!.toLowerCase();

      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          alignment: Alignment.topRight,
          opacity: 0.3,
          repeat: ImageRepeat.repeatY,
        ),
      ),
      child: FutureBuilder<SpeakersResponseModel>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: MainText(text: "Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: MainText(text: "No speakers found."));
          }

          final allSpeakers = snapshot.data!.data;

          // Get unique speaker types
          final speakerTypes = allSpeakers
              .map((s) => s.custom ?? '')
              .where((type) => type.isNotEmpty)
              .toSet()
              .toList()
            ..sort();

          speakerTypes.insert(0, 'All Types');

          final filtered = _filterSpeakers(allSpeakers);

          return Column(
            children: [
              // Dropdown Filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSpeakerType,
                        hint: const Text("Filter by Speaker Type"),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        items: speakerTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSpeakerType = value;
                          });
                        },
                        isExpanded: true,
                        itemHeight: 50,
                      ),
                    ),
                    if (_selectedSpeakerType != null && _selectedSpeakerType != 'All Types')
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            _selectedSpeakerType = null;
                          });
                        },
                      ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search keynote speakers...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),

              // Speakers list
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: MainText(text: "No speakers found matching your criteria."))
                    : ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final speaker = filtered[index];
                    final speakerType = filtered[index].custom;
                    final fullName =
                        '${speaker.prefix ?? ''} ${speaker.fname ?? ''} ${speaker.lname ?? ''}';
                    final topic = speaker.parallelSessions.isNotEmpty
                        ? speaker.parallelSessions.first.topic ?? 'No topic assigned'
                        : 'No topic assigned';
                    final speakerImage = (speaker.image != null && speaker.image!.isNotEmpty)
                        ? "http://10.0.2.2:8081${speaker.image}"
                        : null;

                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/speaker-details", arguments: speaker);
                      },
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                              speakerImage != null ? NetworkImage(speakerImage) : null,
                              child: speakerImage == null
                                  ? MainText(
                                text: speaker.fname?.isNotEmpty == true
                                    ? speaker.fname![0]
                                    : "",
                              )
                                  : null,
                            ),
                            title: MainText(text: fullName),
                            subtitle: MainText(text: speakerType),
                            trailing: const Icon(Icons.chevron_right_rounded),
                          ),
                          const Divider()
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
