import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/constants/shop_constants.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/core/utils/image_picker_helper.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_product_categories_cubit.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/product_dialogs.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/add_edit_product_form_content.dart';

class AddEditProductPage extends StatefulWidget {
  final String shopId;
  final ProductModel? product;
  final ShopProductsBloc productsBloc;

  const AddEditProductPage({
    super.key,
    required this.shopId,
    this.product,
    required this.productsBloc,
  });

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _descController = TextEditingController();
  final _stockController = TextEditingController();

  String _selectedCategory = 'Shirt';
  String _selectedSizeStandard = 'Shirt';
  final List<String> _selectedSizes = [];
  final List<String> _selectedColors = [];

  final List<dynamic> _images = [null, null, null];

  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    widget.productsBloc.add(LoadProductConfigEvent(widget.shopId));

    if (widget.product != null) {
      final p = widget.product!;
      _nameController.text = p.name;
      _priceController.text = p.originalPrice.toString();
      _offerPriceController.text = p.offerPrice?.toString() ?? '';
      _descController.text = p.description;
      _stockController.text = p.stockQuantity.toString();
      _selectedCategory = ShopConstants.defaultProductCategories.contains(p.category)
          ? p.category
          : ShopConstants.defaultProductCategories.first;
      _selectedSizeStandard = ShopConstants.defaultSizeStandards.contains(p.sizeStandard)
          ? p.sizeStandard
          : ShopConstants.defaultSizeStandards.first;
      _selectedSizes.addAll(p.sizes);
      _selectedColors.addAll(p.colors);

      for (int i = 0; i < p.images.length && i < 3; i++) {
        _images[i] = p.images[i];
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _descController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    try {
      final file = await ImagePickerHelper.pickImageFromGallery();
      if (file != null) {
        setState(() {
          _images[index] = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: ShopAppColors.error,
        ),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  void _onPublish() {
    if (_images[0] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Primary product image is mandatory.'),
          backgroundColor: ShopAppColors.error,
        ),
      );
      return;
    }

    if (_selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one size.'),
          backgroundColor: ShopAppColors.error,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isPublishing = true;
      });

      final double original = double.parse(_priceController.text);
      final double? offer = _offerPriceController.text.trim().isNotEmpty
          ? double.parse(_offerPriceController.text)
          : null;
      final int stock = int.parse(_stockController.text);

      if (widget.product == null) {
        // ADD
        final List<File> imageFiles = _images
            .where((img) => img is File)
            .cast<File>()
            .toList();

        final product = ProductModel(
          id: '',
          shopId: widget.shopId,
          name: _nameController.text.trim(),
          originalPrice: original,
          offerPrice: offer,
          description: _descController.text.trim(),
          stockQuantity: stock,
          category: _selectedCategory,
          sizeStandard: _selectedSizeStandard,
          sizes: _selectedSizes,
          colors: _selectedColors,
          images: const [],
          createdAt: DateTime.now(),
          salesCount: 0,
          isActive: stock > 0,
        );

        widget.productsBloc.add(AddProductEvent(product, imageFiles));
      } else {
        // UPDATE
        final List<dynamic> imagesOrFiles = _images
            .where((img) => img != null)
            .toList();

        final product = widget.product!.copyWith(
          name: _nameController.text.trim(),
          originalPrice: original,
          offerPrice: offer,
          description: _descController.text.trim(),
          stockQuantity: stock,
          category: _selectedCategory,
          sizeStandard: _selectedSizeStandard,
          sizes: _selectedSizes,
          colors: _selectedColors,
          isActive: stock > 0,
        );

        widget.productsBloc.add(UpdateProductEvent(product, imagesOrFiles));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.productsBloc),
        BlocProvider<ShopProductCategoriesCubit>(
          create: (context) => sl<ShopProductCategoriesCubit>()..loadCategories(),
        ),
      ],
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state is ShopProductsOperationSuccess) {
            setState(() {
              _isPublishing = false;
            });
            Navigator.pop(context);
          } else if (state is ShopProductsError) {
            setState(() {
              _isPublishing = false;
            });
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ShopAppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              widget.product == null ? 'Add Product' : 'Edit Product',
              style: ShopAppTextStyles.heading3,
            ),
            actions: [
              TextButton(
                onPressed: _isPublishing ? null : _onPublish,
                child: Text(
                  widget.product == null ? 'PUBLISH' : 'SAVE',
                  style: TextStyle(
                    color: ShopAppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: BlocBuilder<ShopProductsBloc, ShopProductsState>(
            builder: (context, state) {
              Map<String, dynamic> customConfig = {};
              if (state is ShopProductsLoaded) {
                customConfig = state.customConfig;
              }

              return BlocBuilder<ShopProductCategoriesCubit, ShopProductCategoriesState>(
                builder: (context, catState) {
                   List<String> dynamicCategories = List.from(ShopConstants.defaultProductCategories);
                  if (catState is ShopProductCategoriesLoaded) {
                    final loadedState = catState;
                    if (loadedState.categories.isNotEmpty) {
                      dynamicCategories = loadedState.categories;
                    }
                  }

                  // Ensure selected category is valid
                  if (!dynamicCategories.contains(_selectedCategory)) {
                    if (dynamicCategories.isNotEmpty) {
                      _selectedCategory = dynamicCategories.first;
                    }
                  }
                  if (widget.product != null &&
                      !dynamicCategories.contains(widget.product!.category)) {
                    dynamicCategories.add(widget.product!.category);
                  }

                  // Compile available sizes for standard
                  final availableSizes = <String>[];
                  availableSizes.addAll(
                    ShopConstants.defaultProductSizes[_selectedSizeStandard] ?? [],
                  );
                  if (customConfig['sizes'] != null &&
                      customConfig['sizes'][_selectedSizeStandard] != null) {
                    final List<dynamic> customList =
                        customConfig['sizes'][_selectedSizeStandard];
                    for (final customSize in customList) {
                      if (!availableSizes.contains(customSize.toString())) {
                        availableSizes.add(customSize.toString());
                      }
                    }
                  }

                  // Compile available colors
                  final availableColors = <String>[];
                  availableColors.addAll(ShopConstants.defaultProductColors);
                  if (customConfig['colors'] != null) {
                    final List<dynamic> customList = customConfig['colors'];
                    for (final customColor in customList) {
                      if (!availableColors.contains(customColor.toString())) {
                        availableColors.add(customColor.toString());
                      }
                    }
                  }

                  return AddEditProductFormContent(
                    formKey: _formKey,
                    nameController: _nameController,
                    priceController: _priceController,
                    offerPriceController: _offerPriceController,
                    descController: _descController,
                    stockController: _stockController,
                    images: _images,
                    selectedCategory: _selectedCategory,
                    categories: dynamicCategories,
                    selectedSizeStandard: _selectedSizeStandard,
                    sizeStandards: ShopConstants.defaultSizeStandards,
                    availableSizes: availableSizes,
                    selectedSizes: _selectedSizes,
                    availableColors: availableColors,
                    selectedColors: _selectedColors,
                    isPublishing: _isPublishing,
                    isEdit: widget.product != null,
                    onPickImage: _pickImage,
                    onRemoveImage: _removeImage,
                    onCategoryChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedCategory = val;
                        });
                      }
                    },
                    onSizeStandardChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSizeStandard = val;
                          _selectedSizes.clear();
                        });
                      }
                    },
                    onSizeChipSelected: (size, selected) {
                      setState(() {
                        if (selected) {
                          _selectedSizes.add(size);
                        } else {
                          _selectedSizes.remove(size);
                        }
                      });
                    },
                    onAddSizePressed: () => ProductDialogs.showAddSizeModal(
                      context: context,
                      selectedSizeStandard: _selectedSizeStandard,
                      shopId: widget.shopId,
                      productsBloc: widget.productsBloc,
                      onSizeAdded: (size) {
                        setState(() {
                          _selectedSizes.add(size);
                        });
                      },
                    ),
                    onColorChipSelected: (colorName, selected) {
                      setState(() {
                        if (selected) {
                          _selectedColors.add(colorName);
                        } else {
                          _selectedColors.remove(colorName);
                        }
                      });
                    },
                    onAddColorPressed: () => ProductDialogs.showAddColorModal(
                      context: context,
                      shopId: widget.shopId,
                      productsBloc: widget.productsBloc,
                      onColorAdded: (colorName) {
                        setState(() {
                          if (!_selectedColors.contains(colorName)) {
                            _selectedColors.add(colorName);
                          }
                        });
                      },
                    ),
                    onPublish: _onPublish,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

}
