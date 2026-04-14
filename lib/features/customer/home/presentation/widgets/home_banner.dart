import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> banners = [
    {
      'title': 'EXCLUSIVE LOCAL OFFER',
      'subtitle': 'Malabar Fashion Fest',
      'discount': 'UP TO 50% OFF',
      'image': 'https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?auto=format&fit=crop&q=80',
    },
    {
      'title': 'NEW ARRIVALS',
      'subtitle': 'The Urban Stitch',
      'discount': 'UP TO 20% OFF',
      'image': 'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&q=80',
    },
    {
      'title': 'WEEKEND SALE',
      'subtitle': 'Calicut Threads',
      'discount': 'UP TO 40% OFF',
      'image': 'https://images.unsplash.com/photo-1567401893414-76b7b1e5a7a5?auto=format&fit=crop&q=80',
    },
    {
      'title': 'FESTIVE COLLECTION',
      'subtitle': 'Malabar Silks',
      'discount': 'UP TO 15% OFF',
      'image': 'https://images.unsplash.com/photo-1582046830578-8386de6db29b?auto=format&fit=crop&q=80',
    },
    {
      'title': 'GRAND OPENING',
      'subtitle': 'Trendy Wear',
      'discount': 'UP TO 10% OFF',
      'image': 'https://images.unsplash.com/photo-1581338834647-b0fb40704e21?auto=format&fit=crop&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;
        if (nextPage >= banners.length) {
          nextPage = 0;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 160.h,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  image: DecorationImage(
                    image: NetworkImage(banner['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Gradient overlay for text readability
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            banner['title']!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            banner['subtitle']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              banner['discount']!,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: _currentPage == index ? 12.w : 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.blue.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
