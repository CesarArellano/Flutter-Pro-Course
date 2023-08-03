import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';


typedef SearchProductsCallback = Future<List<Product>> Function(String term);
class ProductSearchDelegate extends SearchDelegate<Product?> {

  final SearchProductsCallback searchProducts;
  List<Product> initialProducts;

  StreamController<List<Product>> debouncedProducts = StreamController<List<Product>>.broadcast();
  StreamController<bool> isLoadingStream = StreamController<bool>.broadcast();

  Timer? _debounceTimer;

  ProductSearchDelegate({
    required this.searchProducts,
    this.initialProducts = const []
  }):super(
    searchFieldLabel: 'Search product',
    searchFieldStyle: const TextStyle(fontSize: 16)
  );

  Widget _buildSuggestionsAndResults() {
    if( query.isEmpty ) {
      return const EmptyContainer();
    }
    
    return StreamBuilder<List<Product>>(
      initialData: initialProducts,
      stream: debouncedProducts.stream,
      builder: ( _, AsyncSnapshot<List<Product>> asyncSnapshot) {
        if( !asyncSnapshot.hasData) {
          return const EmptyContainer();
        }
        final products = asyncSnapshot.data ?? [];

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, int i) => _ProductItem( 
            product: products[i],
            onProductSelected: (Product? product) {
              close(context, product);
              clearStreams();
            },
          )
        );
      }
    );

  }

  void clearStreams() {
    debouncedProducts.close();
    isLoadingStream.close();
  }

  void onQueryChanged(String query) {
    isLoadingStream.add(true);
    if( (_debounceTimer?.isActive) ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      
      final products = await searchProducts(query);
      initialProducts = products;
      debouncedProducts.add(products);
      isLoadingStream.add(false);
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder<bool>(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if( snapshot.hasData ) {
            return SpinPerfect(
              spins: 10,
              infinite: true,
              duration: const Duration(seconds: 20),
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_rounded),
                splashRadius: 22,
              ),
            );
          }
          
          return FadeIn(
            animate: query.isNotEmpty,
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon(Icons.clear),
              splashRadius: 22,
            ),
          );

        }
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
        clearStreams();
      }, 
      icon: const Icon( Icons.arrow_back ),
      splashRadius: 22,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    onQueryChanged(query);
    return _buildSuggestionsAndResults();
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSuggestionsAndResults();
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  final Function(Product? product) onProductSelected;

  const _ProductItem({
    Key? key,
    required this.product,
    required this.onProductSelected,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => onProductSelected(product),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/images/no-image.jpg'),
                  image: (product.images ?? []).isEmpty 
                    ? const AssetImage('assets/images/no-image.jpg')
                    : NetworkImage( product.images!.first ) as ImageProvider, 
                  width: 80,
                  fit: BoxFit.cover
                ),
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: SizedBox(
                width: size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title ?? 'N/A',
                      style: textStyles.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      product.description ?? 'N/A',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EmptyContainer extends StatelessWidget {
  const EmptyContainer({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Icon(
        Icons.production_quantity_limits,
        size: 130,
        color: Colors.black38,
      )
    );
  }
}