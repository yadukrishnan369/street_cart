import 'package:get_it/get_it.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/send_customer_notification.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/send_shop_notification.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/send_admin_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:street_cart/core/utils/delivery_validator.dart';

// CORE
import 'package:street_cart/core/network/network_info.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'package:street_cart/core/services/communication_service.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/core/services/app_info_service.dart';
import 'package:street_cart/core/firebase/firebase_auth_service.dart';

// CUSTOMER - AUTH
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource.dart';
import 'package:street_cart/features/customer/auth/data/datasource/auth_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/auth/data/repositories/auth_repository_impl.dart';
import 'package:street_cart/features/customer/auth/domain/repositories/i_auth_repository.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/delete_account.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/login.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_up.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/sign_in_with_google.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/logout.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_password_reset_email.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/get_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/get_customer_data.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/update_customer_profile.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/change_password.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_password_user.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/send_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/check_email_verification.dart';
import 'package:street_cart/features/customer/auth/domain/usecases/finalize_sign_up.dart';
import 'package:street_cart/features/customer/auth/presentation/bloc/auth_bloc.dart';

// CUSTOMER - HOME
import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource.dart';
import 'package:street_cart/features/customer/home/data/datasources/home_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/home/data/repositories/home_repository_impl.dart';
import 'package:street_cart/features/customer/home/domain/repositories/i_home_repository.dart';
import 'package:street_cart/features/customer/home/domain/usecases/get_home_data.dart';
import 'package:street_cart/features/customer/home/presentation/bloc/home_bloc.dart';

// CUSTOMER - CART
import 'package:street_cart/features/customer/cart/data/datasources/cart_remote_datasource.dart';
import 'package:street_cart/features/customer/cart/data/datasources/cart_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/cart/data/repositories/cart_repository_impl.dart';
import 'package:street_cart/features/customer/cart/domain/repositories/i_cart_repository.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/add_to_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/remove_from_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/update_cart_quantity.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/clear_cart.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_product_by_id.dart';
import 'package:street_cart/features/customer/cart/domain/usecases/get_shop_by_id.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/checkout_bloc.dart';
import 'package:street_cart/features/customer/notification/data/datasources/customer_notification_datasource_impl.dart';
import 'package:street_cart/features/customer/notification/data/datasources/i_customer_notification_datasource.dart';

// CUSTOMER - PRODUCTS
import 'package:street_cart/features/customer/products/data/datasources/customer_products_remote_datasource.dart';
import 'package:street_cart/features/customer/products/data/datasources/customer_products_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/products/data/repositories/customer_products_repository_impl.dart';
import 'package:street_cart/features/customer/products/domain/repositories/i_customer_products_repository.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_customer_products.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/customer_products_bloc.dart';
import 'package:street_cart/features/customer/products/domain/usecases/add_to_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/remove_from_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/get_wishlist.dart';
import 'package:street_cart/features/customer/products/domain/usecases/clear_wishlist.dart';
import 'package:street_cart/features/customer/products/presentation/bloc/wishlist_bloc.dart';

// CUSTOMER - SHOPS
import 'package:street_cart/features/customer/shops/data/datasources/customer_shops_remote_datasource.dart';
import 'package:street_cart/features/customer/shops/data/datasources/customer_shops_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/shops/data/repositories/customer_shops_repository_impl.dart';
import 'package:street_cart/features/customer/shops/domain/repositories/i_customer_shops_repository.dart';
import 'package:street_cart/features/customer/shops/domain/usecases/get_nearby_shops.dart';
import 'package:street_cart/features/customer/shops/domain/usecases/get_customer_shop_products.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/customer_shops_bloc.dart';
import 'package:street_cart/features/customer/shops/presentation/bloc/shop_details_bloc.dart';

// CUSTOMER - PROFILE
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource.dart';
import 'package:street_cart/features/customer/profile/data/datasources/profile_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/profile/data/repositories/profile_repository_impl.dart';
import 'package:street_cart/features/customer/profile/domain/repositories/i_profile_repository.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_profile_data.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/upload_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/remove_profile_image.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/get_addresses.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/add_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/update_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/delete_address.dart';
import 'package:street_cart/features/customer/profile/domain/usecases/set_default_address.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/profile_bloc.dart';
import 'package:street_cart/features/customer/profile/presentation/bloc/address_bloc.dart';

// CUSTOMER - REVIEW
import 'package:street_cart/features/customer/review/data/datasources/review_remote_datasource.dart';
import 'package:street_cart/features/customer/review/data/datasources/review_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/review/data/repositories/review_repository_impl.dart';
import 'package:street_cart/features/customer/review/domain/repositories/i_review_repository.dart';
import 'package:street_cart/features/customer/review/domain/usecases/submit_review.dart';
import 'package:street_cart/features/customer/review/domain/usecases/get_product_reviews.dart';
import 'package:street_cart/features/customer/review/domain/usecases/delete_review.dart';
import 'package:street_cart/features/customer/review/presentation/bloc/review_bloc.dart';
// CUSTOMER - PAYMENT
import 'package:street_cart/core/services/razorpay_service.dart';
import 'package:street_cart/features/customer/payment/data/datasources/payment_remote_datasource.dart';
import 'package:street_cart/features/customer/payment/data/datasources/payment_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/payment/data/repositories/payment_repository_impl.dart';
import 'package:street_cart/features/customer/payment/domain/repositories/i_payment_repository.dart';
import 'package:street_cart/features/customer/payment/domain/usecases/place_customer_order.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_bloc.dart';

// CUSTOMER - SETTINGS
import 'package:street_cart/features/customer/settings/data/datasources/settings_local_datasource.dart';
import 'package:street_cart/features/customer/settings/data/repositories/settings_repository_impl.dart';
import 'package:street_cart/features/customer/settings/domain/repositories/settings_repository.dart';
import 'package:street_cart/features/customer/settings/data/datasources/settings_remote_datasource.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_customer_notification_preferences.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/save_customer_notification_preference.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/get_shop_notification_preferences.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/save_shop_notification_preference.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/get_settings.dart';
import 'package:street_cart/features/customer/settings/domain/usecases/update_setting.dart';
import 'package:street_cart/features/customer/settings/presentation/bloc/settings_bloc.dart';
import 'package:street_cart/core/theme/customer/theme_cubit.dart';
import 'package:street_cart/core/theme/shop/shop_theme_cubit.dart';
import 'package:street_cart/core/theme/admin/admin_theme_cubit.dart';

// CUSTOMER - LOCATION
import 'package:street_cart/features/customer/location/data/datasource/location_datasource.dart';
import 'package:street_cart/features/customer/location/data/datasource/location_datasource_impl.dart';
import 'package:street_cart/features/customer/location/data/repositories/location_repository_impl.dart';
import 'package:street_cart/features/customer/location/domain/repositories/i_location_repository.dart';
import 'package:street_cart/features/customer/location/domain/usecases/request_location_and_save.dart';
import 'package:street_cart/features/customer/location/presentation/bloc/location_bloc.dart';

