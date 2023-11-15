import 'package:flutter/material.dart';
import 'package:sqflite_demo/models/product.dart';

class ProductInfoWidget extends StatefulWidget {
  final Product? product;
  final ValueChanged<Product> onSubmit;

  const ProductInfoWidget({Key? key, this.product, required this.onSubmit})
      : super(key: key);

  @override
  State<ProductInfoWidget> createState() => _ProductInfoWidgetState();
}

class _ProductInfoWidgetState extends State<ProductInfoWidget> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _thumbnailUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return AlertDialog(
      title: Text(isEditing ? "Edit Product" : "Add Product"),
      content: Form(
        key: formKey,
        child: Column(children: [
          TextFormField(
            autofocus: true,
            controller: _titleController,
            decoration: const InputDecoration(hintText: "Title"),
            validator: (value) =>
                value != null && value.isEmpty ? "Title is required" : null,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(hintText: "Price"),
            validator: (value) =>
                value != null && value.isEmpty ? "Price is required" : null,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _thumbnailUrlController,
            decoration: const InputDecoration(hintText: "Thumbnail url"),
            validator: (value) =>
                value != null && value.isEmpty ? "Thumbnail is required" : null,
          ),
        ]),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.black45),
          ),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Product p = Product(
                title: _titleController.text,
                price: int.parse(_priceController.text),
                thumbnail: _thumbnailUrlController.text,
              );

              widget.onSubmit(p);
            }
          },
          child: const Text(
            "OK",
          ),
        ),
      ],
    );
  }
}
