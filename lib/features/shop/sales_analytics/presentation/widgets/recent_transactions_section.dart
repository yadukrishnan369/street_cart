import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/shop/shop_app_colors.dart';
import 'package:street_cart/core/theme/shop/shop_text_styles.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/utils/sales_analytics_helper.dart';
import 'package:street_cart/features/shop/sales_analytics/presentation/widgets/recent_transactions_list.dart';

// Recent Transactions Section
class RecentTransactionsSection extends StatefulWidget {
  final List<AnalyticsTransactionItem> transactions;
  final String shopId;
  final ScrollController scrollController;

  const RecentTransactionsSection({
    super.key,
    required this.transactions,
    required this.shopId,
    required this.scrollController,
  });

  @override
  State<RecentTransactionsSection> createState() =>
      _RecentTransactionsSectionState();
}

class _RecentTransactionsSectionState extends State<RecentTransactionsSection> {
  // Value notifier for showing icon for move top
  late final ValueNotifier<bool> _showScrollToTop;

  @override
  void initState() {
    super.initState();
    _showScrollToTop = ValueNotifier<bool>(false);
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (!mounted) return;
    final position = 280.h;
    final show = widget.scrollController.offset > position;
    if (_showScrollToTop.value != show) {
      _showScrollToTop.value = show;
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    _showScrollToTop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                'Sales Transactions',
                style: ShopAppTextStyles.bodyLargeBold.copyWith(
                  fontSize: 16.sp,
                  color: isDark
                      ? ShopAppColors.darkTextPrimary
                      : ShopAppColors.textPrimary,
                ),
              ),
              // Icon for move Top of the page
              ValueListenableBuilder<bool>(
                valueListenable: _showScrollToTop,
                builder: (context, show, child) {
                  if (!show) return const SizedBox.shrink();
                  return IconButton(
                    icon: Icon(
                      Icons.arrow_upward_rounded,
                      color: ShopAppColors.primary,
                      size: 20.sp,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      widget.scrollController.animateTo(
                        0.0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Transaction List
          RecentTransactionsList(
            transactions: widget.transactions,
            shopId: widget.shopId,
          ),
        ],
      ),
    );
  }
}