// CUSTOMER - ONBOARDING
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource.dart';
import 'package:street_cart/features/customer/onboarding/data/datasource/onboarding_local_datasource_impl.dart';
import 'package:street_cart/features/customer/onboarding/domain/repositories/i_onboarding_repository.dart';
import 'package:street_cart/features/customer/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:street_cart/features/customer/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:street_cart/features/customer/onboarding/presentation/bloc/onboarding_bloc.dart';

// CUSTOMER - SPLASH
import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_local_datasource_impl.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource.dart';
import 'package:street_cart/features/customer/splash/data/datasources/splash_remote_datasource_impl.dart';
import 'package:street_cart/features/customer/splash/domain/repositories/i_splash_repository.dart';
import 'package:street_cart/features/customer/splash/data/repositories/splash_repository_impl.dart';
import 'package:street_cart/features/customer/splash/domain/usecases/check_app_status.dart';
import 'package:street_cart/features/customer/splash/presentation/bloc/splash_bloc.dart';

// SHOP - AUTH
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource.dart';
import 'package:street_cart/features/shop/auth/data/datasource/shop_auth_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/auth/data/repositories/shop_auth_repository_impl.dart';
import 'package:street_cart/features/shop/auth/domain/repositories/i_shop_auth_repository.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_login.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_signup.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/setup_shop_profile.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_status.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/shop_logout.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_password_reset_email.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/send_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/check_shop_email_verification.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/finalize_shop_sign_up.dart';
import 'package:street_cart/features/shop/auth/presentation/bloc/shop_auth_bloc.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_business_categories.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_product_categories.dart';
import 'package:street_cart/features/shop/auth/domain/usecases/get_shop_payment_settings.dart';
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource_impl.dart';
import 'package:street_cart/features/shop/notification/data/datasources/i_shop_notification_datasource.dart';
import 'package:street_cart/features/shop/notification/data/datasources/shop_notification_datasource_impl.dart';

// SHOP - SETTINGS
import 'package:street_cart/features/shop/settings/data/datasources/shop_settings_local_datasource.dart';
import 'package:street_cart/features/shop/settings/domain/repositories/i_shop_settings_repository.dart';
import 'package:street_cart/features/shop/settings/data/repositories/shop_settings_repository_impl.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/change_shop_password.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/delete_shop_auth_account.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/get_shop_local_settings.dart';
import 'package:street_cart/features/shop/settings/domain/usecases/update_shop_local_setting.dart';
import 'package:street_cart/features/shop/settings/presentation/bloc/shop_settings_bloc.dart';

// SHOP - ONBOARDING
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource.dart';
import 'package:street_cart/features/shop/onboarding/data/datasource/shop_onboarding_local_datasource_impl.dart';
import 'package:street_cart/features/shop/onboarding/domain/repositories/i_shop_onboarding_repository.dart';
import 'package:street_cart/features/shop/onboarding/data/repositories/shop_onboarding_repository_impl.dart';
import 'package:street_cart/features/shop/onboarding/domain/usecases/complete_shop_onboarding.dart';
import 'package:street_cart/features/shop/onboarding/presentation/bloc/shop_onboarding_bloc.dart';

// SHOP - HOME
import 'package:street_cart/features/shop/home/data/datasource/shop_home_local_datasource.dart';
import 'package:street_cart/features/shop/home/domain/repositories/i_shop_home_repository.dart';
import 'package:street_cart/features/shop/home/data/repositories/shop_home_repository_impl.dart';
import 'package:street_cart/features/shop/home/domain/usecases/check_first_home_visit.dart';
import 'package:street_cart/features/shop/home/domain/usecases/complete_first_home_visit.dart';
import 'package:street_cart/features/shop/home/domain/usecases/get_shop_dashboard_orders.dart';
import 'package:street_cart/features/shop/home/presentation/bloc/shop_home_bloc.dart';

// SHOP - SPLASH
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_local_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource.dart';
import 'package:street_cart/features/shop/splash/data/datasources/shop_splash_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/splash/data/repositories/shop_splash_repository_impl.dart';
import 'package:street_cart/features/shop/splash/domain/repositories/i_shop_splash_repository.dart';
import 'package:street_cart/features/shop/splash/domain/usecases/check_shop_app_status.dart';
import 'package:street_cart/features/shop/splash/presentation/bloc/shop_splash_bloc.dart';

// SHOP - LOCATION
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource.dart';
import 'package:street_cart/features/shop/location/data/datasource/shop_location_datasource_impl.dart';
import 'package:street_cart/features/shop/location/data/repositories/shop_location_repository_impl.dart';
import 'package:street_cart/features/shop/location/domain/repositories/i_shop_location_repository.dart';
import 'package:street_cart/features/shop/location/domain/usecases/request_shop_location_and_save.dart';
import 'package:street_cart/features/shop/location/presentation/bloc/shop_location_bloc.dart';

// SHOP - PROFILE
import 'package:street_cart/features/shop/profile/data/datasources/shop_profile_remote_datasource.dart';
import 'package:street_cart/features/shop/profile/data/datasources/shop_profile_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/profile/data/repositories/shop_profile_repository_impl.dart';
import 'package:street_cart/features/shop/profile/domain/repositories/i_shop_profile_repository.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/get_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/update_shop_profile_data.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/upload_shop_profile_image.dart';
import 'package:street_cart/features/shop/profile/domain/usecases/remove_shop_profile_image.dart';
import 'package:street_cart/features/shop/profile/presentation/bloc/shop_profile_bloc.dart';

// SHOP - PRODUCTS
import 'package:street_cart/features/shop/products/data/datasources/shop_products_remote_datasource.dart';
import 'package:street_cart/features/shop/products/data/datasources/shop_products_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/products/data/repositories/shop_products_repository_impl.dart';
import 'package:street_cart/features/shop/products/domain/repositories/i_shop_products_repository.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_products.dart';
import 'package:street_cart/features/shop/products/domain/usecases/add_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/update_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/delete_product.dart';
import 'package:street_cart/features/shop/products/domain/usecases/get_shop_product_config.dart';
import 'package:street_cart/features/shop/products/domain/usecases/save_shop_product_config.dart';
import 'package:street_cart/features/shop/products/presentation/bloc/shop_products_bloc.dart';

// SHOP - ORDERS
import 'package:street_cart/features/shop/orders/data/datasources/i_shop_orders_remote_datasource.dart';
import 'package:street_cart/features/shop/orders/data/datasources/shop_orders_remote_datasource.dart';
import 'package:street_cart/features/shop/orders/data/repositories/shop_orders_repository_impl.dart';
import 'package:street_cart/features/shop/orders/domain/repositories/i_shop_orders_repository.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/get_shop_orders.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_status.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/update_shop_order_return_status.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/process_refund.dart';
import 'package:street_cart/features/shop/orders/domain/usecases/check_products_status.dart';
import 'package:street_cart/features/shop/orders/presentation/bloc/shop_orders_bloc.dart';

// CUSTOMER - ORDERS
import 'package:street_cart/features/customer/orders/data/datasources/i_orders_remote_datasource.dart';
import 'package:street_cart/features/customer/orders/data/datasources/orders_remote_datasource.dart';
import 'package:street_cart/features/customer/orders/data/repositories/orders_repository_impl.dart';
import 'package:street_cart/features/customer/orders/domain/repositories/i_orders_repository.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/get_customer_orders.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/cancel_order_item.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/update_order_address.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/submit_return_request.dart';
import 'package:street_cart/features/customer/orders/domain/usecases/check_products_availability.dart';
import 'package:street_cart/features/customer/orders/presentation/bloc/orders_bloc.dart';

