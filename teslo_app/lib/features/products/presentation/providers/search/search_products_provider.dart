
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/product_repository_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Product>>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return SearchedMoviesNotifier(
    ref: ref,
    searchProducts: productRepository.searchProductByTerm 
  );
});


typedef SearchedProductsCallback = Future<List<Product>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Product>> {
  final Ref ref;
  final SearchedProductsCallback searchProducts;

  SearchedMoviesNotifier({
    required this.ref,
    required this.searchProducts
  }): super([]);
  
  Future<List<Product>> searchMoviesByQuery( String query ) async {
    final List<Product> products = await searchProducts(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = products;
    return products;
  }
}