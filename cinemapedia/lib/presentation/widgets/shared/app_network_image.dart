import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/helpers/image_cache_dimensions.dart';

/// Standard network image treatment used everywhere in the app: caches to
/// disk+memory, decodes only the pixels actually needed (via [cacheDimension]),
/// and shows a consistent placeholder/error state.
///
/// Cache sizing defaults to [width]/[height], which covers most call sites.
/// Pass [cacheWidth]/[cacheHeight] instead when [width]/[height] is
/// `double.infinity` (e.g. filling a parent that already has a fixed size) —
/// an infinite value can't be used to compute a cache size.
///
/// Only ever one of `memCacheWidth`/`memCacheHeight` is ever sent to
/// [CachedNetworkImage] (width preferred, height as a fallback when no usable
/// width is available) — passing both tells the decoder to resize the bitmap
/// to those *exact* pixel dimensions without preserving aspect ratio, which
/// stretches/squishes the image before [fit] ever gets to crop it. Do not
/// "fix" this by supplying both again.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final double? cacheWidth;
  final double? cacheHeight;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final resolvedCacheWidth = cacheWidth ?? width;
    final resolvedCacheHeight = cacheHeight ?? height;

    final cacheW = (resolvedCacheWidth == null || !resolvedCacheWidth.isFinite)
        ? null
        : cacheDimension(context, resolvedCacheWidth);
    final cacheH =
        (resolvedCacheHeight == null || !resolvedCacheHeight.isFinite)
        ? null
        : cacheDimension(context, resolvedCacheHeight);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: cacheW,
      memCacheHeight: cacheW == null ? cacheH : null,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => const ColoredBox(color: Colors.black12),
      errorWidget: (context, url, error) => Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