// ADMIN
import 'package:street_cart/core/services/notification_service.dart';
import 'package:street_cart/features/customer/notification/domain/repositories/i_customer_notifications_repository.dart';
import 'package:street_cart/features/customer/notification/data/repositories/customer_notifications_repository_impl.dart';
import 'package:street_cart/features/customer/notification/presentation/bloc/customer_notifications_bloc.dart';
import 'package:street_cart/features/shop/notification/domain/repositories/i_shop_notifications_repository.dart';
import 'package:street_cart/features/shop/notification/data/repositories/shop_notifications_repository_impl.dart';
import 'package:street_cart/features/shop/notification/presentation/bloc/shop_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/domain/repositories/i_admin_notifications_repository.dart';
import 'package:street_cart/features/admin/notification/data/repositories/admin_notifications_repository_impl.dart';
import 'package:street_cart/features/admin/notification/data/datasources/i_admin_notification_datasource.dart';
import 'package:street_cart/features/admin/notification/data/datasources/admin_notification_datasource_impl.dart';
import 'package:street_cart/features/admin/notification/presentation/bloc/admin_notifications_bloc.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/watch_admin_notifications.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/mark_admin_notification_as_read.dart';
import 'package:street_cart/features/admin/notification/domain/usecases/mark_all_admin_notifications_as_read.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/watch_shop_notifications.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/mark_shop_notification_as_read.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/mark_all_shop_notifications_as_read.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/delete_shop_notification.dart';
import 'package:street_cart/features/shop/notification/domain/usecases/get_shop_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/watch_customer_notifications.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/mark_customer_notification_as_read.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/mark_all_customer_notifications_as_read.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_order_details.dart';
import 'package:street_cart/features/customer/notification/domain/usecases/get_customer_product_details.dart';
import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource.dart';
import 'package:street_cart/features/admin/auth/data/datasource/admin_auth_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/auth/domain/repositories/i_admin_auth_repository.dart';
import 'package:street_cart/features/admin/auth/data/repositories/admin_auth_repository_impl.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_login.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/check_admin_session.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/admin_logout.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/send_admin_password_reset.dart';
import 'package:street_cart/features/admin/auth/domain/usecases/confirm_admin_password_reset.dart';
import 'package:street_cart/features/admin/auth/presentation/bloc/admin_auth_bloc.dart';

// ADMIN - SPLASH
import 'package:street_cart/features/admin/splash/domain/repositories/i_admin_splash_repository.dart';
import 'package:street_cart/features/admin/splash/data/repositories/admin_splash_repository_impl.dart';
import 'package:street_cart/features/admin/splash/domain/usecases/check_admin_splash_session.dart';
import 'package:street_cart/features/admin/splash/presentation/bloc/admin_splash_bloc.dart';

// ADMIN - DASHBOARD
import 'package:street_cart/features/admin/dashboard/data/datasources/admin_dashboard_remote_datasource.dart';
import 'package:street_cart/features/admin/dashboard/data/datasources/admin_dashboard_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/dashboard/domain/repositories/i_admin_dashboard_repository.dart';
import 'package:street_cart/features/admin/dashboard/data/repositories/admin_dashboard_repository_impl.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_pending_registrations_count.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registrations_bloc.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/get_shop_details.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/approve_shop.dart';
import 'package:street_cart/features/admin/dashboard/domain/usecases/reject_shop.dart';
import 'package:street_cart/features/admin/dashboard/presentation/bloc/admin_registration_details_bloc.dart';

// ADMIN - SETTINGS
import 'package:street_cart/features/admin/settings/data/datasources/admin_settings_remote_datasource.dart';
import 'package:street_cart/features/admin/settings/data/datasources/admin_settings_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/settings/domain/repositories/i_admin_settings_repository.dart';
import 'package:street_cart/features/admin/settings/data/repositories/admin_settings_repository_impl.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_notification_preferences.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_admin_notification_preference.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_admin_settings.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_platform_commission.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_payment_controls.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/change_admin_password.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_categories.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/get_product_config.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_colors.dart';
import 'package:street_cart/features/admin/settings/domain/usecases/save_size_groups.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_settings_bloc.dart';
import 'package:street_cart/features/admin/settings/presentation/bloc/admin_product_config_bloc.dart';

// ADMIN - PROFILE
import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource.dart';
import 'package:street_cart/features/admin/profile/data/datasources/admin_profile_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/profile/domain/repositories/i_admin_profile_repository.dart';
import 'package:street_cart/features/admin/profile/data/repositories/admin_profile_repository_impl.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/get_admin_profile_data.dart';
import 'package:street_cart/features/admin/profile/domain/usecases/update_admin_profile_name.dart';
import 'package:street_cart/features/admin/profile/presentation/bloc/admin_profile_bloc.dart';

import 'package:street_cart/features/admin/shops/data/datasources/i_admin_shop_remote_datasource.dart';
import 'package:street_cart/features/admin/shops/data/datasources/admin_shop_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/shops/domain/repositories/admin_shop_repository.dart';
import 'package:street_cart/features/admin/shops/data/repositories/admin_shop_repository_impl.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/get_admin_shop_details.dart';
import 'package:street_cart/features/admin/shops/domain/usecases/delete_shop.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_bloc.dart';
import 'package:street_cart/features/admin/shops/presentation/bloc/admin_shop_detail_bloc.dart';
// ADMIN - CUSTOMERS
import 'package:street_cart/features/admin/customers/data/datasources/i_admin_customer_remote_datasource.dart';
import 'package:street_cart/features/admin/customers/data/datasources/admin_customer_remote_datasource.dart';
import 'package:street_cart/features/admin/customers/domain/repositories/admin_customer_repository.dart';
import 'package:street_cart/features/admin/customers/data/repositories/admin_customer_repository_impl.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customers.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/toggle_customer_status.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/get_admin_customer_details.dart';
import 'package:street_cart/features/admin/customers/domain/usecases/delete_customer.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customers_bloc.dart';
import 'package:street_cart/features/admin/customers/presentation/bloc/admin_customer_detail_bloc.dart';
// ADMIN - PRODUCTS
import 'package:street_cart/features/admin/products/data/datasources/admin_product_remote_datasource.dart';
import 'package:street_cart/features/admin/products/data/datasources/admin_product_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/products/domain/repositories/admin_product_repository.dart';
import 'package:street_cart/features/admin/products/data/repositories/admin_product_repository_impl.dart';
import 'package:street_cart/features/admin/products/domain/usecases/get_admin_products.dart';
import 'package:street_cart/features/admin/products/domain/usecases/get_admin_product_details.dart';
import 'package:street_cart/features/admin/products/domain/usecases/disable_product.dart';
import 'package:street_cart/features/admin/products/domain/usecases/admin_delete_product.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_bloc.dart';
import 'package:street_cart/features/admin/products/presentation/bloc/admin_product_detail_bloc.dart';

