import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';
import 'package:street_cart/features/customer/cart/data/models/cart_item_model.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_bloc.dart';
import 'package:street_cart/features/customer/cart/presentation/bloc/cart_event.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_bloc.dart';
import 'package:street_cart/features/customer/payment/presentation/bloc/payment_state.dart';
import 'package:street_cart/features/customer/payment/presentation/pages/order_success_page.dart';

class PaymentProcessingOverlay extends StatefulWidget {
  final String paymentMethod;
  final double totalAmount;
  final List<CartItem> cartItems;

  const PaymentProcessingOverlay({
    super.key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<PaymentProcessingOverlay> createState() =>
      _PaymentProcessingOverlayState();
}

class _PaymentProcessingOverlayState extends State<PaymentProcessingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  bool _isLoading = true;
  int _currentPhase = 1;
  bool _flowStarted = false;
  late DateTime _loadingStartTime;

  @override
  void initState() {
    super.initState();
    _loadingStartTime = DateTime.now();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rippleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    final state = context.read<PaymentBloc>().state;
    if (state is PaymentSuccess) {
      _startSuccessFlow(state);
    }
  }

  void _startSuccessFlow(PaymentSuccess successState) {
    _flowStarted = true;
    final bool isOnline = widget.paymentMethod.toLowerCase() != 'cod';

    setState(() {
      _isLoading = false;
    });
    _controller.forward();

    if (isOnline) {
      setState(() {
        _currentPhase = 2; // Payment Verified
      });

      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) {
          setState(() {
            _currentPhase = 3; // Order Confirmed
          });

          Future.delayed(const Duration(milliseconds: 2200), () {
            if (mounted) {
              _completeAndNavigate(successState);
            }
          });
        }
      });
    } else {
      setState(() {
        _currentPhase = 3; // Order Confirmed
      });

      Future.delayed(const Duration(milliseconds: 2200), () {
        if (mounted) {
          _completeAndNavigate(successState);
        }
      });
    }
  }

  void _completeAndNavigate(PaymentSuccess successState) {
    context.read<CartBloc>().add(LoadCart());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => OrderSuccessPage(
          paymentMethod: successState.paymentMethod,
          paymentStatus: successState.paymentStatus,
          totalAmount: widget.totalAmount,
          orderId: successState.orderId,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isOnline = widget.paymentMethod.toLowerCase() != 'cod';

    final String loadingTitle = isOnline
        ? 'Verifying payment...'
        : 'Placing Order...';
    final String loadingSubtitle = isOnline
        ? 'Please wait while we confirm your payment transaction. Do not close this app.'
        : 'Please wait while we process your cart and register your order.';

    String successTitle = '';
    String successSubtitle = '';
    if (_currentPhase == 2) {
      successTitle = 'Payment Verified!';
      successSubtitle = 'Your transaction was settled successfully.';
    } else if (_currentPhase == 3) {
      successTitle = 'Order Confirmed!';
      successSubtitle =
          'Congratulations! Your StreetCart order has been placed.';
    }

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: CustomerAppColors.background,
        body: BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess && !_flowStarted) {
              final elapsed = DateTime.now()
                  .difference(_loadingStartTime)
                  .inMilliseconds;
              final remaining = 2000 - elapsed;
              if (remaining > 0) {
                _flowStarted = true;
                Future.delayed(Duration(milliseconds: remaining), () {
                  if (mounted) {
                    _startSuccessFlow(state);
                  }
                });
              } else {
                _startSuccessFlow(state);
              }
            } else if (state is PaymentFailure) {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Container(
                  height: 180.h,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 400),
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: CustomerAppColors.primary.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 56.w,
                              height: 56.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CustomerAppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IgnorePointer(
                        ignoring: _isLoading,
                        child: AnimatedOpacity(
                          opacity: !_isLoading ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 500),
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Opacity(
                                    opacity:
                                        (1.0 -
                                        (_controller.value - 0.2).clamp(
                                              0.0,
                                              0.8,
                                            ) /
                                            0.8),
                                    child: Container(
                                      width: 80.w * _rippleAnimation.value,
                                      height: 80.w * _rippleAnimation.value,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.12,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Opacity(
                                    opacity:
                                        (1.0 -
                                        _controller.value.clamp(0.0, 1.0)),
                                    child: Container(
                                      width: 110.w * _rippleAnimation.value,
                                      height: 110.w * _rippleAnimation.value,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withValues(
                                          alpha: 0.06,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        color: CustomerAppColors.success,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: CustomerAppColors.success
                                                .withValues(alpha: 0.3),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.check_rounded,
                                        color: Colors.white,
                                        size: 44.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.15),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(_currentPhase),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isLoading ? loadingTitle : successTitle,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: CustomerAppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          _isLoading ? loadingSubtitle : successSubtitle,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CustomerAppColors.textSecondary,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.storefront,
                        color: Colors.green[700],
                        size: 22.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Street Cart',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[700],
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 64.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
