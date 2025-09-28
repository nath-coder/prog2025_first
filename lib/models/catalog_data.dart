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
    image: 'https://img.freepik.com/foto-gratis/mujer-joven-vestido-verano-flores_144627-12172.jpg',
    rating: 4.6,
    category: 'Dress',
    sizes: ['S', 'M', 'L'],
    colors: ['Red', 'White', 'Blue'],
  ),
  Product(
    id: 'p2',
    title: 'Camisa Blanca Casual',
    price: 89.99,
    image: 'https://img.freepik.com/foto-gratis/retrato-mujer-joven-camisa-blanca_144627-12168.jpg',
    rating: 4.3,
    category: 'T-Shirt',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['White'],
  ),
  Product(
    id: 'p3',
    title: 'Conjunto Urbano',
    price: 149.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-moda-callejera-ropa-urbana_144627-12175.jpg',
    rating: 4.7,
    category: 'Streetwear',
    sizes: ['M', 'L'],
    colors: ['Black', 'Gray'],
  ),
  Product(
    id: 'p4',
    title: 'Vestido Negro Elegante',
    price: 249.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-elegante-vestido-negro_144627-12170.jpg',
    rating: 5.0,
    category: 'Dress',
    sizes: ['S', 'M', 'L'],
    colors: ['Black'],
  ),
  Product(
    id: 'p5',
    title: 'Sudadera Oversize',
    price: 119.99,
    image: 'https://img.freepik.com/foto-gratis/chica-joven-sudadera-oversize_144627-12174.jpg',
    rating: 4.5,
    category: 'Hoodie',
    sizes: ['M', 'L', 'XL'],
    colors: ['Gray', 'Beige'],
  ),
  Product(
    id: 'p6',
    title: 'Top Deportivo',
    price: 69.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-top-deportivo_144627-12173.jpg',
    rating: 4.2,
    category: 'Activewear',
    sizes: ['S', 'M'],
    colors: ['Black', 'Pink'],
  ),
  Product(
    id: 'p7',
    title: 'Chaqueta de Cuero',
    price: 299.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-chaqueta-cuero-negra_144627-12171.jpg',
    rating: 5.0,
    category: 'Jacket',
    sizes: ['M', 'L', 'XL'],
    colors: ['Black'],
  ),
  Product(
    id: 'p8',
    title: 'Vestido Corto Rojo',
    price: 159.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-vestido-rojo-corto_144627-12169.jpg',
    rating: 4.8,
    category: 'Dress',
    sizes: ['S', 'M'],
    colors: ['Red'],
  ),
  Product(
    id: 'p9',
    title: 'Look Bohemio',
    price: 189.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-look-bohemio-playa_144627-12176.jpg',
    rating: 4.9,
    category: 'Boho',
    sizes: ['S', 'M', 'L'],
    colors: ['White', 'Brown'],
  ),
  Product(
    id: 'p10',
    title: 'Camisa Estampada',
    price: 99.99,
    image: 'https://img.freepik.com/foto-gratis/mujer-camisa-estampada-colorida_144627-12177.jpg',
    rating: 4.4,
    category: 'T-Shirt',
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Multicolor'],
  ),
];
