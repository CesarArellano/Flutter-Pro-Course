import '../../../auth/domain/domain.dart';
import '../../../auth/infrastructured/infrastructured.dart';

class Product {
    final String? id;
    final String? title;
    final double? price;
    final String? description;
    final String? slug;
    final int? stock;
    final List<String>? sizes;
    final Gender? gender;
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

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        description: json["description"],
        slug: json["slug"],
        stock: json["stock"],
        sizes: json["sizes"] == null ? [] : List<String>.from(json["sizes"]!.map((x) => x)),
        gender: genderValues.map[json["gender"]]!,
        tags: json["tags"] == null ? [] : List<String>.from(json["tags"]!.map((x) => x)),
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        user: json["user"] == null ? null : UserMapper.userJsonToEntity(json["user"]),
    );
}

enum Gender { men, women, kid }

final genderValues = EnumValues({
    "kid": Gender.kid,
    "men": Gender.men,
    "women": Gender.women
});

enum Email { test1GoogleCom }

final emailValues = EnumValues({
    "test1@google.com": Email.test1GoogleCom
});

enum FullName { juanCarlos }

final fullNameValues = EnumValues({
    "Juan Carlos": FullName.juanCarlos
});

enum Role { admin }

final roleValues = EnumValues({
    "admin": Role.admin
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
