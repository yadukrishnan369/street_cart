import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:street_cart/core/services/location_service.dart';
import 'package:street_cart/core/services/cloudinary_service.dart';
import 'package:street_cart/features/customer/profile/data/models/address_model.dart';
import 'package:street_cart/features/customer/profile/data/models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements IProfileRemoteDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final LocationService locationService;
  final CloudinaryService cloudinaryService;

  ProfileRemoteDataSourceImpl({
    required this.auth,
    required this.firestore,
    required this.locationService,
    required this.cloudinaryService,
  });
  // Get Profile Data
  @override
  Future<ProfileModel?> getProfileData() async {
    try {
      final user = auth.currentUser;
      if (user == null) return null;

      final doc = await firestore.collection('customers').doc(user.uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;

      String locationName = 'Select precise location';
      if (data['location_permission'] == true && data['location'] != null) {
        final loc = data['location'] as Map<String, dynamic>;
        final dynamic lat = loc['latitude'];
        final dynamic lng = loc['longitude'];

        if (lat != null && lng != null) {
          final address = await locationService.getAddressFromCoordinates(
            (lat as num).toDouble(),
            (lng as num).toDouble(),
          );
          if (address != null) {
            locationName = address;
          }
        }
      }

      final Map<String, dynamic> docData = data;

      String? getString(String key) {
        final val = docData[key];
        return (val is String && val.isNotEmpty) ? val : null;
      }

      final String fullName =
          getString('full_name') ?? user.displayName ?? 'User';
      final String email =
          getString('email') ?? user.email ?? 'No email provided';
      final String phone = getString('phone') ?? '';

      return ProfileModel(
        fullName: fullName,
        email: email,
        phone: phone,
        locationName: locationName,
        profileImageUrl: docData['profile_image_url'] ?? user.photoURL ?? '',
      );
    } catch (e) {
      throw Exception('Failed to get profile data: $e');
    }
  }

  // Update Profile Data
  @override
  Future<void> updateProfileData(ProfileModel updatedProfile) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await firestore.collection('customers').doc(user.uid).update({
        ...updatedProfile.toMap(),
        'is_profile_completed': true,
      });

      if (updatedProfile.email.isNotEmpty &&
          updatedProfile.email != user.email) {
        await user.verifyBeforeUpdateEmail(updatedProfile.email);
      }
    } catch (e) {
      throw Exception('Failed to update profile data: $e');
    }
  }

  // Upload Profile Image
  @override
  Future<String?> uploadImage(File file) async {
    try {
      return await cloudinaryService.uploadImage(file);
    } catch (e) {
      throw Exception('Failed to upload image to data source: $e');
    }
  }

  // Remove profile Image
  @override
  Future<void> removeProfileImage() async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await firestore.collection('customers').doc(user.uid).update({
        'profile_image_url': '',
      });
    } catch (e) {
      throw Exception('Failed to remove profile image: $e');
    }
  }

  // Get Address
  @override
  Future<List<AddressModel>> getAddresses() async {
    try {
      final user = auth.currentUser;
      if (user == null) return [];

      final snapshot = await firestore
          .collection('customers')
          .doc(user.uid)
          .collection('addresses')
          .get();

      return snapshot.docs
          .map((doc) => AddressModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get addresses: $e');
    }
  }

  // Add new Address
  @override
  Future<void> addAddress(AddressModel address) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await firestore
          .collection('customers')
          .doc(user.uid)
          .collection('addresses')
          .add(address.toMap());
    } catch (e) {
      throw Exception('Failed to add address: $e');
    }
  }

  // Update Existing Address
  @override
  Future<void> updateAddress(String id, AddressModel address) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await firestore
          .collection('customers')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .update(address.toMap());
    } catch (e) {
      throw Exception('Failed to update address: $e');
    }
  }

  // Delete Address
  @override
  Future<void> deleteAddress(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      await firestore
          .collection('customers')
          .doc(user.uid)
          .collection('addresses')
          .doc(id)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  // Set Defualt Address
  @override
  Future<void> setDefaultAddress(String id) async {
    try {
      final user = auth.currentUser;
      if (user == null) throw Exception('No authenticated user');

      final addressesRef = firestore
          .collection('customers')
          .doc(user.uid)
          .collection('addresses');

      final snapshot = await addressesRef.get();
      final batch = firestore.batch();

      // Check if the address we are clicking is already default
      bool isCurrentlyDefault = false;
      for (var doc in snapshot.docs) {
        if (doc.id == id && doc.data()['isDefault'] == true) {
          isCurrentlyDefault = true;
          break;
        }
      }

      for (var doc in snapshot.docs) {
        if (doc.id == id) {
          batch.update(doc.reference, {'isDefault': !isCurrentlyDefault});
        } else if (!isCurrentlyDefault) {
          if (doc.data()['isDefault'] == true) {
            batch.update(doc.reference, {'isDefault': false});
          }
        }
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }
}
