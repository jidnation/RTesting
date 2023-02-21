import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reach_me/core/utils/app_globals.dart';
import 'package:reach_me/features/account/presentation/widgets/image_placeholder.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    Key? key,
    this.height = 100,
    this.width = 100,
    this.border,
  }) : super(key: key);
  final double height, width;
  final Border? border;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(3),
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade50,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          imageUrl: globals.user!.profilePicture ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => const ImagePlaceholder(),
          errorWidget: (context, url, error) => const ImagePlaceholder(),
        ),
      ),
    );
  }
}

class CoverPicture extends StatelessWidget {
  const CoverPicture({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: globals.user!.coverPicture ?? '',
      placeholder: (context, url) => const CoverImagePlaceholder(),
      errorWidget: (context, url, error) => const CoverImagePlaceholder(),
      fit: BoxFit.cover,
    );
  }
}

class RecipientCoverPicture extends StatelessWidget {
  const RecipientCoverPicture({
        required this.imageUrl,

    Key? key,
  }) : super(key: key);
    final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      placeholder: (context, url) => const CoverImagePlaceholder(),
      errorWidget: (context, url, error) => const CoverImagePlaceholder(),
      fit: BoxFit.cover,
    );
  }
}

class RecommendPicture extends StatelessWidget {
  const RecommendPicture({
    Key? key,
    this.height = 100,
    this.width = 100,
    this.border,
    required this.imageUrl,
  }) : super(key: key);
  final double height, width;
  final Border? border;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(3),
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade50,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          placeholder: (context, url) => const ImagePlaceholder(),
          errorWidget: (context, url, error) => const ImagePlaceholder(),
        ),
      ),
    );
  }
}

class RecipientProfilePicture extends StatelessWidget {
  const RecipientProfilePicture({
    Key? key,
    this.height = 100,
    this.width = 100,
    this.border,
    required this.imageUrl,
  }) : super(key: key);
  final double height, width;
  final Border? border;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.all(3),
      height: height,
      width: width,
      decoration: BoxDecoration(
        //  border: border,
        shape: BoxShape.circle,
        color: Colors.grey.shade50,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => const ImagePlaceholder(),
          errorWidget: (context, url, error) => const ImagePlaceholder(),
        ),
      ),
    );
  }
}
