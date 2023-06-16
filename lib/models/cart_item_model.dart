class CartItem {
  final String name;
  final double price;

  CartItem({required this.name, required this.price});
}

class CartModel {
  List<CartItem> cartItems = [];

  double get totalPrice {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void addToCart(CartItem item) {
    cartItems.add(item);
  }

  void removeFromCart(CartItem item) {
    cartItems.remove(item);
  }

  void clearCart() {
    cartItems.clear();
  }
}
