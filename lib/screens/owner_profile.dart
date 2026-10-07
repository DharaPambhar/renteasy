import 'package:flutter/material.dart';

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

  // =========================================================
  // STATIC OWNER DATA
  // =========================================================

  final String fullName = 'Dhara';
  final String email = 'dh@gmail.com';
  final String mobile = '1236547890';
  final String city = 'Rajkot';
  final String ownerType = 'Individual';

  final bool isVerified = false;

  final String memberSince = 'Oct 2026';

  final int reviewsCount = 124;

  final String preferredLanguages =
      'English, Gujarati, Hindi';

  final int responseRate = 98;

  final String averageResponseTime = '2h';

  final String aboutText =
      'Individual property owner based in Rajkot. '
      'Manage your properties and rental activities '
      'easily with RentEasy.';

  final String reviewerName = 'Anish Sharma';

  final int reviewRating = 5;

  final String reviewText =
      'Very helpful and responsive owner. '
      'The property was exactly as described and '
      'the overall rental experience was excellent.';

  // =========================================================
  // STATIC PROPERTY DATA
  // =========================================================

  final List<Map<String, dynamic>> propertyList = [
    {
      'propertyName': 'The Aura - Luxury Loft',
      'location': 'Grand Avenue, Downtown, NYC',
      'rent': '₹4,250/month',
      'rating': 4.9,
      'image': 'property1',
    },
    {
      'propertyName': 'Sunset Studio',
      'location': 'Downtown, NYC',
      'rent': '₹2,850/month',
      'rating': 4.7,
      'image': 'property2',
    },
    {
      'propertyName': 'Modern City Apartment',
      'location': 'Central Avenue, NYC',
      'rent': '₹3,600/month',
      'rating': 4.8,
      'image': 'property1',
    },
  ];

  // =========================================================
  // GET PROPERTY IMAGE
  // =========================================================

  String _getPropertyImage(String imageName) {
    if (imageName == 'property1') {
      return property1;
    }

    if (imageName == 'property2') {
      return property2;
    }

    return property1;
  }

  @override
  Widget build(BuildContext context) {
    // =======================================================
    // STATIC PROPERTY STATISTICS
    // =======================================================

    final int totalProperties = propertyList.length;

    final int activeProperties = 2;

    final int rentedProperties = 1;

    // =======================================================
    // AVERAGE RATING
    // =======================================================

    double totalRating = 0;

    for (final property in propertyList) {
      totalRating +=
          (property['rating'] as num).toDouble();
    }

    final double averageRating =
        totalRating / propertyList.length;

    return Scaffold(
      backgroundColor: const Color(0xffF7F8FC),

      body: SafeArea(
        child: Column(
          children: [

            // =================================================
            // HEADER
            // =================================================

            Padding(
              padding: const EdgeInsets.symmetric(
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
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
                                  shape: BoxShape.circle,
                                  color: Color(0xffEEF1F7),
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
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration:
                                        const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Color(0xff2563EB),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      size: 17,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Name
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // Member Since
                          Text(
                            "Member since $memberSince",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Average Rating
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [

                              const Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.orange,
                              ),

                              const SizedBox(width: 4),

                              Text(
                                averageRating
                                    .toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(width: 4),

                              Text(
                                "($reviewsCount Reviews)",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [

                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text("Chat opened"),
                                      ),
                                    );
                                  },
                                  style:
                                      OutlinedButton.styleFrom(
                                    foregroundColor:
                                        const Color(
                                      0xff2563EB,
                                    ),
                                    side:
                                        const BorderSide(
                                      color:
                                          Color(0xff2563EB),
                                    ),
                                  ),
                                  child: const Text(
                                    "Chat Now",
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(
                                            context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Calling owner...",
                                        ),
                                      ),
                                    );
                                  },
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(
                                      0xff2563EB,
                                    ),
                                    foregroundColor:
                                        Colors.white,
                                  ),
                                  child: const Text(
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [

                          _StatItem(
                            value:
                                totalProperties.toString(),
                            title: "Total Properties",
                          ),

                          _StatItem(
                            value:
                                activeProperties.toString(),
                            title: "Active Listings",
                          ),

                          _StatItem(
                            value:
                                rentedProperties.toString(),
                            title: "Properties Rented",
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "About $fullName",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            aboutText,
                            style: const TextStyle(
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Contact Information",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 18),

                          _ContactItem(
                            icon: Icons.phone_outlined,
                            title: "Phone",
                            value: mobile,
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon: Icons.email_outlined,
                            title: "Email",
                            value: email,
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon:
                                Icons.location_on_outlined,
                            title: "City",
                            value: city,
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon: Icons.person_outline,
                            title: "Owner Type",
                            value: ownerType,
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon:
                                Icons.verified_outlined,
                            title: "Verification",
                            value: isVerified
                                ? "Verified Owner"
                                : "Not Verified",
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon:
                                Icons.language_outlined,
                            title:
                                "Preferred Languages",
                            value:
                                preferredLanguages,
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon: Icons.speed_outlined,
                            title: "Response Rate",
                            value:
                                "$responseRate% Rate",
                          ),

                          const SizedBox(height: 15),

                          _ContactItem(
                            icon: Icons.access_time,
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              const Text(
                                "Listed Properties",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const properties(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "View all",
                                  style: TextStyle(
                                    color:
                                        Color(0xff2563EB),
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Static property list
                          propertyList.isEmpty
                              ? const SizedBox(
                                  height: 100,
                                  child: Center(
                                    child: Text(
                                      "No properties found",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 245,
                                  child: ListView.separated(
                                    scrollDirection:
                                        Axis.horizontal,
                                    itemCount:
                                        propertyList.length,
                                    separatorBuilder:
                                        (context, index) {
                                      return const SizedBox(
                                        width: 15,
                                      );
                                    },
                                    itemBuilder:
                                        (context, index) {

                                      final propertyData =
                                          propertyList[index];

                                      final String
                                          propertyName =
                                          propertyData[
                                                  'propertyName']
                                              .toString();

                                      final String
                                          location =
                                          propertyData[
                                                  'location']
                                              .toString();

                                      final String rent =
                                          propertyData[
                                                  'rent']
                                              .toString();

                                      final double rating =
                                          (propertyData[
                                                      'rating']
                                                  as num)
                                              .toDouble();

                                      final String imageName =
                                          propertyData[
                                                  'image']
                                              .toString();

                                      return _PropertyCard(
                                        image:
                                            _getPropertyImage(
                                          imageName,
                                        ),
                                        title:
                                            propertyName,
                                        location:
                                            location,
                                        price: rent,
                                        rating: rating
                                            .toStringAsFixed(
                                          1,
                                        ),
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
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Tenant Review",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

                              const SizedBox(width: 12),

                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    reviewerName,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children:
                                        List.generate(
                                      5,
                                      (index) {
                                        return Icon(
                                          index <
                                                  reviewRating
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 16,
                                          color:
                                              Colors.orange,
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
                            style: const TextStyle(
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
                  fontWeight: FontWeight.w500,
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
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
                  style: const TextStyle(
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
                            TextOverflow.ellipsis,
                        style: const TextStyle(
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
                          color: Colors.orange,
                        ),

                        const SizedBox(width: 3),

                        Text(
                          rating,
                          style: const TextStyle(
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