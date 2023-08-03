import '../../../../config/constants/environment.dart';
import '../../../auth/domain/domain.dart';
import '../../../auth/infrastructured/infrastructured.dart';

class Product {
    final String? id;
    final String? title;
    final num? price;
    final String? description;
    final String? slug;
    final int? stock;
    final List<String>? sizes;
    final String? gender;
    final List<String>? tags;
    final List<String>? images;
    final User? user;

    Product({
        this.id,
        this.title,
        this.price,
        this.description,
        this.slug,
        this.stock,
        this.sizes,
        this.gender,
        this.tags,
        this.images,
        this.user,
    });

    factory Product.fromJson(Map<String, dynamic> json, { bool searchByTerm = false }) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: json["sizes"] == null ? [] : List<String>.from(json["sizes"]!.map((x) => x)),
        gender: json["gender"],
        tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
        images: json["images"] == null 
          ? [] 
          : ( searchByTerm )
            ? List<String>.from(
              json['images'].map( 
                (image) => image['url'].startsWith('http')
                  ? image['url']
                  : '${ Environment.apiUrl }/files/product/${ image['url'] }',
              )
            )
            : List<String>.from(
              json['images'].map( 
                (image) => image.startsWith('http')
                  ? image
                  : '${ Environment.apiUrl }/files/product/$image',
              )
            ),
        user: json["user"] == null ? null : UserMapper.userJsonToEntity(json["user"]),
    );
}