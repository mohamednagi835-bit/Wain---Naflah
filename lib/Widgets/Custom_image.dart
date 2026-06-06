import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    this.height = 180,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,

      // Loading
      placeholder: (context, url) => Container(
        height: height,
        width: width,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),

      // Error fallback
      errorWidget: (context, url, error) => Container(
        height: height,
        width: width,
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        ),
      ),

      /// ✨ Smooth fade
      fadeInDuration: const Duration(milliseconds: 300),
    );
  }
}
