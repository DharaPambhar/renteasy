
import 'package:flutter/material.dart';

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

  final Color primaryColor = const Color(0xFF2563EB);
  final Color borderColor = const Color(0xFF6B7280);
  final Color textColor = const Color(0xFF111827);
  final Color secondaryColor = const Color(0xFF6B7280);
  final Color lightBlueColor = const Color(0xFFDBEAFE);

  // ================= HEADER =================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              owner,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, Owner',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 3),
                Text(
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
              Icon(
                Icons.notifications_none,
                color: primaryColor,
                size: 29,
              ),
              Positioned(
                right: 2,
                top: 1,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= STAT CARD =================

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 25,
          ),
          const SizedBox(height: 9),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================= MONTHLY EARNINGS =================

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly Earnings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '₹12,450',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Text(
              '+12.5%',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
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
          if (title == 'Add Property') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const addproperty(),
              ),
            );
          } else if (title == 'Manage') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const properties(),
              ),
            );
          } else if (title == 'Requests') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const rentalrequests(),
              ),
            );
          } else if (title == 'Analytics') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const propertyanalytics(),
              ),
            );
          }
        },
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: title == 'Add Property'
                        ? primaryColor
                        : lightBlueColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    icon,
                    size: 27,
                    color: title == 'Add Property'
                        ? Colors.white
                        : primaryColor,
                  ),
                ),
                if (badge > 0)
                  Positioned(
                    right: -3,
                    top: -4,
                    child: Container(
                      width: 23,
                      height: 23,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= TOP PROPERTY =================

  Widget _buildPropertyCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image(
                image: AssetImage(property1),
                width: double.infinity,
                height: 235,
                fit: BoxFit.cover,
              ),
              Positioned(
                right: 15,
                top: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Text(
                    'Occupied',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'The Aura - Luxury Loft',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: '₹4,250',
                            style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: '/mo',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Downtown, NYC',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: borderColor),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 17,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 5),
                    Text(
                      '1.2k views',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.star_border,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '4.9 rating',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
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

  // ================= SECTION HEADING =================

  Widget _buildSectionHeading(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }

  // ================= PENDING REQUEST =================

  Widget _buildPendingRequest() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  rentalProfile,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Sarah Jenkins',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified,
                          color: Color(0xFF2563EB),
                          size: 17,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Oct 24, 2023',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'PENDING',
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Interested in The Aura - Luxury Loft for a 12-month lease.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const rentalrequests(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'View Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= REVENUE GROWTH =================

  Widget _buildRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text(
                  'Revenue Growth',
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.trending_up,
                color: Color(0xFFDBEAFE),
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 105,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildChartBar(33),
                _buildChartBar(49),
                _buildChartBar(42),
                _buildChartBar(65),
                _buildChartBar(57),
                _buildChartBar(81),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your revenue has increased by 12% since last month.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(double height) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: height,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(3),
          ),
        ),
      ),
    );
  }

  // ================= RECENT PAYMENTS =================

  Widget _buildPayment(
    String name,
    String amount,
    String date,
    String property,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: lightBlueColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.payments_outlined,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  property,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Paid • $date',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= DASHBOARD =================

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Properties',
                  '12',
                  Icons.home_work_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Active Listings',
                  '8',
                  Icons.list_alt,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildEarningsCard(),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Bookings',
                  '45',
                  Icons.calendar_month_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Views',
                  '2.8k',
                  Icons.visibility_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSectionHeading('Quick Actions'),

          const SizedBox(height: 16),

          Row(
            children: [
              _buildQuickAction(
                'Add Property',
                Icons.add_circle_outline,
                0,
              ),
              _buildQuickAction(
                'Manage',
                Icons.settings_outlined,
                0,
              ),
              _buildQuickAction(
                'Requests',
                Icons.assignment_ind_outlined,
                5,
              ),
              _buildQuickAction(
                'Analytics',
                Icons.analytics_outlined,
                0,
              ),
            ],
          ),

          const SizedBox(height: 30),

          _buildSectionHeading('Top Performing Property'),

          const SizedBox(height: 15),

          _buildPropertyCard(),

          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: _buildSectionHeading('Pending Requests'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const rentalrequests(),
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          _buildPendingRequest(),

          const SizedBox(height: 22),

          _buildRevenueCard(),

          const SizedBox(height: 24),

          _buildSectionHeading('Recent Payments'),

          const SizedBox(height: 15),

          _buildPayment(
            'Mark Thompson',
            '₹6,100',
            'Oct 22',
            'The Aura - Penthouse B',
          ),

          const SizedBox(height: 14),

          _buildPayment(
            'Elena Rodriguez',
            '₹2,850',
            'Oct 20',
            'Sunset Studio 402',
          ),

          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // ================= BOTTOM NAVIGATION =================

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: const Color(0xFF6B7280),
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        if (index == 0) {
          setState(() {
            _selectedIndex = 0;
          });
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const properties(),
            ),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const managebookings(),
            ),
          );
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
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home_work_outlined),
          activeIcon: Icon(Icons.home_work),
          label: 'Properties',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Bookings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics_outlined),
          activeIcon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _buildDashboard(),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
