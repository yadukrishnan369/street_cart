import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/features/shop/products/data/models/product_model.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/add_edit_product_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_event.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_state.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/add_edit_product_form_content.dart';
import 'package:street_cart/features/shop/products/presentation/widgets/add_edit_product_app_bar.dart';
import 'package:street_cart/features/shop/products/presentation/utils/products_page_helper.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Add Edit Product Page
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

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _offerPriceController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
      text: p?.originalPrice.toString() ?? '',
    );
    _offerPriceController = TextEditingController(
      text: p?.offerPrice?.toString() ?? '',
    );
    _descController = TextEditingController(text: p?.description ?? '');

    widget.productsBloc.add(LoadProductConfigEvent(widget.shopId));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _offerPriceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // Publish Product
  void _onPublish(BuildContext context) {
    ProductsPageHelper.publishProduct(
      bloc: context.read<AddEditProductBloc>(),
      formKey: _formKey,
      shopId: widget.shopId,
      product: widget.product,
      productsBloc: widget.productsBloc,
      name: _nameController.text,
      price: _priceController.text,
      offerPrice: _offerPriceController.text,
      description: _descController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.productsBloc),
        BlocProvider<AddEditProductBloc>(
          create: (_) {
            final bloc = AddEditProductBloc();
            if (widget.product != null) {
              bloc.add(InitFromProductEvent(widget.product!));
            }
            return bloc;
          },
        ),
      ],
      child: BlocListener<ShopProductsBloc, ShopProductsState>(
        listener: (context, state) {
          if (state.status == ShopProductsStatus.operationSuccess) {
            context.read<AddEditProductBloc>().add(
              const SetPublishingEvent(false),
            );
            CustomSnackBar.show(
              context,
              message: state.successMessage ?? 'Operation successful',
            );
            Navigator.pop(context);
          } else if (state.status == ShopProductsStatus.error) {
            context.read<AddEditProductBloc>().add(
              SetErrorEvent(state.errorMessage ?? 'An error occurred'),
            );
          }
        },
        child: Scaffold(
          backgroundColor: ShopAppColors.background,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Builder(
              builder: (appBarCtx) => AddEditProductAppBar(
                isEdit: widget.product != null,
                onPublish: () => _onPublish(appBarCtx),
              ),
            ),
          ),
          body: BlocBuilder<ShopProductsBloc, ShopProductsState>(
            builder: (context, productsState) {
              if (productsState.status == ShopProductsStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              Map<String, dynamic> customConfig = {};
              if (productsState.status == ShopProductsStatus.loaded) {
                customConfig = productsState.customConfig;
                ProductsPageHelper.initAddEditDefaults(
                  bloc: context.read<AddEditProductBloc>(),
                  productsState: productsState,
                  product: widget.product,
                );
              }

              final dynamicCategories = ProductsPageHelper.getAddEditCategories(
                productsState,
                widget.product,
              );
              // Add Edit Product Form Content
              return AddEditProductFormContent(
                formKey: _formKey,
                nameController: _nameController,
                priceController: _priceController,
                offerPriceController: _offerPriceController,
                descController: _descController,
                categories: dynamicCategories,
                customConfig: customConfig,
                isEdit: widget.product != null,
                onPublish: () => _onPublish(context),
              );
            },
          ),
        ),
      ),
    );
  }
}
