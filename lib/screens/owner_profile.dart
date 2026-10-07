import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'owner_dashboard.dart';
import 'properties.dart';
import 'manage_bookings.dart';
import 'property_analytics.dart';
import 'rental_requests.dart';
import '../resources/imagescreen.dart';

class ownerprofile extends StatefulWidget {
  const ownerprofile({super.key});

  @override
  State<ownerprofile> createState() => _ownerprofileState();
}

class _ownerprofileState extends State<ownerprofile> {
  int _selectedIndex = 4;

  // Currently logged-in owner UID
  final String? ownerId = FirebaseAuth.instance.currentUser?.uid;

  // ---------------------------------------------------------
  // Format Firestore Timestamp
  // ---------------------------------------------------------
  String _formatMemberSince(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final date = createdAt.toDate();

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      return '${months[date.month - 1]} ${date.year}';
    }

    return 'Recently';
  }

  // ---------------------------------------------------------
  // Get property image from Firestore value
  // ---------------------------------------------------------
  String _getPropertyImage(String imageName) {
    if (imageName == 'property1') {
      return property1;
    }

    if (imageName == 'property2') {
      return property2;
    }

    return property1;
  }

  // ---------------------------------------------------------
  // Get preferred languages
  // ---------------------------------------------------------
  String _getPreferredLanguages(dynamic languages) {
    if (languages is List) {
      final List<String> languageList = languages
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();

      if (languageList.isNotEmpty) {
        return languageList.join(', ');
      }
    }

    return 'Not available';
  }

  // ---------------------------------------------------------
  // Get integer value safely
  // ---------------------------------------------------------
  int _getIntValue(dynamic value) {
    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  // ---------------------------------------------------------
  // Get string value safely
  // ---------------------------------------------------------
  String _getStringValue(
    Map<String, dynamic> data,
    String key,
    String defaultValue,
  ) {
    final value = data[key];

    if (value == null) {
      return defaultValue;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return defaultValue;
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    // -------------------------------------------------------
    // If no owner is logged in
    // -------------------------------------------------------
    if (ownerId == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Please login first",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          // -------------------------------------------------
          // Get currently logged-in owner's document
          // owners/{uid}
          // -------------------------------------------------
          stream: FirebaseFirestore.instance
              .collection('owners')
              .doc(ownerId)
              .snapshots(),

          builder: (context, ownerSnapshot) {
            if (ownerSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff2563EB),
                ),
              );
            }

            if (ownerSnapshot.hasError) {
              return Center(
                child: Text(
                  "Error: ${ownerSnapshot.error}",
                  textAlign: TextAlign.center,
                ),
              );
            }

            if (!ownerSnapshot.hasData ||
                !ownerSnapshot.data!.exists) {
              return const Center(
                child: Text(
                  "Owner profile not found",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            // -------------------------------------------------
            // Owner Firestore Data
            // -------------------------------------------------
            final Map<String, dynamic> ownerData =
                ownerSnapshot.data!.data() ??
                    <String, dynamic>{};

            final String fullName = _getStringValue(
              ownerData,
              'fullName',
              'Owner',
            );

            final String email = _getStringValue(
              ownerData,
              'email',
              '',
            );

            final String mobile = _getStringValue(
              ownerData,
              'mobile',
              '',
            );

            final String city = _getStringValue(
              ownerData,
              'city',
              '',
            );

            final String ownerType = _getStringValue(
              ownerData,
              'ownerType',
              '',
            );

            final bool isVerified =
                ownerData['isVerified'] == true;

            final String memberSince =
                _formatMemberSince(
              ownerData['createdAt'],
            );

            // -------------------------------------------------
            // Dynamic Profile Data
            // -------------------------------------------------

            final int reviewsCount =
                _getIntValue(
              ownerData['reviewsCount'],
            );

            final String preferredLanguages =
                _getPreferredLanguages(
              ownerData['preferredLanguages'],
            );

            final int responseRate =
                _getIntValue(
              ownerData['responseRate'],
            );

            final String averageResponseTime =
                _getStringValue(
              ownerData,
              'averageResponseTime',
              'Not available',
            );

            final String aboutText =
                _getStringValue(
              ownerData,
              'about',
              '$ownerType property owner based in '
                  '$city. Manage your properties and '
                  'rental activities easily with RentEasy.',
            );

            final String reviewerName =
                _getStringValue(
              ownerData,
              'reviewerName',
              'Tenant',
            );

            final int reviewRating =
                _getIntValue(
              ownerData['reviewRating'],
            );

            final String reviewText =
                _getStringValue(
              ownerData,
              'reviewText',
              'No review available.',
            );

            // -------------------------------------------------
            // Properties Stream
            // -------------------------------------------------
            return StreamBuilder<
                QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('properties')
                  .where(
                    'ownerId',
                    isEqualTo: ownerId,
                  )
                  .snapshots(),

              builder: (context, propertySnapshot) {
                if (propertySnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff2563EB),
                    ),
                  );
                }

                if (propertySnapshot.hasError) {
                  return Center(
                    child: Text(
                      "Error loading properties:\n"
                      "${propertySnapshot.error}",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // -------------------------------------------------
                // Get properties
                // -------------------------------------------------
                final List<
                    QueryDocumentSnapshot<
                        Map<String, dynamic>>> propertyDocs =
                    propertySnapshot.data?.docs ?? [];

                // -------------------------------------------------
                // Calculate Statistics
                // -------------------------------------------------
                final int totalProperties =
                    propertyDocs.length;

                final int activeProperties =
                    propertyDocs.where((doc) {
                  final data = doc.data();

                  return data['status']
                          ?.toString()
                          .toLowerCase() ==
                      'active';
                }).length;

                final int rentedProperties =
                    propertyDocs.where((doc) {
                  final data = doc.data();

                  return data['status']
                          ?.toString()
                          .toLowerCase() ==
                      'rented';
                }).length;

                // -------------------------------------------------
                // Calculate average rating
                // -------------------------------------------------
                double totalRating = 0;
                int ratingCount = 0;

                for (final doc in propertyDocs) {
                  final data = doc.data();

                  final dynamic rating =
                      data['rating'];

                  if (rating is num && rating > 0) {
                    totalRating += rating.toDouble();
                    ratingCount++;
                  }
                }

                final double averageRating =
                    ratingCount > 0
                        ? totalRating / ratingCount
                        : 0;

                return Column(
                  children: [
                    // =================================================
                    // HEADER
                    // =================================================
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              size: 24,
                            ),
                          ),

                          const Expanded(
                            child: Center(
                              child: Text(
                                "Owner Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Share profile selected",
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.share_outlined,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // =================================================
                    // PROFILE CONTENT
                    // =================================================
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // =================================================
                            // PROFILE OVERVIEW
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.all(20),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        width: 90,
                                        height: 90,
                                        decoration:
                                            const BoxDecoration(
                                          shape:
                                              BoxShape.circle,
                                          color: Color(
                                            0xffEEF1F7,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),

                                      // Verification badge
                                      if (isVerified)
                                        Positioned(
                                          right: 0,
                                          bottom: 4,
                                          child:
                                              Container(
                                            width: 26,
                                            height: 26,
                                            decoration:
                                                const BoxDecoration(
                                              shape:
                                                  BoxShape.circle,
                                              color:
                                                  Color(
                                                0xff2563EB,
                                              ),
                                            ),
                                            child:
                                                const Icon(
                                              Icons.check,
                                              size: 17,
                                              color:
                                                  Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Dynamic Name
                                  Text(
                                    fullName,
                                    style:
                                        const TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // Dynamic Member Since
                                  Text(
                                    "Member since "
                                    "$memberSince",
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Dynamic Average Rating
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        size: 18,
                                        color:
                                            Colors.orange,
                                      ),

                                      const SizedBox(
                                        width: 4,
                                      ),

                                      Text(
                                        averageRating > 0
                                            ? averageRating
                                                .toStringAsFixed(
                                                1,
                                              )
                                            : "0.0",
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 4,
                                      ),

                                      Text(
                                        "($reviewsCount Reviews)",
                                        style:
                                            const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 18),

                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                            OutlinedButton(
                                          onPressed: () {
                                            ScaffoldMessenger
                                                    .of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text(
                                                  "Chat opened",
                                                ),
                                              ),
                                            );
                                          },
                                          style:
                                              OutlinedButton
                                                  .styleFrom(
                                            foregroundColor:
                                                const Color(
                                              0xff2563EB,
                                            ),
                                            side:
                                                const BorderSide(
                                              color: Color(
                                                0xff2563EB,
                                              ),
                                            ),
                                          ),
                                          child:
                                              const Text(
                                            "Chat Now",
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 12,
                                      ),

                                      Expanded(
                                        child:
                                            ElevatedButton(
                                          onPressed: () {
                                            ScaffoldMessenger
                                                    .of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text(
                                                  "Calling owner...",
                                                ),
                                              ),
                                            );
                                          },
                                          style:
                                              ElevatedButton
                                                  .styleFrom(
                                            backgroundColor:
                                                const Color(
                                              0xff2563EB,
                                            ),
                                            foregroundColor:
                                                Colors.white,
                                          ),
                                          child:
                                              const Text(
                                            "Call Owner",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // STATISTICS
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 22,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceAround,
                                children: [
                                  _StatItem(
                                    value:
                                        totalProperties
                                            .toString(),
                                    title:
                                        "Total Properties",
                                  ),
                                  _StatItem(
                                    value:
                                        activeProperties
                                            .toString(),
                                    title:
                                        "Active Listings",
                                  ),
                                  _StatItem(
                                    value:
                                        rentedProperties
                                            .toString(),
                                    title:
                                        "Properties Rented",
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // ABOUT
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.all(20),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    "About $fullName",
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Text(
                                    aboutText,
                                    style:
                                        const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // CONTACT INFORMATION
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.all(20),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    "Contact Information",
                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 18),

                                  _ContactItem(
                                    icon: Icons
                                        .phone_outlined,
                                    title: "Phone",
                                    value: mobile,
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .email_outlined,
                                    title: "Email",
                                    value: email,
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .location_on_outlined,
                                    title: "City",
                                    value: city,
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .person_outline,
                                    title: "Owner Type",
                                    value: ownerType,
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .verified_outlined,
                                    title: "Verification",
                                    value: isVerified
                                        ? "Verified Owner"
                                        : "Not Verified",
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .language_outlined,
                                    title:
                                        "Preferred Languages",
                                    value:
                                        preferredLanguages,
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon: Icons
                                        .speed_outlined,
                                    title:
                                        "Response Rate",
                                    value:
                                        "$responseRate% Rate",
                                  ),

                                  const SizedBox(height: 15),

                                  _ContactItem(
                                    icon:
                                        Icons.access_time,
                                    title: "Avg. Time",
                                    value:
                                        "$averageResponseTime Avg. Time",
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // LISTED PROPERTIES
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.all(20),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      const Text(
                                        "Listed Properties",
                                        style:
                                            TextStyle(
                                          fontSize: 18,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const properties(),
                                            ),
                                          );
                                        },
                                        child:
                                            const Text(
                                          "View all",
                                          style:
                                              TextStyle(
                                            color:
                                                Color(
                                              0xff2563EB,
                                            ),
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // -----------------------------------------
                                  // FIRESTORE PROPERTY LIST
                                  // -----------------------------------------
                                  propertyDocs.isEmpty
                                      ? const SizedBox(
                                          height: 100,
                                          child: Center(
                                            child: Text(
                                              "No properties found",
                                              style:
                                                  TextStyle(
                                                color:
                                                    Colors
                                                        .grey,
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox(
                                          height: 245,
                                          child: ListView
                                              .separated(
                                            scrollDirection:
                                                Axis
                                                    .horizontal,
                                            itemCount:
                                                propertyDocs
                                                    .length,
                                            separatorBuilder:
                                                (context,
                                                    index) {
                                              return const SizedBox(
                                                width: 15,
                                              );
                                            },
                                            itemBuilder:
                                                (context,
                                                    index) {
                                              final Map<
                                                      String,
                                                      dynamic>
                                                  propertyData =
                                                  propertyDocs[
                                                          index]
                                                      .data();

                                              final String
                                                  propertyName =
                                                  propertyData[
                                                              'propertyName']
                                                          ?.toString() ??
                                                      'Property';

                                              final String
                                                  location =
                                                  propertyData[
                                                              'location']
                                                          ?.toString() ??
                                                      '';

                                              final String
                                                  rent =
                                                  propertyData[
                                                              'rent']
                                                          ?.toString() ??
                                                      '';

                                              final dynamic
                                                  ratingValue =
                                                  propertyData[
                                                      'rating'];

                                              final String
                                                  rating =
                                                  ratingValue
                                                          is num
                                                      ? ratingValue
                                                          .toStringAsFixed(
                                                          1,
                                                        )
                                                      : '0.0';

                                              final String
                                                  imageName =
                                                  propertyData[
                                                              'image']
                                                          ?.toString() ??
                                                      'property1';

                                              return _PropertyCard(
                                                image:
                                                    _getPropertyImage(
                                                  imageName,
                                                ),
                                                title:
                                                    propertyName,
                                                location:
                                                    location,
                                                price:
                                                    rent,
                                                rating:
                                                    rating,
                                              );
                                            },
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // =================================================
                            // TENANT REVIEW
                            // =================================================
                            Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              padding:
                                  const EdgeInsets.all(20),
                              decoration:
                                  BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  const Text(
                                    "Tenant Review",
                                    style:
                                        TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 23,
                                        child: Icon(
                                          Icons.person,
                                        ),
                                      ),

                                      const SizedBox(
                                        width: 12,
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            reviewerName,
                                            style:
                                                const TextStyle(
                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 4,
                                          ),

                                          Row(
                                            children:
                                                List.generate(
                                              5,
                                              (index) {
                                                return Icon(
                                                  index <
                                                          reviewRating
                                                      ? Icons
                                                          .star
                                                      : Icons
                                                          .star_border,
                                                  size: 16,
                                                  color:
                                                      Colors
                                                          .orange,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  Text(
                                    reviewText,
                                    style:
                                        const TextStyle(
                                      color: Colors.grey,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 120),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),

      // =========================================================
      // STICKY BUTTONS
      // =========================================================
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          12,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const managebookings(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      const Color(0xff2563EB),
                  side: const BorderSide(
                    color: Color(0xff2563EB),
                  ),
                ),
                child: const Text(
                  "Book Visit",
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const rentalrequests(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff2563EB),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Request Rental",
                ),
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // BOTTOM NAVIGATION
      // =========================================================
      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(0xff2563EB),

        unselectedItemColor:
            const Color(0xff64748B),

        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const ownerdashboard(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const properties(),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const managebookings(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const propertyanalytics(),
              ),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard_outlined,
            ),
            activeIcon: Icon(
              Icons.dashboard,
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_work_outlined,
            ),
            activeIcon: Icon(
              Icons.home_work,
            ),
            label: "Properties",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_month_outlined,
            ),
            activeIcon: Icon(
              Icons.calendar_month,
            ),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.analytics_outlined,
            ),
            activeIcon: Icon(
              Icons.analytics,
            ),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            activeIcon: Icon(
              Icons.person,
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

// =============================================================
// STAT ITEM
// =============================================================

class _StatItem extends StatelessWidget {
  final String value;
  final String title;

  const _StatItem({
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

// =============================================================
// CONTACT ITEM
// =============================================================

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xffF1F3F8),
            borderRadius:
                BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.grey,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value.isEmpty
                    ? "Not available"
                    : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =============================================================
// PROPERTY CARD
// =============================================================

class _PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;
  final String rating;

  const _PropertyCard({
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xffE6E8EF),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            child: Image.asset(
              image,
              height: 125,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  location,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        maxLines: 1,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color:
                              Colors.orange,
                        ),

                        const SizedBox(
                          width: 3,
                        ),

                        Text(
                          rating,
                          style:
                              const TextStyle(
                            fontSize: 12,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}