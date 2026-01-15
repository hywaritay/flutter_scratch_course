import 'package:flutter/material.dart';
import 'package:flutter_scratch_course/core/theme/app_colors.dart';

class Product {
  final String id;
  final String name;
  final String image;
  final double price;
  final String description;
  final double rating;
  final int reviews;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Wireless Headphones',
      image: 'assets/images/headphones.png',
      price: 99.99,
      description: 'High-quality wireless headphones with noise cancellation',
      rating: 4.5,
      reviews: 128,
    ),
    Product(
      id: '2',
      name: 'Smart Watch',
      image: 'assets/images/smartwatch.png',
      price: 199.99,
      description: 'Fitness tracking smartwatch with heart rate monitor',
      rating: 4.2,
      reviews: 89,
    ),
    Product(
      id: '3',
      name: 'Laptop Stand',
      image: 'assets/images/laptopstand.png',
      price: 29.99,
      description: 'Adjustable aluminum laptop stand for better ergonomics',
      rating: 4.7,
      reviews: 256,
    ),
    Product(
      id: '4',
      name: 'Bluetooth Speaker',
      image: 'assets/images/bluetoothspeaker.png',
      price: 49.99,
      description: 'Portable Bluetooth speaker with 12-hour battery life',
      rating: 4.3,
      reviews: 167,
    ),
  ];

  final List<CartItem> _cart = [];
  bool _showCart = false;

  void _addToCart(Product product) {
    final existingItem = _cart
        .where((item) => item.product.id == product.id)
        .toList();
    if (existingItem.isNotEmpty) {
      existingItem[0].quantity++;
    } else {
      _cart.add(CartItem(product: product));
    }
    setState(() {});
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${product.name} added to cart')));
  }

  void _removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    setState(() {});
  }

  void _updateQuantity(String productId, int quantity) {
    final item = _cart.where((item) => item.product.id == productId).toList();
    if (item.isNotEmpty) {
      if (quantity <= 0) {
        _removeFromCart(productId);
      } else {
        item[0].quantity = quantity;
        setState(() {});
      }
    }
  }

  double _getTotalPrice() {
    return _cart.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void _checkout() {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit Card'),
              onTap: () => _processPayment('Credit Card'),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('PayPal'),
              onTap: () => _processPayment('PayPal'),
            ),
            ListTile(
              leading: const Icon(Icons.money),
              title: const Text('Cash on Delivery'),
              onTap: () => _processPayment('Cash on Delivery'),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(String method) {
    Navigator.of(context).pop(); // Close payment dialog

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Payment Successful'),
        content: Text(
          'Your payment of \$${(_getTotalPrice()).toStringAsFixed(2)} via $method has been submitted successfully!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _cart.clear();
                _showCart = false;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart),
                if (_cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        _cart.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => setState(() => _showCart = !_showCart),
          ),
        ],
      ),
      body: _showCart ? _buildCartView() : _buildProductGrid(),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return Card(
          elevation: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Set a fixed height for the image area to prevent overflow
              Container(
                height: 100,
                color: Colors.grey[200],
                width: double.infinity,
                child: Center(
                  child: Image.asset(product.image,fit: BoxFit.contain,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(
                          '${product.rating} (${product.reviews})',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        child: const Text('Add to Cart'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCartView() {
    if (_cart.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cart.length,
            itemBuilder: (context, index) {
              final item = _cart[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('\$${item.product.price.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateQuantity(
                              item.product.id,
                              item.quantity - 1,
                            ),
                            icon: const Icon(Icons.remove),
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            onPressed: () => _updateQuantity(
                              item.product.id,
                              item.quantity + 1,
                            ),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => _removeFromCart(item.product.id),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
