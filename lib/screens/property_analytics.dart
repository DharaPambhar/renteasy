
import 'package:flutter/material.dart';
import 'owner_dashboard.dart';
import 'properties.dart';
import 'manage_bookings.dart';
import 'owner_profile.dart';

class propertyanalytics extends StatefulWidget {
  const propertyanalytics({super.key});

  @override
  State<propertyanalytics> createState() =>
      _propertyanalyticsState();
}

class _propertyanalyticsState
    extends State<propertyanalytics> {
  int _selectedIndex = 3;
  int _selectedTime = 2;

  final List<String> timeFilters = [
    'Today',
    'This Week',
    'This Month',
    'This Year',
    'Range',
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const managebookings(),
        ),
      );
    } else if (index == 3) {
      setState(() {
        _selectedIndex = 3;
      });
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ownerprofile(),
        ),
      );
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff2563EB),
      unselectedItemColor: const Color(0xff64748B),
      onTap: _navigateBottom,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      // ================= APP BAR =================

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Property Analytics',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.black,
                  size: 27,
                ),
                onPressed: () {},
              ),
              Positioned(
                right: 9,
                top: 8,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      // ================= BODY =================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= TIME FILTER =================

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  timeFilters.length,
                  (index) {
                    bool selected =
                        _selectedTime == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTime = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 8,
                        ),
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xff2563EB)
                              : Colors.white,
                          borderRadius:
                              BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? const Color(0xff2563EB)
                                : const Color(0xffE2E8F0),
                          ),
                        ),
                        child: Text(
                          timeFilters[index],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : const Color(0xff475569),
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= METRICS =================

            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    'Total Views',
                    '12,482',
                    '+12.5%',
                    Icons.visibility_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    'Active Listings',
                    '24',
                    'Same as last month',
                    Icons.home_work_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    'Total Bookings',
                    '158',
                    '+8.2%',
                    Icons.calendar_month_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    'Occupancy Rate',
                    '94.2%',
                    'High Demand',
                    Icons.pie_chart_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _metricCard(
                    'Monthly Revenue',
                    '\$42,850',
                    '+\$4.2k',
                    Icons.attach_money,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _metricCard(
                    'Avg Rating',
                    '4.8',
                    'Top Tier',
                    Icons.star_border,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // ================= VIEWS TREND =================

            _sectionTitle(
              'Views Trend',
              'Last 30 Days',
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xffE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 210,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      children: [
                        _chartBar(90),
                        _chartBar(120),
                        _chartBar(75),
                        _chartBar(145),
                        _chartBar(110),
                        _chartBar(165),
                        _chartBar(135),
                        _chartBar(180),
                        _chartBar(125),
                        _chartBar(155),
                        _chartBar(190),
                        _chartBar(145),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: const [
                      Text('1'),
                      Text('5'),
                      Text('10'),
                      Text('15'),
                      Text('20'),
                      Text('25'),
                      Text('30'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= RENTAL INCOME =================

            _sectionTitle(
              'Rental Income',
              '\$42k Peak',
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xffE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                      children: [
                        _incomeBar(
                          'Jun',
                          110,
                          false,
                        ),
                        _incomeBar(
                          'Jul',
                          140,
                          false,
                        ),
                        _incomeBar(
                          'Aug',
                          165,
                          true,
                        ),
                        _incomeBar(
                          'Sep',
                          125,
                          false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround,
                    children: [
                      Text('Jun'),
                      Text('Jul'),
                      Text('Aug'),
                      Text('Sep'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ================= TOP PERFORMING PROPERTIES =================

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Performing Properties',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff0F172A),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xff2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // AURA PROPERTY IMAGE

            _propertyCard(
              'Skyline Penthouse',
              'Downtown, Manhattan',
              '2.4k',
              '18',
              '\$8.2k',
              'lib/resources/images/aura_property.png',
            ),

            const SizedBox(height: 12),

            // PROPERTY 1 IMAGE

            _propertyCard(
              'Brick Hearth Villa',
              'Brooklyn, NY',
              '1.8k',
              '12',
              '\$5.4k',
              'lib/resources/images/property1.png',
            ),

            const SizedBox(height: 28),

            // ================= OPERATIONS =================

            const Text(
              'Operations & Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F172A),
              ),
            ),

            const SizedBox(height: 12),

            _performanceCard(
              'Response Rate',
              '98%',
              'Excellent',
              Icons.speed,
            ),

            const SizedBox(height: 12),

            _performanceCard(
              'Booking Conversion',
              '12.4%',
              'Above Avg',
              Icons.trending_up,
            ),

            const SizedBox(height: 12),

            _performanceCard(
              'Tenant Satisfaction',
              '4.9/5',
              'Top Rated',
              Icons.sentiment_satisfied_alt_outlined,
            ),

            const SizedBox(height: 28),

            // ================= EXPORT OPTIONS =================

            const Text(
              'Export Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff0F172A),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Export Full Report',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xff2563EB),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: Color(0xff2563EB),
                ),
                label: const Text(
                  'Download Monthly PDF',
                  style: TextStyle(
                    color: Color(0xff2563EB),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style:
                    OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xff2563EB),
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================

      bottomNavigationBar:
          _buildBottomNavigation(),
    );
  }

  // ================= METRIC CARD =================

  Widget _metricCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xff64748B),
                    fontSize: 12,
                  ),
                ),
              ),
              Icon(
                icon,
                color: const Color(0xff2563EB),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xff0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xff16A34A),
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _sectionTitle(
    String title,
    String rightText,
  ) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff0F172A),
          ),
        ),
        Text(
          rightText,
          style: const TextStyle(
            color: Color(0xff2563EB),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ================= VIEW CHART BAR =================

  Widget _chartBar(double height) {
    return Expanded(
      child: Container(
        height: height,
        margin:
            const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff2563EB),
          borderRadius:
              BorderRadius.circular(5),
        ),
      ),
    );
  }

  // ================= INCOME BAR =================

  Widget _incomeBar(
    String month,
    double height,
    bool selected,
  ) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.end,
      children: [
        Container(
          width: 42,
          height: height,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xff2563EB)
                : const Color(0xffBFDBFE),
            borderRadius:
                BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }

  // ================= PROPERTY CARD =================

  Widget _propertyCard(
    String name,
    String location,
    String views,
    String bookings,
    String income,
    String imagePath,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE2E8F0),
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
                    BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 55,
                  height: 55,
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
                      name,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xff0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location,
                      style:
                          const TextStyle(
                        fontSize: 13,
                        color:
                            Color(0xff64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _propertyInfo(
                Icons.visibility_outlined,
                'Views',
                views,
              ),
              _propertyInfo(
                Icons.calendar_month_outlined,
                'Bookings',
                bookings,
              ),
              _propertyInfo(
                Icons.attach_money,
                'Income',
                income,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _propertyInfo(
    IconData icon,
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(0xff64748B),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xff64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff0F172A),
          ),
        ),
      ],
    );
  }

  // ================= PERFORMANCE CARD =================

  Widget _performanceCard(
    String title,
    String value,
    String status,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xffDBEAFE),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xff2563EB),
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
                  style:
                      const TextStyle(
                    fontSize: 14,
                    color:
                        Color(0xff64748B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xff0F172A),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffDCFCE7),
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style:
                  const TextStyle(
                color: Color(0xff15803D),
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
