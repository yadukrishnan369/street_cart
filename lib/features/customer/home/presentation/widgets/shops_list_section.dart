import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShopsListSection extends StatelessWidget {
  const ShopsListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '142 shops near by you',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildShopCard(index, 0);
            },
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 4,
            itemBuilder: (context, index) {
              return _buildShopCard(index, 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShopCard(int index, int row) {
    final titles = [
      'The Urban Stitch', 
      'Calicut Threads', 
      'Malabar Silks', 
      'Style Icon',
      'Trendy Wear',
      'Kozhikode Cottons',
      'Mens Fashion',
      'Womens Boutique'
    ];
    final ratings = ['4.8', '4.5', '4.9', '4.2', '4.4', '4.7', '4.3', '4.6'];
    final locations = [
      'SM Street, Calicut', 
      'Nadakkavu, Kozhikode', 
      'City Centre', 
      'Mavoor Road',
      'Focus Mall',
      'RP Mall',
      'Hilite Mall',
      'Gokulam Mall'
    ];
    final images = [
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1445205170230-053b83016050?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1582046830578-8386de6db29b?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1581338834647-b0fb40704e21?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1574634534894-89d7576c8259?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1607083206869-4c7672e72a8a?w=200&h=200&fit=crop',
      'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?w=200&h=200&fit=crop',
    ];

    final globalIndex = row * 4 + index;

    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: 74.w,
                  height: 74.h,
                  color: Colors.grey[200],
                  child: Image.network(
                    images[globalIndex % images.length],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titles[globalIndex % titles.length],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 14.sp),
                        SizedBox(width: 4.w),
                        Text(
                          ratings[globalIndex % ratings.length],
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '• Clothing',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      locations[globalIndex % locations.length],
                      style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
