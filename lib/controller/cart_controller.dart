// cart_controller.dart

import 'package:pku_online/models/cart_item_model.dart';

class CartController {
  final CartModel cartModel;

  CartController({required this.cartModel});

  void addToCart(String name, double price) {
    CartItem item = CartItem(name: name, price: price);
    cartModel.addToCart(item);
  }

  void removeFromCart(CartItem item) {
    cartModel.removeFromCart(item);
  }

  void clearCart() {
    cartModel.clearCart();
  }

  double calculateTotal() {
    return cartModel.totalPrice;
  }

  double calculateMedicineTotal(double price, int quantity) {
    return price * quantity;
  }
}
