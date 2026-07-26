import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:street_cart/core/router/admin/route_paths.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/debouncer.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_bloc.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_event.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_state.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/reviews_table.dart';
import 'package:street_cart/shared/widgets/admin_pagination.dart';
import 'package:street_cart/shared/widgets/custom_admin_search_bar.dart';

// Reviews List Container
class ReviewsListContainer extends StatefulWidget {
  final bool isWide;
  final bool isLoading;
  final AdminReviewsLoaded loadedState;

  const ReviewsListContainer({
    super.key,
    required this.isWide,
    required this.isLoading,
    required this.loadedState,
  });

  @override
  State<ReviewsListContainer> createState() => _ReviewsListContainerState();
}

class _ReviewsListContainerState extends State<ReviewsListContainer> {
  late final TextEditingController _searchController;
  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.loadedState.searchQuery,
    );
  }

  @override
  void didUpdateWidget(covariant ReviewsListContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.loadedState.searchQuery != widget.loadedState.searchQuery) {
      _searchController.text = widget.loadedState.searchQuery;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AdminReviewsBloc>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFE8E7ED), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E1E2F).withOpacity(0.02),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Header Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomAdminSearchBar(
                  hintText: 'Search by customer, product, or keyword...',
                  controller: _searchController,
                  width: widget.isWide ? 380.w : 240.w,
                  onChanged: (val) {
                    _debouncer.run(() {
                      bloc.add(SearchQueryChanged(val));
                    });
                  },
                ),
              ],
            ),
          ),

          // Linear Progress Indicator for search
          if (widget.isLoading)
            const LinearProgressIndicator(
              color: AdminAppColors.primaryColor,
              backgroundColor: Colors.transparent,
              minHeight: 2,
            )
          else
            const SizedBox(height: 2),

          // Review Table Widget
          ReviewsTable(
            reviews: widget.loadedState.paginatedReviews,
            productNames: widget.loadedState.productNames,
            onViewDetail: (r) async {
              await context.push(
                RoutePaths.reviewDetails.replaceAll(':id', r.id),
              );
              if (mounted) {
                bloc.add(LoadAdminReviewsRequested());
              }
            },
          ),

          // Pagination
          if (widget.loadedState.filteredReviews.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.all(24.w),
              child: AdminPagination(
                currentPage: widget.loadedState.currentPage,
                totalPages: widget.loadedState.totalPages,
                onPageChanged: (page) {
                  bloc.add(PageChanged(page));
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
