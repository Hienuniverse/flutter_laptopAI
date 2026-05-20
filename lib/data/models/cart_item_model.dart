import 'laptop_model.dart';

class CartItemModel {
  final LaptopModel laptop;
  int quantity;

  CartItemModel({
    required this.laptop,
    this.quantity = 1,
  });

  double get totalPrice {
    return laptop.price * quantity;
  }
}