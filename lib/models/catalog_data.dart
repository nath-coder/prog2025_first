class Product {
  final String id;
  final String title;
  final double price;
  final String image;
  final double rating;
  final String category;
  final List<String> sizes;
  final List<String> colors;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.rating,
    required this.category,
    required this.sizes,
    required this.colors,
  });
}

final List<Product> demoProducts = [
  Product(
    id: 'p1',
    title: 'Vestido Floral Largo',
    price: 179.99,
    image: 'https://http2.mlstatic.com/D_NQ_NP_630721-MLM85422037497_052025-O-conjunto-de-moda-elegante-casual-de-dos-pcs-ropa-para-mujer.webp',
    rating: 4.6,
    category: 'Dress',
    sizes: ['S', 'M', 'L'],
    colors: ['Red', 'White', 'Blue'],
  ),
  Product(
    id: 'p2',
    title: 'Camisa Blanca Casual',
    price: 89.99,
    image: 'https://i5.walmartimages.com/asr/961f0011-886b-452b-9862-bc5e45457c2b.aa2b61464c85978197014e12886e0b95.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF',
    rating: 4.3,
    category: 'T-Shirt',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['White'],
  ),
  Product(
    id: 'p3',
    title: 'Conjunto Urbano',
    price: 149.99,
    image: 'https://img.kwcdn.com/product/fancy/143cbb73-b2d2-46b4-8913-7943b3d00f9b.jpg?imageMogr2/auto-orient%7CimageView2/2/w/800/q/70/format/webp',
    rating: 4.7,
    category: 'Streetwear',
    sizes: ['M', 'L'],
    colors: ['Black', 'Gray'],
  ),
  Product(
    id: 'p4',
    title: 'Vestido Negro Elegante',
    price: 249.99,
    image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSjRvrPG-J9NvZWfpyhMfo94FOaVZrAleHwsg&s',
    rating: 5.0,
    category: 'Dress',
    sizes: ['S', 'M', 'L'],
    colors: ['Black'],
  ),
  Product(
    id: 'p5',
    title: 'Sudadera Oversize',
    price: 119.99,
    image: 'https://www.comfortjeans.com.mx/cdn/shop/files/IMG_8444.jpg?v=1708707500',
    rating: 4.5,
    category: 'Hoodie',
    sizes: ['M', 'L', 'XL'],
    colors: ['Gray', 'Beige'],
  ),
  Product(
    id: 'p6',
    title: 'Top Deportivo',
    price: 69.99,
    image: 'https://inrise.mx/cdn/shop/articles/Diseno_sin_titulo_88.png?v=1713376822&width=1100',
    rating: 4.2,
    category: 'Activewear',
    sizes: ['S', 'M'],
    colors: ['Black', 'Pink'],
  ),
  Product(
    id: 'p7',
    title: 'Chaqueta de Cuero',
    price: 299.99,
    image: 'https://hips.hearstapps.com/hmg-prod/images/chaquetas-cuero-tendencia-otono-2024-elle-67064a4b99c52.jpg',
    rating: 5.0,
    category: 'Jacket',
    sizes: ['M', 'L', 'XL'],
    colors: ['Black'],
  ),
  Product(
    id: 'p8',
    title: 'Vestido Corto Rojo',
    price: 159.99,
    image: 'https://i5.walmartimages.com/asr/f345d046-ddcd-466a-831f-2723c5369b19.20f247e1a9f354f6442fef5355d7ef30.jpeg?odnHeight=612&odnWidth=612&odnBg=FFFFFF',
    rating: 4.8,
    category: 'Dress',
    sizes: ['S', 'M'],
    colors: ['Red'],
  ),
  Product(
    id: 'p9',
    title: 'Look Bohemio',
    price: 189.99,
    image: 'https://www.chio-lecca.edu.pe/cdn/shop/articles/chio-lecca-blog-estilo-boho.jpg?v=1701712637',
    rating: 4.9,
    category: 'Boho',
    sizes: ['S', 'M', 'L'],
    colors: ['White', 'Brown'],
  ),
  Product(
    id: 'p10',
    title: 'Camisa Estampada',
    price: 99.99,
    image: 'https://i.pinimg.com/736x/51/0b/22/510b22e387e6d7d9fc95955a13e764dc.jpg',
    rating: 4.4,
    category: 'T-Shirt',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Multicolor'],
  ),
];
