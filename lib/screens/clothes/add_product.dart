import 'package:flutter/material.dart';
import 'package:prog2025_firtst/database/product.dart';
import 'package:prog2025_firtst/database/product_detail.dart';
import 'package:prog2025_firtst/database/category.dart';
import 'package:prog2025_firtst/models/product_dao.dart';
import 'package:prog2025_firtst/models/productDetail_dao.dart';
import 'package:prog2025_firtst/models/category_dao.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _ratingController = TextEditingController();
  final _imageController = TextEditingController();

  ProductDatabase? productDB;
  ProductDetailDatabase? productDetailDB;
  CategoryDatabase? categoryDB;
  
  ProductDao? productToEdit;
  bool isEditing = false;
  bool isLoading = false;
  bool _hasLoadedProductData = false; // Nueva bandera para evitar recargas múltiples
  
  List<CategoryDao> categories = [];
  int? selectedCategoryId;
  
  // Lista de detalles del producto
  List<ProductDetailItem> productDetails = [];
  
  // Predefined options
  final List<String> availableColors = [
    'Red', 'Blue', 'Green', 'Yellow', 'Orange', 'Purple', 'Pink', 
    'Brown', 'Black', 'White', 'Gray', 'Navy', 'Maroon', 'Teal'
  ];
  
  final List<String> availableSizes = [
    'XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL',
    '28', '30', '32', '34', '36', '38', '40', '42'
  ];

  @override
  void initState() {
    super.initState();
    productDB = ProductDatabase();
    productDetailDB = ProductDetailDatabase();
    categoryDB = CategoryDatabase();
    _loadCategories();
    _ratingController.text = '0.0';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Solo cargar una vez para evitar recargas múltiples
    if (!_hasLoadedProductData) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is ProductDao) {
        productToEdit = args;
        isEditing = true;
        _hasLoadedProductData = true;
        _loadProductData();
      } else {
        productDetails = [];
        _hasLoadedProductData = true;
      }
    }
  }

  Future<void> _loadCategories() async {
    try {
      List<CategoryDao> cats = await categoryDB!.SELECT();
      setState(() {
        categories = cats;
        if (categories.isNotEmpty && selectedCategoryId == null) {
          selectedCategoryId = categories.first.idCategory;
        }
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  
  Future<void> _loadProductData() async {
    if (productToEdit != null) {
      _titleController.text = productToEdit!.titulo ?? '';
      _priceController.text = productToEdit!.price?.toString() ?? '';
      _ratingController.text = productToEdit!.puntuation?.toString() ?? '0.0';
      _imageController.text = productToEdit!.image ?? '';
      selectedCategoryId = productToEdit!.idCategory;
      
      // Load product details 
      try {
        List<ProductdetailDao> details = await productDetailDB!.SELECT_BY_PRODUCT(productToEdit!.idProduct!);
        setState(() {
          // Dispose controllers anteriores
          for (var detail in productDetails) {
            detail.dispose();
          }
          productDetails = details.map((detail) => ProductDetailItem.fromDao(detail)).toList();
        });
      } catch (e) {
        print('Error loading product details: $e');
      }
    }
  }
  void _addNewDetail() {
    setState(() {
      // Verificar que hay opciones disponibles antes de agregar
      if (availableColors.isNotEmpty && availableSizes.isNotEmpty) {
        productDetails.add(ProductDetailItem(
          color: availableColors.first,
          size: availableSizes.first,
          quantity: 0,
          imageDetail: '',
        ));
      }
    });
  }

  void _removeDetail(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text("Remove Variation"),
          ],
        ),
        content: const Text("Are you sure you want to remove this variation?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (isEditing && productDetails[index].idProductDetail != null) {
                // Delete from database if editing
                try {
                  await productDetailDB!.DELETE(productDetails[index].idProductDetail!);
                } catch (e) {
                  print('Error deleting detail: $e');
                }
              }
              // Dispose del controller antes de eliminar
              productDetails[index].dispose();
              setState(() {
                productDetails.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && productDetails.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        // Create or update product
        ProductDao product = ProductDao(
          idProduct: isEditing ? productToEdit!.idProduct : null,
          titulo: _titleController.text.trim(),
          idCategory: selectedCategoryId,
          puntuation: double.tryParse(_ratingController.text) ?? 0.0,
          price: double.tryParse(_priceController.text) ?? 0.0,
          image: _imageController.text.trim().isNotEmpty ? _imageController.text.trim() : null,
        );

        int productResult;
        int productId;

        if (isEditing) {
          productResult = await productDB!.UPDATE(product);
          productId = productToEdit!.idProduct!;
        } else {
          productResult = await productDB!.INSERT(product);
          productId = productResult;
        }

        if (productResult > 0) {
          // Save product details - CORREGIDO
          for (ProductDetailItem detail in productDetails) {
            ProductdetailDao detailDao = ProductdetailDao(
              idProductDetail: detail.idProductDetail, // IMPORTANTE: mantener el ID
              idProduct: productId,
              color: detail.color,
              size: detail.size,
              quantity: detail.quantity,
              imageDetail: detail.imageController.text.trim().isNotEmpty 
                  ? detail.imageController.text.trim() 
                  : null,
            );

            if (detail.idProductDetail != null) {
              // Update existing detail
              await productDetailDB!.UPDATE(detailDao, detail.idProductDetail!);
            } else {
              // Insert new detail
              await productDetailDB!.INSERT(detailDao);
            }
          }

          setState(() {
            isLoading = false;
          });
          _showSuccessDialog();
        } else {
          setState(() {
            isLoading = false;
          });
          _showErrorSnackBar('Failed to save product');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        print('Error saving product: $e');
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    } else if (productDetails.isEmpty) {
      _showErrorSnackBar('Please add at least one product variation');
    }
  }
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              isEditing ? 'Product Updated!' : 'Product Added!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              isEditing 
                ? 'The product has been updated successfully.' 
                : 'New product has been added successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _ratingController.dispose();
    _imageController.dispose();
    
    // Dispose de todos los controllers de detalles
    for (var detail in productDetails) {
      detail.dispose();
    }
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(Icons.arrow_back, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? "Edit Product 📝" : "Add Product 🛍️",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing 
                            ? "Update your product information"
                            : "Create a new product with variations",
                          style: const TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Information Section
                      _buildSectionHeader("Product Information", Icons.info_outline),
                      const SizedBox(height: 16),
                      
                      _buildTextField(
                        controller: _titleController,
                        label: "Product Title",
                        hint: "Enter product name",
                        icon: Icons.title,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a product title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Category Dropdown
                      _buildDropdownField(),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _priceController,
                              label: "Price",
                              hint: "0.00",
                              icon: Icons.attach_money,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a price';
                                }
                                if (double.tryParse(value) == null) {
                                  return 'Please enter a valid number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _ratingController,
                              label: "Rating",
                              hint: "0.0",
                              icon: Icons.star,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value != null && value.isNotEmpty) {
                                  double? rating = double.tryParse(value);
                                  if (rating == null || rating < 0 || rating > 5) {
                                    return 'Rating must be between 0-5';
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      _buildTextField(
                        controller: _imageController,
                        label: "Image URL (Optional)",
                        hint: "https://example.com/image.jpg",
                        icon: Icons.image,
                      ),
                      const SizedBox(height: 32),

                      // Product Variations Section
                      _buildSectionHeader("Product Variations", Icons.palette),
                      const SizedBox(height: 8),
                      Text(
                        "Add different colors and sizes for this product",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),

                      // Add variation button
                      Container(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _addNewDetail,
                          icon: const Icon(Icons.add),
                          label: const Text("Add Variation"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Product Details List
                      ...productDetails.asMap().entries.map((entry) {
                        int index = entry.key;
                        ProductDetailItem detail = entry.value;
                        return _buildDetailCard(detail, index);
                      }).toList(),

                      if (productDetails.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.inventory_2_outlined, 
                                   size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 12),
                              Text(
                                "No variations added yet",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Add colors, sizes and stock for this product",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),

            // Save Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEditing ? 'Update Product' : 'Add Product',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.black87),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedCategoryId,
              hint: const Text("Select Category"),
              isExpanded: true,
              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: category.idCategory,
                  child: Text(category.nameCategory ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategoryId = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailCard(ProductDetailItem detail, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Variation ${index + 1}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (detail.idProductDetail != null) // Mostrar si es existente
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Existing",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const Spacer(),
              IconButton(
                onPressed: () => _removeDetail(index),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: "Color",
                  value: detail.color,
                  items: availableColors,
                  onChanged: (value) {
                    // Cambiar directamente sin setState para evitar rebuilds innecesarios
                    detail.color = value!;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  label: "Size",
                  value: detail.size,
                  items: availableSizes,
                  onChanged: (value) {
                    // Cambiar directamente sin setState para evitar rebuilds innecesarios
                    detail.size = value!;
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildNumberField(
                  label: "Quantity",
                  value: detail.quantity.toString(),
                  onChanged: (value) {
                    detail.quantity = int.tryParse(value) ?? 0;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Image URL",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: detail.imageController, // Usar el controller específico
                      decoration: InputDecoration(
                        hintText: "Optional",
                        prefixIcon: Icon(Icons.image, color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first, // Verificar que el valor existe
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// Helper class for managing product details
class ProductDetailItem {
  int? idProductDetail;
  String color;
  String size;
  int quantity;
  String imageDetail;
  late final TextEditingController imageController;

  ProductDetailItem({
    this.idProductDetail,
    required this.color,
    required this.size,
    required this.quantity,
    required this.imageDetail,
  }) {
    imageController = TextEditingController(text: imageDetail);
  }

  factory ProductDetailItem.fromDao(ProductdetailDao dao) {
    return ProductDetailItem(
      idProductDetail: dao.idProductDetail,
      color: dao.color ?? 'Black', // Valor por defecto
      size: dao.size ?? 'M',       // Valor por defecto
      quantity: dao.quantity ?? 0,
      imageDetail: dao.imageDetail ?? '',
    );
  }

  void dispose() {
    imageController.dispose();
  }
}