import 'package:flutter/material.dart';
import 'owner_dashboard.dart';
import 'properties.dart';
import 'property_analytics.dart';
import 'owner_profile.dart';

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
            child: const TextField(
              decoration: InputDecoration(
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
        // PROFILE IMAGE
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
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
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
          // PROPERTY IMAGE
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  location,
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
  ) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
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
          foregroundColor:
              const Color(0xFF2563EB),

          side: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),

          padding:
              const EdgeInsets.symmetric(
            vertical: 10,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(9),
          ),
        ),
      ),
    );
  }

  // ================= PENDING BOOKING =================

  Widget _buildPendingBooking() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _buildUserHeader(
            'Alex Rivera',
            '+1 (555) 0123',
            'Pending',
            Colors.orange,
            const Color(0xFFFEF3C7),
            'lib/resources/images/Rental_g',
          ),

          const SizedBox(height: 14),

          _buildPropertyInfo(
            'Skyline Vista Penthouse',
            'Downtown Core',
            '₹3,200',
            'lib/resources/images/aura.png',
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              Icon(
                Icons.confirmation_number_outlined,
                size: 17,
                color: Color(0xFF6B7280),
              ),

              SizedBox(width: 7),

              Text(
                'Booking ID #RE-92841',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _buildBookingDetail(
                'Visit Date',
                'Oct 24, 2023',
                Icons.calendar_today_outlined,
              ),

              _buildBookingDetail(
                'Lease Duration',
                '12 Months',
                Icons.access_time,
              ),

              _buildBookingDetail(
                'Occupants',
                '2 Adults',
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
              ),

              const SizedBox(width: 8),

              _buildSmallAction(
                'Call',
                Icons.call_outlined,
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 44,

            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text('Booking confirmed'),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF2563EB),

                foregroundColor:
                    Colors.white,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontWeight:
                      FontWeight.w600,
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
              ),

              const SizedBox(width: 8),

              _buildSmallAction(
                'Cancel',
                Icons.close,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= CONFIRMED BOOKING =================

  Widget _buildConfirmedBooking() {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          _buildUserHeader(
            'Sarah Jenkins',
            '+1 (555) 9876',
            'Confirmed',
            const Color(0xFF2563EB), 
            const Color(0xFFEFF6FF),
            'lib/resources/images/Rental_profile.png',
          ),

          const SizedBox(height: 14),

          _buildPropertyInfo(
            'The Loft at 5th Ave',
            'Midtown East',
            '₹2,850',
            'lib/resources/images/aura1.png',
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              _buildBookingDetail(
                'Move-In Date',
                'Nov 01, 2023',
                Icons.calendar_today_outlined,
              ),

              _buildBookingDetail(
                'Status',
                'Deposit Paid',
                Icons.check_circle_outline,
              ),
            ],
          ),

          const SizedBox(height: 15),

          SizedBox(
            width: double.infinity,
            height: 42,

            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Lease Agreement selected',
                    ),
                  ),
                );
              },

              icon: const Icon(
                Icons.description_outlined,
                size: 18,
              ),

              label: const Text(
                'View Lease Agreement',
              ),

              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(0xFF2563EB),

                side: const BorderSide(
                  color: Color(0xFF2563EB),
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _buildSmallAction(
                'Chat',
                Icons.chat_bubble_outline,
              ),

              const SizedBox(width: 8),

              _buildSmallAction(
                'Details',
                Icons.info_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= BOOKINGS CONTENT =================

  Widget _buildBookingsContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

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
                '128',
                Icons.calendar_month_outlined,
              ),

              const SizedBox(width: 8),

              _buildOverviewCard(
                'Upcoming Visits',
                '12',
                Icons.event_outlined,
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              _buildOverviewCard(
                'Active Rentals',
                '42',
                Icons.home_work_outlined,
              ),

              const SizedBox(width: 8),

              _buildOverviewCard(
                'Completed',
                '74',
                Icons.check_circle_outline,
              ),
            ],
          ),

          const SizedBox(height: 22),

          _buildSearchBar(),

          const SizedBox(height: 14),

          _buildFilterTabs(),

          const SizedBox(height: 22),

          const Text(
            'Pending Booking',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 12),

          _buildPendingBooking(),

          const SizedBox(height: 25),

          const Text(
            'Confirmed Booking',

            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 12),

          _buildConfirmedBooking(),

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
      backgroundColor:
          const Color(0xFFF8FAFC),

      body: SafeArea(
        child: _buildBookingsContent(),
      ),

      bottomNavigationBar:
          _buildBottomNavigation(),
    );
  }
}