// ADMIN - ORDERS
import 'package:street_cart/features/admin/orders/data/datasources/i_admin_orders_remote_datasource.dart';
import 'package:street_cart/features/admin/orders/data/datasources/admin_orders_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/orders/domain/repositories/i_admin_orders_repository.dart';
import 'package:street_cart/features/admin/orders/data/repositories/admin_orders_repository_impl.dart';
import 'package:street_cart/features/admin/orders/domain/usecases/get_admin_orders.dart';
import 'package:street_cart/features/admin/orders/presentation/bloc/admin_orders_bloc.dart';

// SHOP - REVIEWS
import 'package:street_cart/features/shop/reviews/data/datasources/shop_reviews_remote_datasource.dart';
import 'package:street_cart/features/shop/reviews/data/datasources/shop_reviews_remote_datasource_impl.dart';
import 'package:street_cart/features/shop/reviews/data/repositories/shop_reviews_repository_impl.dart';
import 'package:street_cart/features/shop/reviews/domain/repositories/i_shop_reviews_repository.dart';
import 'package:street_cart/features/shop/reviews/domain/usecases/get_shop_product_reviews.dart';
import 'package:street_cart/features/shop/reviews/presentation/bloc/shop_reviews_bloc.dart';

// SHOP - SALES ANALYTICS
import 'package:street_cart/features/shop/sales_analytics/data/datasources/sales_analytics_remote_datasource.dart';
import 'package:street_cart/features/shop/sales_analytics/data/repositories/sales_analytics_repository_impl.dart';
import 'package:street_cart/features/shop/sales_analytics/domain/repositories/i_sales_analytics_repository.dart';
import 'package:street_cart/features/shop/sales_analytics/domain/usecases/get_sales_analytics.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/bloc/sales_analytics_bloc.dart';

// ADMIN - REVIEWS
import 'package:street_cart/features/admin/reviews/data/datasources/admin_reviews_remote_datasource.dart';
import 'package:street_cart/features/admin/reviews/data/datasources/admin_reviews_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/reviews/data/repositories/admin_reviews_repository_impl.dart';
import 'package:street_cart/features/admin/reviews/domain/repositories/i_admin_reviews_repository.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/get_admin_reviews.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/delete_review_by_admin.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_bloc.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/toggle_review_visibility.dart';
import 'package:street_cart/features/admin/reviews/domain/usecases/get_admin_review_details.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_review_detail_bloc.dart';

// ADMIN - REVENUE
import 'package:street_cart/features/admin/revenue/data/datasources/i_admin_revenue_remote_datasource.dart';
import 'package:street_cart/features/admin/revenue/data/datasources/admin_revenue_remote_datasource_impl.dart';
import 'package:street_cart/features/admin/revenue/data/repositories/admin_revenue_repository_impl.dart';
import 'package:street_cart/features/admin/revenue/domain/repositories/i_admin_revenue_repository.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_orders.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_shops.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_products.dart';
import 'package:street_cart/features/admin/revenue/domain/usecases/get_revenue_customers.dart';
import 'package:street_cart/features/admin/revenue/presentation/bloc/admin_revenue_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initCore();

  // CUSTOMER
  _initCustomerAuth();
  _initCustomerHome();
  _initCustomerProducts();
  _initCustomerCart();
  _initCustomerPayment();
  _initCustomerOrders();
  _initCustomerShops();
  _initCustomerProfile();
  _initCustomerLocation();
  _initCustomerOnboarding();
  _initCustomerSplash();
  await _initCustomerSettings();
  _initCustomerReview();
  _initCustomerNotifications();

  // SHOP
  await _initShopAuth();
  await _initShopOnboarding();
  await _initShopLocation();
  await _initShopHome();
  await _initShopSplash();
  await _initShopProfile();
  await _initShopSettings();
  await _initShopProducts();
  _initShopOrders();
  _initShopReviews();
  _initShopSalesAnalytics();
  _initShopNotifications();

  // ADMIN
  _initAdminAuth();
  _initAdminSplash();
  _initAdminDashboard();
  _initAdminSettings();
  _initAdminProfile();
  _initAdminShop();
  _initAdminCustomers();
  _initAdminProducts();
  _initAdminOrders();
  _initAdminReviews();
  _initAdminRevenue();
  _initAdminNotifications();
}

