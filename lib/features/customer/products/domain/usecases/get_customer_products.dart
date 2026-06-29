import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';

class GetCustomerProducts {
  final ICustomerProductsRepository repository;

  GetCustomerProducts({required this.repository});

  Future<CustomerProductsData> call() async {
    return await repository.getProductsData();
  }
}
