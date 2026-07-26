import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/di/dependency_injection.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/reviews_header_stats.dart';
import 'package:street_cart/features/admin/reviews/presentation/widgets/reviews_list_container.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_bloc.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_event.dart';
import 'package:street_cart/features/admin/reviews/presentation/bloc/admin_reviews_state.dart';
import 'package:street_cart/shared/widgets/admin_error_view.dart';
import 'package:street_cart/shared/widgets/custom_snackbar.dart';

// Admin Reviews Page
class AdminReviewsPage extends StatefulWidget {
  const AdminReviewsPage({super.key});

  @override
  State<AdminReviewsPage> createState() => _AdminReviewsPageState();
}

class _AdminReviewsPageState extends State<AdminReviewsPage> {
  AdminReviewsLoaded? _lastLoadedState;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AdminReviewsBloc>()..add(LoadAdminReviewsRequested()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        body: SafeArea(
          child: BlocConsumer<AdminReviewsBloc, AdminReviewsState>(
            listener: (context, state) {
              if (state is AdminReviewsError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  isError: true,
                );
              }
            },
            builder: (context, state) {
              if (state is AdminReviewsLoaded) {
                _lastLoadedState = state;
              }

              if (state is AdminReviewsLoading && _lastLoadedState == null) {
                return const Center(child: CircularProgressIndicator());
              }
              // Error View
              if (_lastLoadedState == null) {
                if (state is AdminReviewsError) {
                  return AdminErrorView(
                    message: state.message,
                    onRetry: () => context.read<AdminReviewsBloc>().add(
                      LoadAdminReviewsRequested(),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }

              final loadedState = _lastLoadedState!;
              final isLoading = state is AdminReviewsLoading;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 900;
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 40.w : 20.w,
                      vertical: 32.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Statistics Cards
                        ReviewsHeaderStats(
                          totalReviews: loadedState.totalReviews,
                          averageRating: loadedState.averageRating,
                          isWide: isWide,
                        ),
                        SizedBox(height: 32.h),

                        // Review search and Table Container
                        ReviewsListContainer(
                          isWide: isWide,
                          isLoading: isLoading,
                          loadedState: loadedState,
                        ),
                      ],
                    ),
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
