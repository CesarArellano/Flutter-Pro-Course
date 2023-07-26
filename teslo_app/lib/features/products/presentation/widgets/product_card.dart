import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class ProductCard extends StatelessWidget {
  
  const ProductCard({
    Key? key,
    required this.product
  }) : super(key: key);
  
  final Product product;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            _ImageViewer(
              images: product.images ?? [],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                product.title ?? 'N/A',
                textAlign: TextAlign.center
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _ImageViewer extends StatelessWidget {
  final List<String> images;

  const _ImageViewer({
    required this.images
  });

  @override
  Widget build(BuildContext context) {
    if( images.isEmpty ) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: FadeInImage(
        fit: BoxFit.cover,
        height: 250,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 100),
        image: NetworkImage(images.first),
        placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
      ),
    );
  }
}