import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/extensions/null_extensions.dart';
import 'package:teslo_shop/features/products/presentation/providers/forms/product_form_provider.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

import '../../../shared/presentation/widgets/widgets.dart';
import '../../domain/domain.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  Widget build( BuildContext context, WidgetRef ref ) {
    final productState = ref.watch(productProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            onPressed: (){},
          )
        ],
      ),
      body: _ProductView(
        productState: productState,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: !productState.isLoading
          ? () async {
            if( productState.product == null ) return;
            
            final resp = await ref.read(productFormProvider(productState.product!).notifier).onFormSubmit();
            
            if( context.mounted ) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();

              if( resp ) {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved successfully'))
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Something went wrong :('))
              );
            }
          }
          : null,
        child: const Icon(Icons.save_as_outlined)
      ),
    );
  }
}


class _ProductView extends ConsumerWidget {

  final ProductState productState;

  const _ProductView({required this.productState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    
    if( productState.isLoading ) {
      return const FullScreenLoader();
    }

    final productForm = ref.watch(productFormProvider( productState.product! ));
    
    return ListView(
      children: [
    
          SizedBox(
            height: 250,
            width: 600,
            child: _ImageGallery(images: productForm.images.value() ),
          ),
    
          const SizedBox( height: 10 ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productForm.title.value.value(),
                style: textStyles.titleSmall,
                textAlign: TextAlign.center,
              ),
            )
          ),
          const SizedBox( height: 10 ),
          _ProductInformation( product: productState.product! ),
          
        ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {
    final productForm = ref.watch(productFormProvider( product ));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: ref.read(productFormProvider(product).notifier).onTitleChanged,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField( 
            isTopField: true,
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: ref.read(productFormProvider(product).notifier).onSlugChanged,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField( 
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product).notifier).onPriceChanged(
              double.tryParse(value) ?? -1
            ),
            errorMessage: productForm.price.errorMessage,
          ),

          const SizedBox(height: 15 ),
          const Text('Extras'),

          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged: ref.read(productFormProvider(product).notifier).onSizeChanged,
          ),
          const SizedBox(height: 5 ),
          _GenderSelector(
            selectedGender: productForm.gender,
            onGenreChanged: ref.read(productFormProvider(product).notifier).onGenreChanged,
          ),
          

          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged: (value) => ref.read(productFormProvider(product).notifier).onStockChanged(
              int.tryParse(value) ?? -1,
            ),
            errorMessage: productForm.inStock.errorMessage,
          ),

          CustomProductField( 
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref.read(productFormProvider(product).notifier).onDescriptionChanged,
          ),

          CustomProductField( 
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.tags,
            onChanged: ref.read(productFormProvider(product).notifier).onTagsChanged,
          ),


          const SizedBox(height: 100 ),
        ],
      ),
    );
  }
}


class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];

  final Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector({
    required this.selectedSizes,
    required this.onSizesChanged
  });


  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size, 
          label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(), 
      selected: selectedSizes.isNotEmpty ? Set<String>.from( selectedSizes ) : <String>{},
      onSelectionChanged: (values) => onSizesChanged(values.toList()),
      multiSelectionEnabled: true,
      emptySelectionAllowed: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final void Function(String genre) onGenreChanged;
  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector({
    required this.selectedGender,
    required this.onGenreChanged
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon( genderIcons[ genders.indexOf(size) ] ),
            value: size, 
            label: Text(size, style: const TextStyle(fontSize: 12))
          );
        }).toList(), 
        selected: { selectedGender },
        onSelectionChanged: ( values ) => onGenreChanged(values.toList().first)
      ),
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.7
      ),
      children: images.isEmpty
        ? [ ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover )) 
        ]
        : images.map((e){
          return ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.network(e, fit: BoxFit.cover,),
          );
      }).toList(),
    );
  }
}