// ================= SHOP SPLASH =================
Future<void> _initShopSplash() async {
  sl.registerLazySingleton<IShopSplashLocalDataSource>(
    () => ShopSplashLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<IShopSplashRemoteDataSource>(
    () => ShopSplashRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );
  sl.registerLazySingleton<IShopSplashRepository>(
    () => ShopSplashRepositoryImpl(local: sl(), remote: sl()),
  );
  sl.registerLazySingleton(() => CheckShopAppStatus(sl()));

  sl.registerFactory(() => ShopSplashBloc(checkShopAppStatus: sl()));
}

// ================= SHOP ONBOARDING =================
Future<void> _initShopOnboarding() async {
  sl.registerLazySingleton<IShopOnboardingLocalDataSource>(
    () => ShopOnboardingLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<IShopOnboardingRepository>(
    () => ShopOnboardingRepositoryImpl(local: sl()),
  );
  sl.registerLazySingleton(() => CompleteShopOnboarding(sl()));

  sl.registerFactory(() => ShopOnboardingBloc(completeShopOnboarding: sl()));
}

// ================= SHOP LOCATION =================
Future<void> _initShopLocation() async {
  sl.registerLazySingleton<ShopLocationDataSource>(
    () => ShopLocationDataSourceImpl(
      locationService: sl(),
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<IShopLocationRepository>(
    () => ShopLocationRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton(() => RequestShopLocationAndSave(sl()));
  sl.registerLazySingleton(() => SkipShopLocation(sl()));

  sl.registerFactory(
    () => ShopLocationBloc(requestLocationAndSave: sl(), skipLocation: sl()),
  );
}

// ================= SHOP HOME =================
Future<void> _initShopHome() async {
  // Datasource
  sl.registerLazySingleton<IShopHomeLocalDataSource>(
    () => ShopHomeLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<IShopHomeRepository>(
    () => ShopHomeRepositoryImpl(sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => CheckFirstHomeVisit(sl()));
  sl.registerLazySingleton(() => CompleteFirstHomeVisit(sl()));
  sl.registerLazySingleton(() => GetShopDashboardOrders(sl()));

  // Bloc
  sl.registerLazySingleton(
    () => ShopHomeBloc(
      checkFirstHomeVisit: sl(),
      completeFirstHomeVisit: sl(),
      getShopDashboardOrders: sl(),
    ),
  );
}

// ================= SHOP AUTH =================
Future<void> _initShopAuth() async {
  // Datasource
  sl.registerLazySingleton<IShopAuthRemoteDataSource>(
    () => ShopAuthRemoteDataSourceImpl(
      authService: sl(),
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IShopAuthRepository>(
    () => ShopAuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => ShopLogin(sl()));
  sl.registerLazySingleton(() => ShopSignup(sl()));
  sl.registerLazySingleton(() => SetupShopProfile(sl(), sl()));
  sl.registerLazySingleton(() => GetShopStatus(sl()));
  sl.registerLazySingleton(() => ShopLogout(sl()));
  sl.registerLazySingleton(() => SendShopPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => SendShopEmailVerification(sl()));
  sl.registerLazySingleton(() => CheckShopEmailVerification(sl()));
  sl.registerLazySingleton(() => FinalizeShopSignUp(sl(), sl()));
  sl.registerLazySingleton(() => GetBusinessCategories(sl()));
  sl.registerLazySingleton(() => GetProductCategories(sl()));
  sl.registerLazySingleton(() => GetShopPaymentSettings(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopAuthBloc(
      login: sl(),
      signUp: sl(),
      setupProfile: sl(),
      getStatus: sl(),
      logout: sl(),
      sendShopPasswordResetEmail: sl(),
      sendShopEmailVerification: sl(),
      checkShopEmailVerification: sl(),
      finalizeShopSignUp: sl(),
      deleteShopAuthAccount: sl(),
      getBusinessCategories: sl(),
    ),
  );
}

// ================= CORE =================
Future<void> _initCore() async {
  final appInfoService = AppInfoService();
  await appInfoService.init();
  sl.registerSingleton<IAppInfoService>(appInfoService);

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());

  sl.registerLazySingleton(
    () => FirebaseAuthService(auth: sl(), googleSignIn: sl()),
  );

  sl.registerLazySingleton(() => CloudinaryService());
  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => CommunicationService());
  sl.registerLazySingleton(() => NotificationService.instance);

  sl.registerLazySingleton<INetworkInfo>(() => NetworkInfoImpl());
}

// ================= CUSTOMER AUTH =================
void _initCustomerAuth() {
  sl.registerLazySingleton<IAuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(authService: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<IAuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => Login(sl()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => SendPasswordResetEmail(sl()));
  sl.registerLazySingleton(() => GetCustomerProfile(sl()));
  sl.registerLazySingleton(() => GetCustomerData(sl()));
  sl.registerLazySingleton(() => UpdateCustomerProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => CheckEmailPasswordUser(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));
  sl.registerLazySingleton(() => SendEmailVerification(sl()));
  sl.registerLazySingleton(() => CheckEmailVerification(sl()));
  sl.registerLazySingleton(() => FinalizeSignUp(sl()));

  sl.registerFactory(
    () => AuthBloc(
      signUp: sl(),
      login: sl(),
      signInWithGoogle: sl(),
      logout: sl(),
      sendPasswordResetEmail: sl(),
      getCustomerProfile: sl(),
      updateCustomerProfile: sl(),
      changePassword: sl(),
      deleteAccount: sl(),
      sendEmailVerification: sl(),
      checkEmailVerification: sl(),
      finalizeSignUp: sl(),
    ),
  );
}

// ================= CUSTOMER HOME =================
void _initCustomerHome() {
  sl.registerLazySingleton<IHomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      locationService: sl(),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<IHomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetHomeData(sl()));

  sl.registerLazySingleton(() => HomeBloc(getHomeData: sl()));
}

// ================= CUSTOMER PROFILE =================
void _initCustomerProfile() {
  sl.registerLazySingleton<IProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      locationService: sl(),
      cloudinaryService: sl(),
    ),
  );

  sl.registerLazySingleton<IProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => GetProfileData(sl()));
  sl.registerLazySingleton(() => UpdateProfileData(sl()));
  sl.registerLazySingleton(() => UploadProfileImage(sl()));
  sl.registerLazySingleton(() => RemoveProfileImage(sl()));

  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => AddAddress(sl()));
  sl.registerLazySingleton(() => UpdateAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));

  sl.registerFactory(
    () => ProfileBloc(
      getProfileData: sl(),
      updateProfileData: sl(),
      uploadProfileImage: sl(),
      removeProfileImage: sl(),
    ),
  );

  sl.registerFactory(
    () => AddressBloc(
      getAddresses: sl(),
      addAddress: sl(),
      updateAddress: sl(),
      deleteAddress: sl(),
      setDefaultAddress: sl(),
    ),
  );
}

// ================= CUSTOMER REVIEW =================
void _initCustomerReview() {
  sl.registerLazySingleton<IReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  sl.registerLazySingleton<IReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(
    () => SubmitReview(
      repository: sl(),
      getProductById: sl(),
      sendShopNotification: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetProductReviews(sl()));
  sl.registerLazySingleton(() => DeleteReview(sl()));

  sl.registerFactory(() => ReviewBloc(submitReview: sl()));
}

// ================= CUSTOMER LOCATION =================
void _initCustomerLocation() {
  sl.registerLazySingleton<LocationDataSource>(
    () => LocationDataSourceImpl(
      locationService: sl(),
      firebaseAuth: sl(),
      firebaseFirestore: sl(),
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ILocationRepository>(
    () => LocationRepositoryImpl(dataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => RequestLocationAndSave(sl()));
  sl.registerLazySingleton(() => SkipLocation(sl()));

  sl.registerFactory(
    () => LocationBloc(requestLocationAndSave: sl(), skipLocation: sl()),
  );
}

// ================= CUSTOMER ONBOARDING =================
void _initCustomerOnboarding() {
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<IOnboardingRepository>(
    () => OnboardingRepositoryImpl(local: sl()),
  );

  sl.registerLazySingleton(() => CompleteOnboarding(sl()));

  sl.registerFactory(() => OnboardingBloc(completeOnboarding: sl()));
}

// ================= CUSTOMER SPLASH =================
void _initCustomerSplash() {
  sl.registerLazySingleton<SplashLocalDataSource>(
    () => SplashLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<SplashRemoteDataSource>(
    () => SplashRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ISplashRepository>(
    () => SplashRepositoryImpl(local: sl(), remote: sl()),
  );

  sl.registerLazySingleton(() => CheckAppStatus(sl()));

  sl.registerFactory(() => SplashBloc(checkAppStatus: sl()));
}

// ================= CUSTOMER SETTINGS =================
Future<void> _initCustomerSettings() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<ISettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  sl.registerLazySingleton<ISettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<ISettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateSetting(sl()));
  sl.registerLazySingleton(() => GetCustomerNotificationPreferences(sl()));
  sl.registerLazySingleton(() => SaveCustomerNotificationPreference(sl()));

  sl.registerLazySingleton(
    () => SettingsBloc(
      getSettings: sl(),
      updateSetting: sl(),
      locationRepository: sl(),
      authRepository: sl(),
      getCustomerNotificationPreferences: sl(),
      saveCustomerNotificationPreference: sl(),
    ),
  );

  sl.registerLazySingleton(() => ThemeCubit(sharedPreferences: sl()));
  sl.registerLazySingleton(() => ShopThemeCubit(sharedPreferences: sl()));
  sl.registerLazySingleton(() => AdminThemeCubit(sharedPreferences: sl()));
}

// ================= CUSTOMER PRODUCTS =================
void _initCustomerProducts() {
  sl.registerLazySingleton<ICustomerProductsRemoteDataSource>(
    () => CustomerProductsRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<ICustomerProductsRepository>(
    () => CustomerProductsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetCustomerProducts(repository: sl()));
  sl.registerLazySingleton(() => AddToWishlist(repository: sl()));
  sl.registerLazySingleton(() => RemoveFromWishlist(repository: sl()));
  sl.registerLazySingleton(() => GetWishlist(repository: sl()));
  sl.registerLazySingleton(() => ClearWishlist(repository: sl()));

  sl.registerFactory(
    () => CustomerProductsBloc(
      getCustomerProducts: sl(),
      sharedPreferences: sl(),
      getProductReviews: sl(),
    ),
  );

  sl.registerFactory(
    () => WishlistBloc(
      addToWishlist: sl(),
      removeFromWishlist: sl(),
      getWishlist: sl(),
      clearWishlist: sl(),
      auth: sl(),
    ),
  );
}

// ================= CUSTOMER CART =================
void _initCustomerCart() {
  sl.registerLazySingleton<ICartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => GetCart(repository: sl()));
  sl.registerLazySingleton(() => AddToCart(repository: sl()));
  sl.registerLazySingleton(() => RemoveFromCart(repository: sl()));
  sl.registerLazySingleton(() => UpdateCartQuantity(repository: sl()));
  sl.registerLazySingleton(() => ClearCart(repository: sl()));
  sl.registerLazySingleton(() => GetProductById(repository: sl()));
  sl.registerLazySingleton(() => GetShopById(repository: sl()));

  sl.registerFactory(
    () => CartBloc(
      getCart: sl(),
      addToCartUsecase: sl(),
      removeFromCartUsecase: sl(),
      updateCartQuantity: sl(),
      clearCart: sl(),
      getProductById: sl(),
      auth: sl(),
    ),
  );

  sl.registerFactory(
    () => CheckoutBloc(getShopById: sl(), getProductById: sl()),
  );
}

// ================= CUSTOMER PAYMENT =================
void _initCustomerPayment() {
  // Service
  sl.registerLazySingleton(() => RazorpayService());

  // Datasource
  sl.registerLazySingleton<IPaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      deliveryValidator: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IPaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Case
  sl.registerLazySingleton(
    () => PlaceCustomerOrder(
      repository: sl(),
      sendShopNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );

  // Bloc
  sl.registerFactory(
    () => PaymentBloc(
      placeCustomerOrder: sl(),
      razorpayService: sl(),
      getProfileData: sl(),
      deliveryValidator: sl(),
      getProductById: sl(),
    ),
  );
}

// ================= CUSTOMER SHOPS =================
void _initCustomerShops() {
  sl.registerLazySingleton<ICustomerShopsRemoteDataSource>(
    () => CustomerShopsRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<ICustomerShopsRepository>(
    () =>
        CustomerShopsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  sl.registerLazySingleton(() => GetNearbyShops(repository: sl()));
  sl.registerLazySingleton(() => GetCustomerShopProducts(repository: sl()));

  sl.registerFactory(
    () => CustomerShopsBloc(getNearbyShops: sl(), sharedPreferences: sl()),
  );
  sl.registerFactory(() => ShopDetailsBloc(getShopProducts: sl()));
}

// ================= SHOP PROFILE =================
Future<void> _initShopProfile() async {
  // Datasource
  sl.registerLazySingleton<IShopProfileRemoteDataSource>(
    () => ShopProfileRemoteDataSourceImpl(
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IShopProfileRepository>(
    () => ShopProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
      auth: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetShopProfileData(sl()));
  sl.registerLazySingleton(() => UpdateShopProfileData(sl()));
  sl.registerLazySingleton(() => UploadShopProfileImage(sl()));
  sl.registerLazySingleton(() => RemoveShopProfileImage(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopProfileBloc(
      getProfileData: sl(),
      updateProfileData: sl(),
      uploadProfileImage: sl(),
      removeProfileImage: sl(),
      getShopPaymentSettings: sl(),
    ),
  );
}

// ================= SHOP SETTINGS =================
Future<void> _initShopSettings() async {
  // Datasources
  sl.registerLazySingleton<IShopSettingsLocalDataSource>(
    () => ShopSettingsLocalDataSourceImpl(sharedPreferences: sl()),
  );
  // Repositories
  sl.registerLazySingleton<IShopSettingsRepository>(
    () => ShopSettingsRepositoryImpl(localDataSource: sl()),
  );
  // Usecases
  sl.registerLazySingleton(() => ChangeShopPassword(sl()));
  sl.registerLazySingleton(() => DeleteShopAuthAccount(sl()));
  sl.registerLazySingleton(() => GetShopNotificationPreferences(sl()));
  sl.registerLazySingleton(() => SaveShopNotificationPreference(sl()));
  sl.registerLazySingleton(() => GetShopLocalSettings(sl()));
  sl.registerLazySingleton(() => UpdateShopLocalSetting(sl()));

  sl.registerFactory(
    () => ShopSettingsBloc(
      changeShopPassword: sl(),
      deleteShopAuthAccount: sl(),
      getShopNotificationPreferences: sl(),
      saveShopNotificationPreference: sl(),
      getShopLocalSettings: sl(),
      updateShopLocalSetting: sl(),
      pushNotifications:
          sl<SharedPreferences>().getBool('generalNotifications') ?? true,
      orderAlerts: sl<SharedPreferences>().getBool('orderAlerts') ?? true,
    ),
  );
}

// ================= SHOP PRODUCTS =================
Future<void> _initShopProducts() async {
  // Datasource
  sl.registerLazySingleton<IShopProductsRemoteDataSource>(
    () => ShopProductsRemoteDataSourceImpl(
      firestore: sl(),
      cloudinaryService: sl(),
    ),
  );

  // Repository
  sl.registerLazySingleton<IShopProductsRepository>(
    () => ShopProductsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetShopProducts(sl()));
  sl.registerLazySingleton(() => AddProduct(sl()));
  sl.registerLazySingleton(() => UpdateProduct(sl(), sl()));
  sl.registerLazySingleton(() => DeleteProduct(sl()));
  sl.registerLazySingleton(() => GetShopProductConfig(sl()));
  sl.registerLazySingleton(() => SaveShopProductConfig(sl()));

  // Bloc
  sl.registerFactory(
    () => ShopProductsBloc(
      getShopProducts: sl(),
      addProduct: sl(),
      updateProduct: sl(),
      deleteProduct: sl(),
      getShopProductConfig: sl(),
      saveShopProductConfig: sl(),
      getProductCategories: sl(),
    ),
  );
}

// ================= ADMIN AUTH =================
void _initAdminAuth() {
  // Datasource
  sl.registerLazySingleton<IAdminAuthRemoteDataSource>(
    () => AdminAuthRemoteDataSourceImpl(authService: sl(), firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminAuthRepository>(
    () => AdminAuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AdminLogin(sl()));
  sl.registerLazySingleton(() => CheckAdminSession(sl()));
  sl.registerLazySingleton(() => AdminLogout(sl()));
  sl.registerLazySingleton(() => SendAdminPasswordReset(sl()));
  sl.registerLazySingleton(() => ConfirmAdminPasswordReset(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminAuthBloc(
      loginUseCase: sl(),
      checkSessionUseCase: sl(),
      logoutUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      confirmPasswordResetUseCase: sl(),
    ),
  );
}

// ================= ADMIN SPLASH =================
void _initAdminSplash() {
  // Repository
  sl.registerLazySingleton<IAdminSplashRepository>(
    () => AdminSplashRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => CheckAdminSplashSession(sl()));

  // Bloc
  sl.registerFactory(() => AdminSplashBloc(checkAdminSplashSession: sl()));
}

// ================= ADMIN DASHBOARD =================
void _initAdminDashboard() {
  // Datasource
  sl.registerLazySingleton<IAdminDashboardRemoteDataSource>(
    () => AdminDashboardRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminDashboardRepository>(
    () =>
        AdminDashboardRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetDashboardData(sl()));
  sl.registerLazySingleton(() => GetPendingRegistrations(sl()));
  sl.registerLazySingleton(() => GetPendingRegistrationsCount(sl()));
  sl.registerLazySingleton(() => GetShopDetails(sl()));
  sl.registerLazySingleton(
    () => ApproveShop(
      repository: sl(),
      getShopDetails: sl(),
      sendShopNotification: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => RejectShop(
      repository: sl(),
      getShopDetails: sl(),
      sendShopNotification: sl(),
    ),
  );

  // Bloc
  sl.registerFactory(
    () => AdminDashboardBloc(getDashboardData: sl(), firestore: sl()),
  );
  sl.registerFactory(
    () => AdminRegistrationsBloc(
      getPendingRegistrations: sl(),
      getPendingRegistrationsCount: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminRegistrationDetailsBloc(
      getShopDetails: sl(),
      approveShop: sl(),
      rejectShop: sl(),
    ),
  );
}

// ================= ADMIN SETTINGS =================
void _initAdminSettings() {
  // Datasource
  sl.registerLazySingleton<IAdminSettingsRemoteDataSource>(
    () => AdminSettingsRemoteDataSourceImpl(firestore: sl(), authService: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminSettingsRepository>(
    () =>
        AdminSettingsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminSettings(sl()));
  sl.registerLazySingleton(() => SavePlatformCommission(sl(), sl()));
  sl.registerLazySingleton(() => SavePaymentControls(sl()));
  sl.registerLazySingleton(() => ChangeAdminPassword(sl()));
  sl.registerLazySingleton(() => SaveCategories(sl()));
  sl.registerLazySingleton(() => GetProductConfig(sl()));
  sl.registerLazySingleton(() => SaveColors(sl()));
  sl.registerLazySingleton(() => SaveSizeGroups(sl()));
  sl.registerLazySingleton(() => GetAdminNotificationPreferences(sl()));
  sl.registerLazySingleton(() => SaveAdminNotificationPreference(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminSettingsBloc(
      getAdminSettings: sl(),
      savePlatformCommission: sl(),
      savePaymentControls: sl(),
      changeAdminPassword: sl(),
      saveCategories: sl(),
      getAdminNotificationPreferences: sl(),
      saveAdminNotificationPreference: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminProductConfigBloc(
      getProductConfig: sl(),
      saveColors: sl(),
      saveSizeGroups: sl(),
    ),
  );
}

// ================= ADMIN PROFILE =================
void _initAdminProfile() {
  // Datasource
  sl.registerLazySingleton<IAdminProfileRemoteDataSource>(
    () => AdminProfileRemoteDataSourceImpl(auth: sl(), firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminProfileRepository>(
    () => AdminProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Usecase
  sl.registerLazySingleton(() => GetAdminProfileData(sl()));
  sl.registerLazySingleton(() => UpdateAdminProfileName(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => AdminProfileBloc(getProfileData: sl(), updateProfileName: sl()),
  );
}

void _initAdminShop() {
  // Datasource
  sl.registerLazySingleton<IAdminShopRemoteDataSource>(
    () => AdminShopRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminShopRepository>(
    () => AdminShopRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminShop(sl()));
  sl.registerLazySingleton(() => ToggleShopSuspension(sl()));
  sl.registerLazySingleton(() => GetAdminShopDetails(sl()));
  sl.registerLazySingleton(() => DeleteShop(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminShopBloc(getAdminShop: sl(), toggleShopSuspension: sl()),
  );
  sl.registerFactory(
    () => AdminShopDetailBloc(
      getAdminShopDetails: sl(),
      toggleShopSuspension: sl(),
      deleteShop: sl(),
      shopRepository: sl(),
    ),
  );
}

void _initAdminCustomers() {
  // Datasource
  sl.registerLazySingleton<IAdminCustomerRemoteDataSource>(
    () => AdminCustomerRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminCustomerRepository>(
    () =>
        AdminCustomerRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAdminCustomers(sl()));
  sl.registerLazySingleton(() => ToggleCustomerBlockStatus(sl()));
  sl.registerLazySingleton(() => GetAdminCustomerDetails(sl()));
  sl.registerLazySingleton(() => DeleteCustomer(sl()));

  // Bloc
  sl.registerFactory(
    () => AdminCustomersBloc(
      getAdminCustomers: sl(),
      toggleCustomerBlockStatus: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminCustomerDetailBloc(
      getCustomerDetails: sl(),
      toggleBlockStatus: sl(),
      deleteCustomer: sl(),
    ),
  );
}

void _initAdminProducts() {
  // Datasource
  sl.registerLazySingleton<IAdminProductRemoteDataSource>(
    () => AdminProductRemoteDataSourceImpl(firestore: sl()),
  );

  // Repository
  sl.registerLazySingleton<IAdminProductRepository>(
    () => AdminProductRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // Use Case
  sl.registerLazySingleton(() => GetAdminProducts(sl()));
  sl.registerLazySingleton(() => GetAdminProductDetails(sl()));
  sl.registerLazySingleton(() => DisableProduct(sl()));
  sl.registerLazySingleton(() => AdminDeleteProduct(sl()));

  // Bloc
  sl.registerFactory(() => AdminProductBloc(getAdminProducts: sl()));
  sl.registerFactory(
    () => AdminProductDetailBloc(
      getProductDetails: sl(),
      disableProduct: sl(),
      deleteProduct: sl(),
    ),
  );
}

// ================= CUSTOMER ORDERS =================
void _initCustomerOrders() {
  sl.registerLazySingleton<DeliveryValidator>(
    () => DeliveryValidator(firestore: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton<IOrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      deliveryValidator: sl(),
    ),
  );
  sl.registerLazySingleton<IOrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetCustomerOrders(sl()));
  sl.registerLazySingleton(
    () => CancelOrder(
      repository: sl(),
      getOrderDetails: sl(),
      sendShopNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => CancelOrderItem(
      repository: sl(),
      getOrderDetails: sl(),
      sendShopNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(() => UpdateOrderAddress(sl()));
  sl.registerLazySingleton(
    () => SubmitReturnRequest(
      repository: sl(),
      getOrderDetails: sl(),
      sendShopNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(() => CheckProductsAvailability(sl()));
  sl.registerFactory(
    () => OrdersBloc(
      getCustomerOrders: sl(),
      cancelOrder: sl(),
      cancelOrderItem: sl(),
      updateOrderAddress: sl(),
      submitReturnRequest: sl(),
      checkProductsAvailability: sl(),
    ),
  );
}

// ================= SHOP ORDERS =================
void _initShopOrders() {
  sl.registerLazySingleton<IShopOrdersRemoteDataSource>(
    () => ShopOrdersRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IShopOrdersRepository>(
    () => ShopOrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetShopOrders(sl()));
  sl.registerLazySingleton(
    () => UpdateShopOrderStatus(
      repository: sl(),
      getOrderDetails: sl(),
      sendCustomerNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => UpdateShopOrderReturnStatus(
      repository: sl(),
      getOrderDetails: sl(),
      sendCustomerNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ProcessRefund(
      repository: sl(),
      getOrderDetails: sl(),
      sendCustomerNotification: sl(),
      sendAdminNotification: sl(),
    ),
  );
  sl.registerLazySingleton(() => CheckProductsStatus(sl()));
  sl.registerFactory(
    () => ShopOrdersBloc(
      getShopOrders: sl(),
      updateShopOrderStatus: sl(),
      updateShopOrderReturnStatus: sl(),
      processRefund: sl(),
      razorpayService: sl(),
      getShopProfileData: sl(),
      checkProductsStatus: sl(),
    ),
  );
}

// ================= ADMIN ORDERS =================
void _initAdminOrders() {
  sl.registerLazySingleton<IAdminOrdersRemoteDataSource>(
    () => AdminOrdersRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IAdminOrdersRepository>(
    () => AdminOrdersRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetAdminOrders(sl()));
  sl.registerFactory(() => AdminOrdersBloc(getAdminOrders: sl()));
}

// ================= SHOP REVIEWS =================
void _initShopReviews() {
  sl.registerLazySingleton<IShopReviewsRemoteDataSource>(
    () => ShopReviewsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IShopReviewsRepository>(
    () => ShopReviewsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetShopProductReviews(sl()));
  sl.registerFactory(() => ShopReviewsBloc(getShopProductReviews: sl()));
}

// ================= ADMIN REVIEWS =================
void _initAdminReviews() {
  sl.registerLazySingleton<IAdminReviewsRemoteDataSource>(
    () => AdminReviewsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IAdminReviewsRepository>(
    () => AdminReviewsRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  sl.registerLazySingleton(() => GetAdminReviews(sl()));
  sl.registerLazySingleton(() => DeleteReviewByAdmin(sl()));
  sl.registerLazySingleton(() => ToggleReviewVisibility(sl()));
  sl.registerLazySingleton(() => GetAdminReviewDetails(sl()));
  sl.registerFactory(
    () => AdminReviewsBloc(getAdminReviews: sl(), deleteReviewByAdmin: sl()),
  );
  sl.registerFactory(
    () => AdminReviewDetailBloc(
      getAdminReviewDetails: sl(),
      toggleReviewVisibility: sl(),
      deleteReviewByAdmin: sl(),
    ),
  );
}

// ================= SHOP SALES ANALYTICS =================
void _initShopSalesAnalytics() {
  sl.registerLazySingleton<ISalesAnalyticsRemoteDataSource>(
    () => SalesAnalyticsRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IShopSalesAnalyticsRepository>(
    () => ShopSalesAnalyticsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetSalesAnalytics(sl()));
  sl.registerFactory(() => SalesAnalyticsBloc(getSalesAnalytics: sl()));
}

// ================= ADMIN REVENUE =================
void _initAdminRevenue() {
  sl.registerLazySingleton<IAdminRevenueRemoteDataSource>(
    () => AdminRevenueRemoteDataSourceImpl(firestore: sl()),
  );
  sl.registerLazySingleton<IAdminRevenueRepository>(
    () => AdminRevenueRepositoryImpl(dataSource: sl(), networkInfo: sl()),
  );
  // Individual use cases
  sl.registerLazySingleton(() => GetRevenueOrders(sl()));
  sl.registerLazySingleton(() => GetRevenueShops(sl()));
  sl.registerLazySingleton(() => GetRevenueProducts(sl()));
  sl.registerLazySingleton(() => GetRevenueCustomers(sl()));
  sl.registerFactory(
    () => AdminRevenueBloc(
      getOrders: sl(),
      getShops: sl(),
      getProducts: sl(),
      getCustomers: sl(),
    ),
  );
}

// ================= CUSTOMER NOTIFICATION =================
void _initCustomerNotifications() {
  sl.registerLazySingleton<ICustomerNotificationDataSource>(
    () => CustomerNotificationDataSourceImpl(),
  );
  sl.registerLazySingleton<ICustomerNotificationsRepository>(
    () => CustomerNotificationsRepositoryImpl(
      datasource: sl(),
      networkInfo: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => WatchCustomerNotifications(sl()));
  sl.registerLazySingleton(() => MarkCustomerNotificationAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllCustomerNotificationsAsRead(sl()));
  sl.registerLazySingleton(() => GetCustomerOrderDetails(sl()));
  sl.registerLazySingleton(() => GetCustomerProductDetails(sl()));

  sl.registerLazySingleton(() => SendCustomerNotification(sl()));

  sl.registerFactory(
    () => CustomerNotificationsBloc(
      watchCustomerNotifications: sl(),
      markCustomerNotificationAsRead: sl(),
      markAllCustomerNotificationsAsRead: sl(),
      getCustomerOrderDetails: sl(),
      getCustomerProductDetails: sl(),
    ),
  );
}

// ================= SHOP NOTIFICATION =================
void _initShopNotifications() {
  sl.registerLazySingleton<IShopNotificationDataSource>(
    () => ShopNotificationDataSourceImpl(),
  );
  sl.registerLazySingleton<IShopNotificationsRepository>(
    () => ShopNotificationsRepositoryImpl(datasource: sl(), networkInfo: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => WatchShopNotifications(sl()));
  sl.registerLazySingleton(() => MarkShopNotificationAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllShopNotificationsAsRead(sl()));
  sl.registerLazySingleton(() => DeleteShopNotification(sl()));
  sl.registerLazySingleton(() => GetShopOrderDetails(sl()));

  sl.registerLazySingleton(() => SendShopNotification(sl()));

  sl.registerFactory(
    () => ShopNotificationsBloc(
      watchShopNotifications: sl(),
      markShopNotificationAsRead: sl(),
      markAllShopNotificationsAsRead: sl(),
      deleteShopNotification: sl(),
      getShopOrderDetails: sl(),
    ),
  );
}

// ================= ADMIN NOTIFICATION =================
void _initAdminNotifications() {
  sl.registerLazySingleton<IAdminNotificationDataSource>(
    () => AdminNotificationDataSourceImpl(),
  );
  sl.registerLazySingleton<IAdminNotificationsRepository>(
    () => AdminNotificationsRepositoryImpl(datasource: sl(), networkInfo: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => WatchAdminNotifications(sl()));
  sl.registerLazySingleton(() => MarkAdminNotificationAsRead(sl()));
  sl.registerLazySingleton(() => MarkAllAdminNotificationsAsRead(sl()));

  sl.registerLazySingleton(() => SendAdminNotification(sl()));

  sl.registerFactory(
    () => AdminNotificationsBloc(
      watchAdminNotifications: sl(),
      markAdminNotificationAsRead: sl(),
      markAllAdminNotificationsAsRead: sl(),
    ),
  );
}
