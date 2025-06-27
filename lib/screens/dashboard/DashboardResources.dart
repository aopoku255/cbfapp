import 'package:cbfapp/theme/colors.dart';
import 'package:cbfapp/widgets/MainText.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/Gallery.dart';
import '../../services/Galleryservice.dart';
import '../Fullscreenview.dart';

class DashboardResources extends StatefulWidget {
  const DashboardResources({super.key});

  @override
  State<DashboardResources> createState() => _DashboardResourcesState();
}

class _DashboardResourcesState extends State<DashboardResources> {
  late Future<GalleryImageResponse> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = GalleryService.fetchGalleryImages();
  }

  void _openGalleryViewer(List<GalleryImage> images, int startIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FullScreenGalleryViewer(
          images: images,
          initialIndex: startIndex,
        ),
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final fileDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(fileDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat("dd MMM yyyy").format(date);
  }

  Map<String, List<GalleryImage>> _groupImagesByDate(List<GalleryImage> images) {
    final Map<String, List<GalleryImage>> grouped = {};

    for (var image in images) {
      final createdAt = DateTime.tryParse(image.createdAt.toString() ?? '');
      if (createdAt != null) {
        final label = _getDateLabel(createdAt);
        grouped.putIfAbsent(label, () => []).add(image);
      } else {
        grouped.putIfAbsent("Unknown", () => []).add(image);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: const Text("Gallery"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<GalleryImageResponse>(
        future: _galleryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("No images available."));
          }

          final grouped = _groupImagesByDate(snapshot.data!.data);

          return ListView(
            padding: const EdgeInsets.all(10),
            children: grouped.entries.map((entry) {
              final images = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  MainText(
                    text: entry.key,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final image = images[index];
                      final imageUrl = "https://summitapi.cariscabusinessforum.com${image.imageUrl}";
                      return GestureDetector(
                        onTap: () => _openGalleryViewer(images, index),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Center(child: Icon(Icons.broken_image)),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 0,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/watermark.png', // your watermark asset path
                                      width: 50,
                                      height: 50,
                                      // color: Colors.white.withOpacity(0.7), // optional tint
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        image.uploadedBy ?? "Anonymous",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
