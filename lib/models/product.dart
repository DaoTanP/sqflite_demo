class Product {
  final int? id;
  final String title;
  final int price;
  final String thumbnail;

  Product(
      {this.id,
      required this.title,
      required this.price,
      required this.thumbnail});

  factory Product.fromSqfliteDatabase(Map<String, dynamic> map) => Product(
        id: int.tryParse(map['id']) ?? 0,
        title: map['title'] ?? '',
        price: int.tryParse(map['price']) ?? 0,
        thumbnail: map['thumbnail'] ?? '',
      );
}
