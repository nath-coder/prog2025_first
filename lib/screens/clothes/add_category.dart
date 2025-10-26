import 'package:flutter/material.dart';
import 'package:prog2025_firtst/database/category.dart';
import 'package:prog2025_firtst/models/category_dao.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CategoryDatabase? categoryDB;
  CategoryDao? categoryToEdit;
  bool isEditing = false;
  bool isLoading = false;

  // Íconos predefinidos para categorías
  final List<Map<String, dynamic>> predefinedCategories = [
    {'name': 'Dress', 'icon': Icons.checkroom, 'color': Color(0xFFE3F2FD)},
    {'name': 'T-Shirt', 'icon': Icons.checkroom, 'color': Color(0xFFF3E5F5)},
    {'name': 'Pants', 'icon': Icons.checkroom, 'color': Color(0xFFE8F5E8)},
    {'name': 'Shoes', 'icon': Icons.directions_run, 'color': Color(0xFFFFF3E0)},
    {'name': 'Hat', 'icon': Icons.emoji_emotions, 'color': Color(0xFFEDE7F6)},
    {'name': 'Watch', 'icon': Icons.watch, 'color': Color(0xFFE0F2F1)},
    {'name': 'Bag', 'icon': Icons.work, 'color': Color(0xFFFCE4EC)},
    {'name': 'Jacket', 'icon': Icons.dry_cleaning, 'color': Color(0xFFF1F8E9)},
    {'name': 'Skirt', 'icon': Icons.checkroom, 'color': Color(0xFFE1F5FE)},
    {'name': 'Accessories', 'icon': Icons.star, 'color': Color(0xFFFFF8E1)},
  ];

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    categoryDB = CategoryDatabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Obtener argumentos si se está editando
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is CategoryDao) {
      categoryToEdit = args;
      isEditing = true;
      _nameController.text = categoryToEdit!.nameCategory!;
      selectedCategory = categoryToEdit!.nameCategory!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        CategoryDao category = CategoryDao(
          idCategory: isEditing ? categoryToEdit!.idCategory : null,
          nameCategory: _nameController.text.trim(),
        );

        int result;
        if (isEditing) {
          result = await categoryDB!.UPDATE(category);
        } else {
          result = await categoryDB!.INSERT(category);
        }

        setState(() {
          isLoading = false;
        });

        if (result > 0) {
          _showSuccessDialog();
        } else {
          _showErrorSnackBar('Failed to save category');
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        _showErrorSnackBar('Error: ${e.toString()}');
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.green,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isEditing ? 'Category Updated!' : 'Category Added!',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isEditing 
                ? 'The category has been updated successfully.' 
                : 'New category has been added successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              Navigator.pop(context); // Volver a lista
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Column(
          children: [
            const SizedBox(height: 50),
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
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? "Edit Category 📝" : "Add Category 📂",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isEditing 
                            ? "Update your category information"
                            : "Create a new clothing category",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
      
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Campo de nombre
                      const Text(
                        "Category Name",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: "Enter category name",
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          filled: true,
                          fillColor: Colors.grey[50],
                          prefixIcon: Icon(
                            Icons.category_outlined,
                            color: Colors.grey[600],
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a category name';
                          }
                          if (value.trim().length < 2) {
                            return 'Category name must be at least 2 characters';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
      
                      // Categorías predefinidas
                      const Text(
                        "Quick Select",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choose from popular categories or create your own",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
      
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                        itemCount: predefinedCategories.length,
                        itemBuilder: (context, index) {
                          final category = predefinedCategories[index];
                          final isSelected = selectedCategory == category['name'];
      
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCategory = category['name'];
                                _nameController.text = category['name'];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? Colors.black 
                                  : category['color'],
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected 
                                    ? Colors.black 
                                    : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category['icon'],
                                    size: 28,
                                    color: isSelected 
                                      ? Colors.white 
                                      : Colors.black87,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected 
                                        ? Colors.white 
                                        : Colors.black87,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
      
            // Botón de guardar
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
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
                        isEditing ? 'Update Category' : 'Add Category',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}