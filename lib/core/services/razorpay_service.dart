import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  final Razorpay _razorpay = Razorpay();
  final String _apiKey = "rzp_test_TAW6I4NOXgCcYK";

  void initialize({
    required void Function(PaymentSuccessResponse) onSuccess,
    required void Function(PaymentFailureResponse) onFailure,
    required void Function(ExternalWalletResponse) onExternalWallet,
  }) {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, onSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, onFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, onExternalWallet);
  }

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String contact,
    required String email,
  }) {
    var options = {
      'key': _apiKey,
      'amount': (amount * 100).toInt(), // Amount Converted to paisa
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
    };
    _razorpay.open(options);
  }

  void clear() {
    _razorpay.clear();
  }
}
