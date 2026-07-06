class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });

  static List<OnboardingContent> get defaultContents => [
    OnboardingContent(
      title: 'Grow Your Local Business',
      description:
          'Bring your shop online and reach customers around you with our seamless digital platform.',
      image: 'assets/images/shop_onboarding_1.png',
    ),
    OnboardingContent(
      title: 'Manage Orders Easily',
      description:
          'Accept orders, update products, and manage sales effortlessly. Everything you need to grow your business in one place.',
      image: 'assets/images/shop_onboarding_2.png',
    ),
    OnboardingContent(
      title: 'Sell Locally with Confidence',
      description:
          'Connect with nearby buyers based on your delivery area and grow your community business.',
      image: 'assets/images/shop_onboarding_3.png',
    ),
  ];
}
