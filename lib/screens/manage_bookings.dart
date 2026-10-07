import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'owner_dashboard.dart';
import 'properties.dart';
import 'property_analytics.dart';
import 'owner_profile.dart';
import '../resources/imagescreen.dart';

class managebookings extends StatefulWidget {
  const managebookings({super.key});

  @override
  State<managebookings> createState() => _managebookingsState();
}

class _managebookingsState extends State<managebookings> {
  int _selectedIndex = 2;
  int _selectedTab = 0;

  final List<String> _tabs = [
    'All',
    'Pending',
    'Confirmed',
    'Upcoming',
  ];

  String _searchText = '';

  // ================= FIREBASE =================

  CollectionReference<Map<String, dynamic>> get _bookingsCollection {
    return FirebaseFirestore.instance.collection('bookings');
  }

  String? get _currentOwnerId {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _bookingsStream() {
    final ownerId = _currentOwnerId;

    if (ownerId == null) {
      return const Stream.empty();
    }

    return _bookingsCollection
        .where('ownerId', isEqualTo: ownerId)
        .snapshots();
  }

  // ================= BOTTOM NAVIGATION =================

  void _navigateBottom(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ownerdashboard(),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const properties(),
        ),
      );
    } else if (index == 2) {
      setState(() {
        _selectedIndex = 2;
      });
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const propertyanalytics(),
        ),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ownerprofile(),
        ),
      );
    }
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF111827),
          ),
        ),
        const Expanded(
          child: Text(
            'Manage Bookings',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
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
                  color: Color(0xFFE5E7EB),
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

  // ================= OVERVIEW CARD =================

  Widget _buildOverviewCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2563EB),
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= SEARCH BAR =================

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search bookings',
                hintStyle: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF6B7280),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: const Icon(
            Icons.filter_list,
            color: Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  // ================= FILTER TABS =================

  Widget _buildFilterTabs() {
    return Row(
      children: List.generate(
        _tabs.length,
        (index) {
          bool isSelected = _selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Text(
                  _tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF374151),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= USER HEADER =================

  Widget _buildUserHeader(
    String name,
    String phone,
    String status,
    Color statusColor,
    Color statusBackground,
    String imagePath,
  ) {
    return Row(
      children: [
        CircleAvatar(
          radius: 23,
          backgroundColor: const Color(0xFFEFF6FF),
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.verified,
                    size: 16,
                    color: Color(0xFF2563EB),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: statusBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: TextStyle(
              fontSize: 10,
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ================= PROPERTY INFO =================

  Widget _buildPropertyInfo(
    String property,
    String location,
    String price,
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$price / month',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= BOOKING DETAIL =================

  Widget _buildBookingDetail(
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 17,
            color: const Color(0xFF6B7280),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SMALL ACTION =================

  Widget _buildSmallAction(
    String title,
    IconData icon,
    VoidCallback? onPressed,
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title selected'),
                ),
              );
            },
        icon: Icon(
          icon,
          size: 16,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF2563EB),
          side: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }

  // ================= IMAGE =================

  String _getPropertyImage(String imageName) {
    if (imageName == 'property1') {
      return property1;
    }

    if (imageName == 'property2') {
      return property2;
    }

    return property1;
  }

  // ================= STATUS COLORS =================

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF2563EB);

      case 'pending':
        return Colors.orange;

      case 'upcoming':
        return const Color(0xFF7C3AED);

      case 'completed':
        return Colors.green;

      case 'cancelled':
        return Colors.red;

      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getStatusBackground(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFFEFF6FF);

      case 'pending':
        return const Color(0xFFFEF3C7);

      case 'upcoming':
        return const Color(0xFFF3E8FF);

      case 'completed':
        return const Color(0xFFDCFCE7);

      case 'cancelled':
        return const Color(0xFFFEE2E2);

      default:
        return const Color(0xFFF3F4F6);
    }
  }

  // ================= FILTER LOGIC =================

  bool _matchesSelectedTab(Map<String, dynamic> data) {
    final status =
        (data['status'] ?? '').toString().toLowerCase();

    if (_selectedTab == 0) {
      return true;
    }

    if (_selectedTab == 1) {
      return status == 'pending';
    }

    if (_selectedTab == 2) {
      return status == 'confirmed';
    }

    if (_selectedTab == 3) {
      return status == 'upcoming';
    }

    return true;
  }

  bool _matchesSearch(Map<String, dynamic> data) {
    if (_searchText.isEmpty) {
      return true;
    }

    final tenantName =
        (data['tenantName'] ?? '').toString().toLowerCase();

    final propertyName =
        (data['propertyName'] ?? '').toString().toLowerCase();

    final bookingId =
        (data['bookingId'] ?? '').toString().toLowerCase();

    final propertyLocation =
        (data['propertyLocation'] ?? '').toString().toLowerCase();

    return tenantName.contains(_searchText) ||
        propertyName.contains(_searchText) ||
        bookingId.contains(_searchText) ||
        propertyLocation.contains(_searchText);
  }

  // ================= UPDATE BOOKING STATUS =================

  Future<void> _updateBookingStatus(
    String documentId,
    String status,
  ) async {
    try {
      await _bookingsCollection.doc(documentId).update({
        'status': status,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking $status'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to update booking: $e'),
        ),
      );
    }
  }

  // ================= BOOKING CARD =================

  Widget _buildBookingCard(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    final tenantName =
        (data['tenantName'] ?? 'Unknown Tenant').toString();

    final tenantPhone =
        (data['tenantPhone'] ?? 'No phone number').toString();

    final status =
        (data['status'] ?? 'Pending').toString();

    final propertyName =
        (data['propertyName'] ?? 'Property').toString();

    final propertyLocation =
        (data['propertyLocation'] ?? '').toString();

    final rent =
        (data['rent'] ?? '₹0').toString();

    final bookingId =
        (data['bookingId'] ?? document.id).toString();

    final visitDate =
        (data['visitDate'] ??
                data['bookingDate'] ??
                'Not available')
            .toString();

    final leaseDuration =
        (data['leaseDuration'] ?? 'Not available').toString();

    final occupants =
        (data['occupants'] ?? 'Not available').toString();

    final imageName =
        (data['image'] ?? 'property1').toString();

    final imagePath = _getPropertyImage(imageName);

    final statusColor = _getStatusColor(status);
    final statusBackground =
        _getStatusBackground(status);

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(
            tenantName,
            tenantPhone,
            status,
            statusColor,
            statusBackground,
            rentalProfile,
          ),

          const SizedBox(height: 14),

          _buildPropertyInfo(
            propertyName,
            propertyLocation,
            rent,
            imagePath,
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                size: 17,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Booking ID #$bookingId',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _buildBookingDetail(
                'Visit Date',
                visitDate,
                Icons.calendar_today_outlined,
              ),
              _buildBookingDetail(
                'Lease Duration',
                leaseDuration,
                Icons.access_time,
              ),
              _buildBookingDetail(
                'Occupants',
                occupants,
                Icons.people_outline,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              _buildSmallAction(
                'Chat',
                Icons.chat_bubble_outline,
                null,
              ),
              const SizedBox(width: 8),
              _buildSmallAction(
                'Call',
                Icons.call_outlined,
                null,
              ),
            ],
          ),

          if (status.toLowerCase() == 'pending') ...[
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  _updateBookingStatus(
                    document.id,
                    'Confirmed',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _buildSmallAction(
                  'Reschedule',
                  Icons.edit_calendar_outlined,
                  null,
                ),
                const SizedBox(width: 8),
                _buildSmallAction(
                  'Cancel',
                  Icons.close,
                  () {
                    _updateBookingStatus(
                      document.id,
                      'Cancelled',
                    );
                  },
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: 10),

            Row(
              children: [
                _buildSmallAction(
                  'Chat',
                  Icons.chat_bubble_outline,
                  null,
                ),
                const SizedBox(width: 8),
                _buildSmallAction(
                  'Details',
                  Icons.info_outline,
                  null,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ================= BOOKINGS LIST =================

  Widget _buildBookingsList(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> documents,
  ) {
    final filteredDocuments = documents.where((document) {
      final data = document.data();

      return _matchesSelectedTab(data) &&
          _matchesSearch(data);
    }).toList();

    if (filteredDocuments.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 45,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 10),
            Text(
              'No bookings found',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: filteredDocuments.map((document) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildBookingCard(document),
        );
      }).toList(),
    );
  }

  // ================= BOOKINGS CONTENT =================

  Widget _buildBookingsContent() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _bookingsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF2563EB),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Error loading bookings:\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          );
        }

        if (_currentOwnerId == null) {
          return const Center(
            child: Text(
              'Please login as owner to view bookings.',
              style: TextStyle(
                color: Color(0xFF374151),
              ),
            ),
          );
        }

        final documents = snapshot.data?.docs ?? [];

        int totalBookings = documents.length;

        int pendingBookings = documents.where((doc) {
          return (doc.data()['status'] ?? '')
                  .toString()
                  .toLowerCase() ==
              'pending';
        }).length;

        int confirmedBookings = documents.where((doc) {
          return (doc.data()['status'] ?? '')
                  .toString()
                  .toLowerCase() ==
              'confirmed';
        }).length;

        int upcomingBookings = documents.where((doc) {
          return (doc.data()['status'] ?? '')
                  .toString()
                  .toLowerCase() ==
              'upcoming';
        }).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 22),

              const Text(
                'Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildOverviewCard(
                    'Total Bookings',
                    totalBookings.toString(),
                    Icons.calendar_month_outlined,
                  ),
                  const SizedBox(width: 8),
                  _buildOverviewCard(
                    'Upcoming Visits',
                    upcomingBookings.toString(),
                    Icons.event_outlined,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  _buildOverviewCard(
                    'Active Rentals',
                    confirmedBookings.toString(),
                    Icons.home_work_outlined,
                  ),
                  const SizedBox(width: 8),
                  _buildOverviewCard(
                    'Completed',
                    documents.where((doc) {
                      return (doc.data()['status'] ?? '')
                              .toString()
                              .toLowerCase() ==
                          'completed';
                    }).length.toString(),
                    Icons.check_circle_outline,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              _buildSearchBar(),

              const SizedBox(height: 14),

              _buildFilterTabs(),

              const SizedBox(height: 22),

              Text(
                _selectedTab == 0
                    ? 'Bookings'
                    : '${_tabs[_selectedTab]} Booking',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 12),

              _buildBookingsList(documents),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ================= BOTTOM NAVIGATION =================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2563EB),
      unselectedItemColor: const Color(0xFF6B7280),
      onTap: _navigateBottom,
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _buildBookingsContent(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}