import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'manage_bookings.dart';
import 'property_analytics.dart';
import 'properties.dart';
import 'rental_requests.dart';
import 'owner_profile.dart';
import 'add_property.dart';
import '../resources/imagescreen.dart';

class ownerdashboard extends StatefulWidget {
  const ownerdashboard({super.key});

  @override
  State<ownerdashboard> createState() => _ownerdashboardState();
}

class _ownerdashboardState extends State<ownerdashboard> {
  int _selectedIndex = 0;

  // ================= FIREBASE =================

  final String? ownerId = FirebaseAuth.instance.currentUser?.uid;

  // ================= HEADER =================

  Widget _buildHeader() {
    if (ownerId == null) {
      return _buildHeaderData('Owner');
    }

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .snapshots(),
      builder: (context, snapshot) {
        String ownerName = 'Owner';

        if (snapshot.hasData && snapshot.data!.exists) {
          final data =
              snapshot.data!.data() as Map<String, dynamic>?;

          ownerName = data?['fullName']?.toString() ?? 'Owner';
        }

        return _buildHeaderData(ownerName);
      },
    );
  }

  Widget _buildHeaderData(String ownerName) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            owner,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $ownerName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Manage your properties easily',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),

        Stack(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                ),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Color(0xFF374151),
              ),
            ),

            Positioned(
              right: 7,
              top: 6,
              child: Container(
                height: 9,
                width: 9,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= STAT CARD =================

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    String? extraText,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                if (extraText != null)
                  Text(
                    extraText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= QUICK ACTION =================

  Widget _buildQuickAction(
    String title,
    IconData icon,
    int badge,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () {

          // ================= ADD PROPERTY =================

          if (title == 'Add Property') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const addproperty(),
              ),
            );

          // ================= MANAGE =================

          } else if (title == 'Manage') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const properties(),
              ),
            );

          // ================= REQUESTS =================

          } else if (title == 'Requests') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const rentalrequests(),
              ),
            );

          // ================= ANALYTICS =================

          } else if (title == 'Analytics') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const propertyanalytics(),
              ),
            );
          }
        },

        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF2563EB),
                    ),
                  ),

                  if (badge > 0)
                    Positioned(
                      right: -2,
                      top: -5,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= TOP PROPERTY =================

  Widget _buildPropertyCard() {
    if (ownerId == null) {
      return _emptyPropertyCard();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('properties')
          .where('ownerId', isEqualTo: ownerId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loadingCard();
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _emptyPropertyCard();
        }

        final docs = snapshot.data!.docs;

        docs.sort((a, b) {
          final aData =
              a.data() as Map<String, dynamic>;

          final bData =
              b.data() as Map<String, dynamic>;

          final aRating =
              (aData['rating'] as num?)?.toDouble() ?? 0;

          final bRating =
              (bData['rating'] as num?)?.toDouble() ?? 0;

          return bRating.compareTo(aRating);
        });

        final data =
            docs.first.data() as Map<String, dynamic>;

        final propertyName =
            data['propertyName']?.toString() ??
                'Property';

        final location =
            data['location']?.toString() ?? '';

        final rent =
            data['rent']?.toString() ?? '';

        final status =
            data['status']?.toString() ?? '';

        final rating =
            (data['rating'] as num?)?.toDouble() ?? 0;

        final imageName =
            data['image']?.toString() ?? '';

        return _propertyCardData(
          propertyName,
          location,
          rent,
          status,
          rating,
          imageName,
        );
      },
    );
  }

  Widget _propertyCardData(
    String propertyName,
    String location,
    String rent,
    String status,
    double rating,
    String imageName,
  ) {
    final ImageProvider propertyImage =
        imageName == 'property1'
            ? AssetImage(property1)
            : imageName == 'property2'
                ? AssetImage(property2)
                : AssetImage(skyline);

    final bool occupied =
        status.toLowerCase() == 'rented';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(12),
                child: Image(
                  image: propertyImage,
                  height: 75,
                  width: 75,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      propertyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      '$rent / month',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Text(
                  occupied ? 'Occupied' : status,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),
          const Divider(),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.star,
                size: 18,
                color: Colors.amber,
              ),

              const SizedBox(width: 5),

              Text(
                '${rating.toStringAsFixed(1)} Rating',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF374151),
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.visibility_outlined,
                size: 18,
                color: Color(0xFF6B7280),
              ),

              const SizedBox(width: 5),

              const Text(
                '1.2k Views',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyPropertyCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Text(
        'No properties found',
        style: TextStyle(
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE5E7EB),
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // ================= PENDING REQUEST =================

  Widget _buildPendingRequest() {
    if (ownerId == null) {
      return _emptyRequest();
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rental_requests')
          .where(
            'ownerId',
            isEqualTo: ownerId,
          )
          .where(
            'status',
            isEqualTo: 'Pending',
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loadingCard();
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _emptyRequest();
        }

        final data =
            snapshot.data!.docs.first.data()
                as Map<String, dynamic>;

        final tenantName =
            data['tenantName']?.toString() ??
                'Tenant';

        final requestDate =
            data['requestDate']?.toString() ?? '';

        final message =
            data['message']?.toString() ?? '';

        return _pendingRequestData(
          tenantName,
          requestDate,
          message,
        );
      },
    );
  }

  Widget _pendingRequestData(
    String tenantName,
    String requestDate,
    String message,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  rentalProfile,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenantName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      requestDate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Request details selected',
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFF2563EB),
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyRequest() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: const Text(
        'No pending requests',
        style: TextStyle(
          color: Color(0xFF6B7280),
        ),
      ),
    );
  }

  // ================= REVENUE =================

  Widget _buildRevenueCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Revenue Growth',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Revenue increased 12% since last month',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Text(
                  '+12%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 130,
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: [
                _buildChartBar('Jan', 45),
                _buildChartBar('Feb', 60),
                _buildChartBar('Mar', 50),
                _buildChartBar('Apr', 72),
                _buildChartBar('May', 65),
                _buildChartBar('Jun', 90),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Center(
            child: Text(
              'Your revenue has increased by 12% since last month.',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(
    String month,
    double height,
  ) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end,
      children: [
        Container(
          height: height,
          width: 25,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius:
                BorderRadius.circular(6),
          ),
        ),

        const SizedBox(height: 6),

        Text(
          month,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  // ================= PAYMENT =================

  Widget _buildPayment(
    String name,
    String amount,
    String date,
    String property,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor:
                Color(0xFFEFF6FF),
            child: Icon(
              Icons.person_outline,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  property,
                  style: const TextStyle(
                    fontSize: 11,
                    color:
                        Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Paid • $date',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          Text(
            amount,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // ================= DASHBOARD =================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 25),

          const Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // ================= TOTAL PROPERTIES =================

          if (ownerId == null)
            _buildStatCard(
              'Total Properties',
              '0',
              Icons.home_work_outlined,
              null,
            )
          else
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('properties')
                  .where(
                    'ownerId',
                    isEqualTo: ownerId,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                final count =
                    snapshot.hasData
                        ? snapshot.data!.docs.length
                        : 0;

                return _buildStatCard(
                  'Total Properties',
                  '$count',
                  Icons.home_work_outlined,
                  null,
                );
              },
            ),

          const SizedBox(height: 10),

          // ================= ACTIVE LISTINGS =================

          if (ownerId == null)
            _buildStatCard(
              'Active Listings',
              '0',
              Icons.list_alt_outlined,
              null,
            )
          else
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('properties')
                  .where(
                    'ownerId',
                    isEqualTo: ownerId,
                  )
                  .where(
                    'status',
                    isEqualTo: 'Active',
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                final count =
                    snapshot.hasData
                        ? snapshot.data!.docs.length
                        : 0;

                return _buildStatCard(
                  'Active Listings',
                  '$count',
                  Icons.list_alt_outlined,
                  null,
                );
              },
            ),

          const SizedBox(height: 10),

          // MONTHLY EARNINGS - unchanged

          _buildStatCard(
            'Monthly Earnings',
            '₹12,450',
            Icons.currency_rupee,
            '+12.5% growth',
          ),

          const SizedBox(height: 10),

          // ================= BOOKINGS =================

          if (ownerId == null)
            _buildStatCard(
              'Bookings',
              '0',
              Icons.calendar_month_outlined,
              null,
            )
          else
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where(
                    'ownerId',
                    isEqualTo: ownerId,
                  )
                  .snapshots(),
              builder: (context, snapshot) {
                final count =
                    snapshot.hasData
                        ? snapshot.data!.docs.length
                        : 0;

                return _buildStatCard(
                  'Bookings',
                  '$count',
                  Icons.calendar_month_outlined,
                  null,
                );
              },
            ),

          const SizedBox(height: 10),

          // VIEWS - unchanged

          _buildStatCard(
            'Views',
            '2.8k',
            Icons.visibility_outlined,
            null,
          ),

          const SizedBox(height: 25),

          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              // ================= ADD PROPERTY =================

              _buildQuickAction(
                'Add Property',
                Icons.add_home_work_outlined,
                0,
              ),

              const SizedBox(width: 8),

              // ================= MANAGE =================

              _buildQuickAction(
                'Manage',
                Icons.settings_outlined,
                0,
              ),

              const SizedBox(width: 8),

              // ================= REQUESTS =================

              if (ownerId == null)
                _buildQuickAction(
                  'Requests',
                  Icons.assignment_outlined,
                  0,
                )
              else
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('rental_requests')
                      .where(
                        'ownerId',
                        isEqualTo: ownerId,
                      )
                      .where(
                        'status',
                        isEqualTo: 'Pending',
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    final count =
                        snapshot.hasData
                            ? snapshot.data!.docs.length
                            : 0;

                    return _buildQuickAction(
                      'Requests',
                      Icons.assignment_outlined,
                      count,
                    );
                  },
                ),

              const SizedBox(width: 8),

              // ================= ANALYTICS =================

              _buildQuickAction(
                'Analytics',
                Icons.analytics_outlined,
                0,
              ),
            ],
          ),

          const SizedBox(height: 25),

          const Text(
            'Top Performing Property',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildPropertyCard(),

          const SizedBox(height: 25),

          const Text(
            'Pending Requests',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildPendingRequest(),

          const SizedBox(height: 25),

          const Text(
            'Revenue Growth',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _buildRevenueCard(),

          const SizedBox(height: 25),

          const Text(
            'Recent Payments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
              border: Border.all(
                color:
                    const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                _buildPayment(
                  'Mark Thompson',
                  '₹6,100',
                  'Oct 22',
                  'The Aura - Penthouse B',
                ),

                const Divider(),

                _buildPayment(
                  'Elena Rodriguez',
                  '₹2,850',
                  'Oct 20',
                  'Sunset Studio 402',
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ================= BOTTOM NAVIGATION =================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor:
          const Color(0xFF2563EB),
      unselectedItemColor:
          const Color(0xFF6B7280),

      onTap: (index) {
        if (index == 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }

        // ================= PROPERTIES =================

        else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const properties(),
            ),
          );
        }

        // ================= BOOKINGS =================

        else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const managebookings(),
            ),
          );
        }

        // ================= ANALYTICS =================

        else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const propertyanalytics(),
            ),
          );
        }

        // ================= PROFILE =================

        else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ownerprofile(),
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
          label: 'Dashboard',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_work_outlined,
          ),
          activeIcon: Icon(
            Icons.home_work,
          ),
          label: 'Properties',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.calendar_month_outlined,
          ),
          activeIcon: Icon(
            Icons.calendar_month,
          ),
          label: 'Bookings',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.analytics_outlined,
          ),
          activeIcon: Icon(
            Icons.analytics,
          ),
          label: 'Analytics',
        ),

        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          activeIcon: Icon(
            Icons.person,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF8FAFC),

      body: SafeArea(
        child: _buildDashboard(),
      ),

      bottomNavigationBar:
          _buildBottomNavigation(),
    );
  }
}