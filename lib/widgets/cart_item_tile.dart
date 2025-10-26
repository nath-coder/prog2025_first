
import 'package:flutter/material.dart';
import 'package:prog2025_firtst/models/product_dao.dart';
import '../models/catalog_data.dart';

class CartItemTile extends StatelessWidget {
  final ProductDao product;
  final int qty;
  final String nameCategory;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const CartItemTile({
    super.key,
    required this.product,
    required this.qty,
    required this.nameCategory,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(product.image ?? '',
                      width: 80, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.titulo ?? 'Unknown Product',
                          style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                      Text(nameCategory,
                          style: TextStyle(
                              color: Colors.grey[600], fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("\$${product.price?.toStringAsFixed(2)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Column(
                  children: [
                    PopupMenuButton<String>(
                      offset: const Offset(0, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      icon: const Icon(Icons.more_horiz, color: Colors.black),
                      onSelected: (value) {
                        // Aquí se podrían manejar acciones específicas
                        debugPrint("Acción: $value para ${product.idProduct}");
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: onDelete,
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, size: 18),
                              SizedBox(width: 8),
                              Text('Eliminar'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(Icons.favorite_border, size: 18),
                              SizedBox(width: 8),
                              Text('Favorito'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'similar',
                          child: Row(
                            children: [
                              Icon(Icons.search, size: 18),
                              SizedBox(width: 8),
                              Text('Buscar similares'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: onDecrement,
                        ),
                        Text(qty.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: onIncrement,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[200]),
        ],
      ),
    );
  }
}
