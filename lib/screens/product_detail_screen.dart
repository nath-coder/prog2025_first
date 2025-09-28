import 'package:flutter/material.dart';
import '../models/catalog_data.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedSize = 'M';
  String selectedColor = 'Black';
  int quantity = 1;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F3),
  
      body: Stack(
        
        children: [
          Column(
            children: [
              Hero(
                
                tag: product.id,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 40,bottom: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    child: Image.network(
                      product.image,
                      height: 450,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: ListView(
                    padding: EdgeInsets.only(bottom: 100),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(product.title,
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove_circle_rounded),
                                onPressed: () => setState(() {
                                  if (quantity > 1) quantity--;
                                }),
                              ),
                              Text(quantity.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: Icon(Icons.add_circle_rounded, color: Colors.black),
                                onPressed: () => setState(() => quantity++),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon( Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(product.rating.toStringAsFixed(1), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                          SizedBox(width: 8),
                          Text("(7,932 reviews)", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Its simple and elegant shape makes it perfect for those of you who like you who want minimalist clothes.",
                        style: TextStyle(color: Colors.black87),
                      ),
                      Text("Read More...", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Tallas

                          Column(
                            children: [
                              Text("Choose size", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Row(
                                children: widget.product.sizes.map((size) {
                                  final isSelected = selectedSize == size;
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedSize = size),
                                    child: Container(
                                      margin: EdgeInsets.only(right: 8),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected ? Colors.black : Colors.grey[300],
                                      ),
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),

                          // Colores
                          Column(
                            children: [
                              Text("Color", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                              SizedBox(height: 8),
                              Row(
                                children: widget.product.colors.map((colorName) {
                                  final isSelected = selectedColor == colorName;
                              
                                  // Convertir nombre de color a Color real
                                  Color color;
                                  switch (colorName.toLowerCase()) {
                                    case 'black':
                                      color = Colors.black;
                                      break;
                                    case 'white':
                                      color = Colors.white;
                                      break;
                                    case 'gray':
                                      color = Colors.grey;
                                      break;
                                    case 'red':
                                      color = Colors.red;
                                      break;
                                    case 'blue':
                                      color = Colors.blue;
                                      break;
                                    case 'pink':
                                      color = Colors.pink;
                                      break;
                                    case 'brown':
                                      color = Colors.brown;
                                      break;
                                    case 'beige':
                                      color = Color(0xFFF5F5DC);
                                      break;
                                    case 'multicolor':
                                      color = Colors.deepPurpleAccent;
                                      break;
                                    default:
                                      color = Colors.grey;
                                  }
                              
                                  return GestureDetector(
                                    onTap: () => setState(() => selectedColor = colorName),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? Colors.black : Colors.transparent,
                                          width: 2,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: color,
                                        child: color == Colors.white
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(color: Colors.grey),
                                                ),
                                              )
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),

          // 🔙 Flecha de regreso y ❤️ botón de favorito
          Positioned(
            top: 50,
            left: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.black: Colors.black,
                ),
                onPressed: () => setState(() => isFavorite = !isFavorite),
              ),
            ),
          ),

          // 🛒 Botón flotante elevado
          Positioned(
            bottom: 50,
            left: 16,
            right: 16,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 16),
                elevation: 6,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product added to cart!'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black87,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Add to Cart | \$${(product.price * 0.53).toStringAsFixed(2)} (\$${product.price.toStringAsFixed(2)})',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  const _StarRow({required this.rating});

  @override
  Widget build(BuildContext context) {
    int full = rating.floor();
    return Row(
      children: List.generate(5, (i) {
        return Icon(
          i < full ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }
}
