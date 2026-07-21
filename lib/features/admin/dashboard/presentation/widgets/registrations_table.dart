import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/admin/admin_app_colors.dart';
import 'package:street_cart/core/utils/date_formatter.dart';
import 'package:street_cart/features/admin/dashboard/data/models/new_registration_model.dart';

// Registrations Table
class RegistrationsTable extends StatelessWidget {
  final List<NewRegistrationModel> registrations;
  final Function(NewRegistrationModel reg) onReview;

  const RegistrationsTable({
    super.key,
    required this.registrations,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2.8), // Brand Identity
        1: FlexColumnWidth(2.0), // Category
        2: FlexColumnWidth(1.8), // Registered Date
        3: FlexColumnWidth(1.8), // Status
        4: FlexColumnWidth(1.2), // Actions
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(
            color: Color(0xFFF4F5F7),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE8E7ED), width: 1.5),
            ),
          ),
          // Table Title
          children: [
            _buildTableHeaderCell('SHOP NAME'),
            _buildTableHeaderCell('CATEGORY'),
            _buildTableHeaderCell('REGISTERED'),
            _buildTableHeaderCell('STATUS'),
            _buildTableHeaderCell('ACTIONS'),
          ],
        ),
        ...registrations.map((reg) => _buildTableRow(context, reg)),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          color: const Color(0xFF8A8A9E),
        ),
      ),
    );
  }

  TableRow _buildTableRow(BuildContext context, NewRegistrationModel reg) {
    String formattedDate = 'Recently';
    if (reg.createdAt != null) {
      final datePart = DateFormatter.formatToReadableDate(
        reg.createdAt!,
      ).split(',').first;
      final timePart = DateFormatter.formatToTime(reg.createdAt!);
      formattedDate = '$datePart, $timePart';
    }

    return TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0EFF5), width: 1.2),
        ),
      ),
      children: [
        // Brand Identity
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.storefront_outlined,
                  color: const Color(0xFF7B2CBF),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name
                    Text(
                      reg.shopName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E1E2F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    // Registration ID
                    Text(
                      'ID: #${reg.id.substring(0, reg.id.length > 8 ? 8 : reg.id.length).toUpperCase()}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF8A8A9E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Category
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            reg.address.split('•').first.trim(),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2F),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Registered Date
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E1E2F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2.h),
              Text(
                reg.timeAgo,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF8A8A9E),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        // Status Badge
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: reg.isReRegistered
                    ? const Color(0xFFFFF3CD)
                    : const Color(0xFFF4EBFF),
                borderRadius: BorderRadius.circular(100.r),
                border: reg.isReRegistered
                    ? Border.all(color: const Color(0xFFFFEBAA))
                    : null,
              ),
              child: Text(
                reg.isReRegistered ? 'Re-registered' : 'Pending Review',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: reg.isReRegistered
                      ? const Color(0xFF856404)
                      : AdminAppColors.primaryColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),

        // Actions Button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => onReview(reg),
              child: const Text(
                'Review',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AdminAppColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
