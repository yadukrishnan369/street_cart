class CustomerConstants {
  // support information
  static const String supportEmail = 'adminstreetcart@gmail.com';
  static const String supportPhoneNumber = '9745303779';
  static const String supportHours = '9 AM - 9 PM, Everyday';

  // support categories
  static const List<Map<String, dynamic>> supportCategories = [
    {
      'title': 'ORDERS & DELIVERY',
      'items': [
        {
          'title': 'Where is my order?',
          'content':
              "You can track your order in the 'Orders' tab. The map will show the real-time location of the shop once they've started the delivery.",
        },
        {
          'title': 'Changing delivery address',
          'content':
              'To change your delivery address, please moving to saved addresses and select new address immediately before placing the order. After the shop starts moving delivery the right address.',
        },
        {
          'title': 'Shipping fees and times',
          'content':
              'Fees are totally free based on shops. Delivery usually takes 01-07 days once the shop accepts your request.',
        },
      ],
    },
    {
      'title': 'RETURNS & REFUNDS',
      'items': [
        {
          'title': 'How do I return an item?',
          'content':
              "Click on the order in your history and select 'Request Return'. Please provide a photo of the item and a reason for the return.",
        },
        {
          'title': 'Refund policy and timelines',
          'content':
              'Refunds are processed within 3-5 business days back to your original payment method once the return is approved.',
        },
      ],
    },
    {
      'title': 'PAYMENTS',
      'items': [
        {
          'title': 'Payment methods accepted',
          'content':
              'We accept Cash on Delivery, Google Pay, phonePay and All UPI payments based on the shops.',
        },
      ],
    },
    {
      'title': 'ACCOUNT SETTINGS',
      'items': [
        {
          'title': 'Changing password',
          'content':
              "Go to Settings > Change Password. For security, you'll need to enter your current password first and then you can change your password.",
        },
        {
          'title': 'Deleting my account',
          'content':
              'You can delete your account from Settings > Delete Account and enter your password. This action is permanent and will remove all your data.',
        },
      ],
    },
  ];

  // FAQ data
  static const List<Map<String, String>> faqs = [
    {
      'question': 'How do I track my order?',
      'answer':
          "You can track your order in real-time through the 'Orders' tab. Once a street cart shops accepts your request, you will see their live updation on the integrated structure and receive status updates until it arrives at your door.",
    },
    {
      'question': 'What is the return policy?',
      'answer':
          'Street Cart allows returns within 7 days for perishable items and non-perishable items if they are damaged or not as described.',
    },
    {
      'question': 'How do local shops work on Street Cart?',
      'answer':
          'Local shops register on our platform to reach more customers. They manage their own inventory and deliveries in real-time.',
    },
    {
      'question': 'Is there a delivery fee?',
      'answer':
          'Delivery fees vary based on the shops. You can see the exact fee before placing your order.',
    },
    {
      'question': 'How can I contact customer support?',
      'answer':
          'You can reach our support team via the Contact Support page. We are available via phone and email from 9 AM to 9 PM daily.',
    },
  ];

  // legal content
  static const String privacyPolicy = '''
# Street Cart Privacy
Last updated: October 24, 2023

## 1. Information We Collect
To provide you with the best experience on Street Cart, we collect information that identifies, relates to, describes, or is reasonably capable of being associated with you.

**Account Data:** Name, email address, and phone number when you register.
**Transaction Info:** Details about items purchased, delivery address, and payment confirmation.
**Device Data:** IP address, browser type, and operating system identifiers.

## 2. How We Use Data
We use the information we collect to operate, maintain, and provide the features of the Street Cart service. This includes processing your orders, managing your wishlist, and providing personalized recommendations based on your shopping habits.

## 3. Data Sharing
We do not sell your personal data. We share your information only with:
- Service providers such as delivery partners and payment processors are strictly limited to using your data only for the fulfillment of requested services.

## 4. Security
Street Cart implements industry-standard encryption and security measures to protect your data. While we strive to use commercially acceptable means to protect your personal information, we cannot guarantee its absolute security.

## 5. Your Rights
You have the right to access, correct, or delete your personal information at any time through your Profile settings. If you have questions about your data, please contact our privacy officer.
''';

  static const String termsConditions = '''
# Street Cart Service Agreement
Last updated: October 24, 2023

## 1. Introduction
Welcome to Street Cart. These terms and conditions outline the rules and regulations for the use of our platform, mobile application, and the delivery services we coordinate for local shops. By accessing this platform, we assume you accept these terms and conditions.

## 2. Delivery Terms
Street Cart acts as a bridge between local vendors and consumers. Delivery times provided are estimates and may vary based on traffic, weather, or shop preparation times.
- 'Minimum' delivery radius is currently 5km from the shop location.
- Perishable goods must be accepted immediately upon arrival.
- Street Cart is not liable for minor delays caused by vendor preparation.

## 3. User Responsibilities
As a user of Street Cart, you agree to:
- Provide accurate delivery addresses and contact information.
- Be present or available at the specified delivery location.
- Treat delivery partners with respect and courtesy.

## 4. Payments & Refunds
All payments are processed securely through our authorized payment gateways. Refunds for cancellations are subject to the vendor's specific return policy and the stage of order preparation.
''';

  static const String aboutAppDescription =
      "Our mission is to empower local vendors across India by providing a modern platform to reach customers directly, ensuring fresh products and community growth.";
}
