import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/search/search_products_provider.dart';
import 'package:teslo_shop/features/products/presentation/search/product_search_delegate.dart';
import 'package:teslo_shop/features/products/presentation/widgets/widgets.dart';

import '../../../shared/shared.dart';
import '../providers/products_provider.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              showSearch<Product?>(
                context: context,
                query: ref.read(searchQueryProvider),
                delegate: ProductSearchDelegate(
                  searchProducts: ref.read(searchedMoviesProvider.notifier).searchMoviesByQuery,
                  initialProducts: ref.read(searchedMoviesProvider)
                )
              ).then((product) {
                if( product == null ) return;
                context.push('/product/${ product.id }');
              });
            }, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends ConsumerState<_ProductsView> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {

    scrollController.addListener(() {
      final position = scrollController.position;

      if( ( position.pixels + 400 ) >= position.maxScrollExtent ) {
        ref.read(productsProvider.notifier).loadNextPage();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);

    if( productsState.products.isEmpty ) {
      return const Center(
        child: Text('No products'),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 25,
        itemCount: productsState.products.length,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(
            onTap: () => context.push('/product/${ product.id }'),
            child: ProductCard(
              product: product
            ),
          );
        },
      ),
    );
  }
}