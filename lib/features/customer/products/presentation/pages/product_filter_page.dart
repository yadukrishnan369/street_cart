import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:street_cart/core/theme/customer/customer_app_colors.dart';

class ProductFilterPage extends StatefulWidget {
  final List<String> categories;
  final String selectedSort;
  final RangeValues priceRange;
  final Set<String> selectedCategories;
  final String? selectedRating;

  const ProductFilterPage({
    super.key,
    required this.categories,
    required this.selectedSort,
    required this.priceRange,
    required this.selectedCategories,
    required this.selectedRating,
  });

  @override
  State<ProductFilterPage> createState() => _ProductFilterPageState();
}

class _ProductFilterPageState extends State<ProductFilterPage> {
  late String _selectedSort;
  late RangeValues _priceRange;
  late Set<String> _selectedCategories;
  String? _selectedRating;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.selectedSort;
    _priceRange = widget.priceRange;
    _selectedCategories = Set<String>.from(widget.selectedCategories);
    _selectedRating = widget.selectedRating;
  }

  void _resetFilters() {
    setState(() {
      _selectedSort = 'Newest';
      _priceRange = const RangeValues(0, 10000);
      _selectedCategories = {'All'};
      _selectedRating = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Filters',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Reset',
              style: TextStyle(
                color: CustomerAppColors.primary,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort By Section
                  Text(
                    'Sort By',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      _buildSortChip('Newest'),
                      _buildSortChip('Popularity'),
                      _buildSortChip('Price: Low to High'),
                      _buildSortChip('Price: High to Low'),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Price Range Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price Range',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '₹${_priceRange.start.round()} - ₹${_priceRange.end.round()}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: CustomerAppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    activeColor: CustomerAppColors.primary,
                    inactiveColor: Colors.grey[200],
                    onChanged: (values) {
                      setState(() {
                        _priceRange = values;
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹0',
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                        Text(
                          '₹10,000',
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Categories Section
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...widget.categories.map((cat) {
                    final isSelected = _selectedCategories.contains(cat);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected ? Colors.black87 : Colors.grey[700],
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cat == 'All') {
                              _selectedCategories = {'All'};
                            } else {
                              _selectedCategories.remove('All');
                              if (isSelected) {
                                _selectedCategories.remove(cat);
                                if (_selectedCategories.isEmpty) {
                                  _selectedCategories.add('All');
                                }
                              } else {
                                _selectedCategories.add(cat);
                              }
                            }
                          });
                        },
                        child: Container(
                          width: 22.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? CustomerAppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? CustomerAppColors.primary
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14.sp,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 24.h),

                  // Minimum Rating Section
                  Text(
                    'Minimum Rating',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildRatingChip('2+'),
                        SizedBox(width: 8.w),
                        _buildRatingChip('3+'),
                        SizedBox(width: 8.w),
                        _buildRatingChip('4+'),
                        SizedBox(width: 8.w),
                        _buildRatingChip('4.5+'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),

          // Show Results Footer Button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[100]!)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'selectedSort': _selectedSort,
                    'priceRange': _priceRange,
                    'selectedCategories': _selectedCategories,
                    'selectedRating': _selectedRating,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomerAppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Show Results',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label) {
    final isSelected = _selectedSort == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSort = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomerAppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildRatingChip(String label) {
    final isSelected = _selectedRating == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedRating = null;
          } else {
            _selectedRating = label;
          }
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? CustomerAppColors.primary.withOpacity(0.08)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? CustomerAppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.star : Icons.star_border,
              size: 16.sp,
              color: isSelected ? CustomerAppColors.primary : Colors.amber,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? CustomerAppColors.primary : Colors.black87,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
