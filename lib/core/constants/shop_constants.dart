class ShopConstants {
  static const String supportEmail = 'yadukrish9656@gmail.com';
  static const String supportPhoneNumber = '9745303779';
  static const String supportHours = 'Monday to Friday, 9:00 AM - 6:00 PM EST';

  static const String aboutAppDescription =
      "Street Cart is dedicated to supporting local fashion shops by providing a digital platform to showcase unique styles and reach a wider Customers. We believe in the power of community-driven retail and the rich heritage of India's textile industry.";

  static const String privacyPolicy = '''
At Street Cart, we are committed to protecting the privacy and security of our merchant partners. This privacy policy outlines how we handle your personal and business data when you use our mobile application and commerce services.

1. Data Collection
We collect information necessary to operate your digital storefront, including:
- Business registration details and legal name.
- Contact information (email, phone, business address).
- Payment processing information via secure providers.
- Inventory and sales transaction data.

2. Use of Information
Your data is primarily used to provide and improve Street Cart services. This includes processing orders, calculating analytics for your dashboard, and providing customer support. We never sell your personal data to third-party advertisers.

3. Security Measures
We implement industry-standard encryption (AES-256) for all data at rest and in transit. Access to merchant data is strictly limited to authorized personnel only.
''';

  static const String termsConditions = '''
1. Acceptance of Terms
Welcome to Street Cart. By using our platform to manage your shop, you agree to comply with and be bound by the following terms and conditions of use, which together with our privacy policy govern Street Cart's relationship with you.

2. Merchant Responsibilities
As a shop owner on Street Cart, you are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.
- You must provide accurate information regarding your business and products.
- You are responsible for fulfilling orders in a timely manner.
- You must comply with all local tax and business regulations.

3. Fees and Payments
Street Cart charges a processing fee on each transaction completed through the platform. These fees are subject to change with a 30-day notice. All payouts are processed within 3-5 business days of order completion.

4. Prohibited Content
Users may not list items that are illegal, hazardous, or infringe on the intellectual property rights of others. Street Cart reserves the right to remove any product listing that violates these terms.

5. Privacy and Data
We value your privacy. Merchant data is used solely for the purpose of facilitating transactions and improving our service. We do not sell your business data to third parties.

6. Limitation of Liability
Street Cart shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the service.
''';

  static const List<Map<String, dynamic>> helpSupportCategories = [
    {
      'title': 'Account & Security',
      'subtitle': 'Manage login and profile safety',
      'items': [
        {
          'question': 'How do I change my shop password?',
          'answer': 'Go to Settings > Change Password. Enter your current password and your new password to update.',
        },
        {
          'question': 'Can I delete my account?',
          'answer': 'Yes, you can delete your account by going to Settings > Delete Account. For security reasons, you will need to verify your password before confirmation.',
        },
      ],
    },
    {
      'title': 'Shop Customization',
      'subtitle': 'Themes, domains, and branding',
      'items': [
        {
          'question': 'Updating shop profile picture',
          'answer': 'Go to Profile > Edit Profile Details and tap the camera icon on your profile picture to upload a new one from gallery or camera.',
        },
        {
          'question': 'Changing shop name or description',
          'answer': 'You can edit your shop name, description, and other details by going to Profile > Edit Profile Details.',
        },
      ],
    },
    {
      'title': 'Shipping & Delivery',
      'subtitle': 'Setup carriers and rates',
      'items': [
        {
          'question': 'How to manage multiple locations?',
          'answer': 'Under location configurations in profile settings, you can register and update multiple outlets or street cart locations.',
        },
        {
          'question': 'Fulfilling orders and shipping',
          'answer': 'Once an order is accepted, prepare the items and update status to "Out for Delivery" so customers can track you.',
        },
      ],
    },
    {
      'title': 'Marketing & Sales',
      'subtitle': 'Coupons and SEO guides',
      'items': [
        {
          'question': 'Adding product promotions',
          'answer': 'You can apply discounts and promotional pricing to your products from the Products management screen.',
        },
        {
          'question': 'SEO and Catalog optimization',
          'answer': 'Use descriptive titles and high-quality images for your products to rank higher in customer searches.',
        },
      ],
    },
  ];

  static const List<Map<String, dynamic>> faqCategories = [
    {
      'title': 'Shop Management',
      'faqs': [
        {
          'question': 'How do I change my shop hours?',
          'answer': 'To change your operating hours, go to Profile > Shop Settings > Operating Hours. You can set specific times for each day of the week or mark your shop as temporarily closed. Changes take effect immediately on the customer app.',
        },
        {
          'question': 'Adding new products to my catalog',
          'answer': 'Go to the Products tab and click on the "Add Product" button. You can add image, product name, price, description, and category. Click save to publish the product to customers.',
        },
        {
          'question': 'Updating shop profile picture',
          'answer': 'Go to Profile > Edit Profile Details. Tap on your profile image or click the edit icon to choose a new photo from your gallery. Save changes to update.',
        },
        {
          'question': 'How to manage multiple locations?',
          'answer': 'Under settings, select locations configuration to register multiple outlets or street carts. You can customize the location details for each cart.',
        },
      ],
    },
    {
      'title': 'Orders & Delivery',
      'faqs': [
        {
          'question': 'How do I accept/reject orders?',
          'answer': 'When an order is received, go to the Orders tab. You will see option to accept or reject the order. An accepted order is ready for delivery.',
        },
        {
          'question': 'Changing delivery status',
          'answer': 'Once you start delivery, change status to "Out for Delivery". After delivery is complete, change status to "Delivered".',
        },
      ],
    },
    {
      'title': 'Payments',
      'faqs': [
        {
          'question': 'When do I receive payments?',
          'answer': 'Payments for Cash on Delivery are collected directly. For online modes, settlements are processed in 2-3 business days.',
        },
      ],
    },
  ];
}
