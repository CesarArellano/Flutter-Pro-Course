import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/config/extensions/null_extensions.dart';
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
        child: const Icon(Icons.save_as_outlined),
        onPressed: () {},
      ),
    );
  }
}


class _ProductView extends StatelessWidget {

  final ProductState productState;

  const _ProductView({required this.productState});

  @override
  Widget build(BuildContext context) {
    final product = productState.product;

    final textStyles = Theme.of(context).textTheme;
    
    if( productState.isLoading ) {
      return const FullScreenLoader();
    }
    
    return ListView(
      children: [
    
          SizedBox(
            height: 250,
            width: 600,
            child: _ImageGallery(images: product!.images.value() ),
          ),
    
          const SizedBox( height: 10 ),
          Center(child: Text( product.title.value(), style: textStyles.titleSmall )),
          const SizedBox( height: 10 ),
          _ProductInformation( product: product ),
          
        ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

    

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
            initialValue: product.title.value(),
          ),
          CustomProductField( 
            isTopField: true,
            label: 'Slug',
            initialValue: product.slug.value(),
          ),
          CustomProductField( 
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: product.price.toString(),
          ),

          const SizedBox(height: 15 ),
          const Text('Extras'),

          _SizeSelector(selectedSizes: product.sizes.value() ),
          const SizedBox(height: 5 ),
          _GenderSelector( selectedGender: product.gender.value() ),
          

          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: product.stock.toString(),
          ),

          CustomProductField( 
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.description.value(),
          ),

          CustomProductField( 
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.value().join(', '),
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

  const _SizeSelector({required this.selectedSizes});


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
      selected: Set.from( selectedSizes ),
      onSelectionChanged: (newSelection) {
        print(newSelection);
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector({required this.selectedGender});


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
        onSelectionChanged: (newSelection) {
          print(newSelection);
        },
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