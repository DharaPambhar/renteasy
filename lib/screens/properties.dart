import 'package:flutter/material.dart';
import 'owner_dashboard.dart';
import 'manage_bookings.dart';
import 'property_analytics.dart';
import 'owner_profile.dart';

class properties extends StatefulWidget {
  const properties({super.key});

  @override
  State<properties> createState() => _propertiesState();
}

class _propertiesState extends State<properties> {
  int _selectedIndex = 1;
  int _selectedFilter = 0;

  final List<String> filters = [
    'All',
    'Active',
    'Pending',
    'Rented',
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
      setState(() {
        _selectedIndex = 1;
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),

      // ================= HEADER =================

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
          'My Properties',
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
            // ================= OVERVIEW =================

            Row(
              children: [
                Expanded(
                  child: _overviewCard(
                    'Total',
                    '24',
                    Icons.home_work_outlined,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _overviewCard(
                    'Active',
                    '18',
                    Icons.check_circle_outline,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: _overviewCard(
                    'Rented',
                    '12',
                    Icons.key_outlined,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _overviewCard(
                    'Pending',
                    '06',
                    Icons.pending_actions,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ================= SEARCH =================

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),

                      border: Border.all(
                        color: const Color(0xffE2E8F0),
                      ),
                    ),

                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search properties...',

                        hintStyle: TextStyle(
                          color: Color(0xff94A3B8),
                        ),

                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xff64748B),
                        ),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(
                          vertical: 13,
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
                    borderRadius: BorderRadius.circular(10),

                    border: Border.all(
                      color: const Color(0xffE2E8F0),
                    ),
                  ),

                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.filter_list,
                      color: Color(0xff475569),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ================= FILTER TABS =================

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: List.generate(
                  filters.length,
                  (index) {
                    bool selected = _selectedFilter == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = index;
                        });
                      },

                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 8,
                        ),

                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
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
                          filters[index],

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

            // ================= PROPERTY 1 =================

            _propertyCard(
              imagePath:
                  'lib/resources/images/property1.png',

              rating: '4.9',

              status: 'Active',

              statusColor:
                  const Color(0xff2563EB),

              propertyName:
                  'The Aura - Luxury Loft',

              rent: '₹4,250',

              location:
                  'Grand Avenue, Downtown, NYC',

              specs:
                  '3 Bed  •  2 Bath  •  1,450 sq.ft.',

              details:
                  'ID: #RE-40592  •  Posted Oct 12',

              furnished: true,

              rented: false,
            ),

            const SizedBox(height: 16),

            // ================= PROPERTY 2 =================

            _propertyCard(
              imagePath:
                  'lib/resources/images/property2.png',

              rating: '',

              status: 'Rented',

              statusColor:
                  const Color(0xffF97316),

              propertyName:
                  'Harbor View Penthouse',

              rent: '₹5,800',

              location:
                  'Seaport District, Boston',

              specs:
                  '4 Bed  •  3 Bath  •  2,100 sq.ft.',

              details: '',

              furnished: false,

              rented: true,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      // ================= BOTTOM NAVIGATION =================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        type: BottomNavigationBarType.fixed,

        selectedItemColor:
            const Color(0xff2563EB),

        unselectedItemColor:
            const Color(0xff64748B),

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
      ),
    );
  }

  // ================= OVERVIEW CARD =================

  Widget _overviewCard(
    String title,
    String value,
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

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: const Color(0xffDBEAFE),

              borderRadius:
                  BorderRadius.circular(10),
            ),

            child: Icon(
              icon,

              color:
                  const Color(0xff2563EB),

              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,

                style: const TextStyle(
                  fontSize: 12,

                  color:
                      Color(0xff64748B),
                ),
              ),

              const SizedBox(height: 3),

              Text(
                value,

                style: const TextStyle(
                  fontSize: 21,

                  fontWeight:
                      FontWeight.bold,

                  color:
                      Color(0xff0F172A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= PROPERTY CARD =================

  Widget _propertyCard({
    required String imagePath,

    required String rating,

    required String status,

    required Color statusColor,

    required String propertyName,

    required String rent,

    required String location,

    required String specs,

    required String details,

    required bool furnished,

    required bool rented,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border: Border.all(
          color:
              const Color(0xffE2E8F0),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          // ================= IMAGE =================

          Stack(
            children: [
              Container(
                height: 190,

                width: double.infinity,

                decoration:
                    const BoxDecoration(
                  color:
                      Color(0xffDBEAFE),

                  borderRadius:
                      BorderRadius.only(
                    topLeft:
                        Radius.circular(16),

                    topRight:
                        Radius.circular(16),
                  ),
                ),

                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(
                    topLeft:
                        Radius.circular(16),

                    topRight:
                        Radius.circular(16),
                  ),

                  child: Image.asset(
                    imagePath,

                    width:
                        double.infinity,

                    height: 190,

                    // CHANGED: image now fills the full box
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // ================= RATING =================

              if (rating.isNotEmpty)
                Positioned(
                  top: 12,
                  left: 12,

                  child: Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),

                    decoration:
                        BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(
                        20,
                      ),
                    ),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,

                          size: 15,

                          color:
                              Color(0xffF59E0B),
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Text(
                          rating,

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,

                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ================= STATUS =================

              Positioned(
                top: 12,
                right: 12,

                child: Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        statusColor,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    status,

                    style:
                        const TextStyle(
                      color: Colors.white,

                      fontSize: 12,

                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ================= DETAILS =================

          Padding(
            padding:
                const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  propertyName,

                  style:
                      const TextStyle(
                    fontSize: 18,

                    fontWeight:
                        FontWeight.bold,

                    color:
                        Color(0xff0F172A),
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Text(
                      rent,

                      style:
                          const TextStyle(
                        fontSize: 18,

                        fontWeight:
                            FontWeight.bold,

                        color:
                            Color(0xff2563EB),
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      '/ month',

                      style:
                          TextStyle(
                        fontSize: 12,

                        color:
                            Color(0xff64748B),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Icon(
                      Icons.location_on_outlined,

                      size: 17,

                      color:
                          Color(0xff64748B),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        location,

                        style:
                            const TextStyle(
                          fontSize: 13,

                          color:
                              Color(0xff64748B),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  specs,

                  style:
                      const TextStyle(
                    fontSize: 13,

                    color:
                        Color(0xff475569),

                    fontWeight:
                        FontWeight.w500,
                  ),
                ),

                if (details.isNotEmpty) ...[
                  const SizedBox(height: 10),

                  Text(
                    details,

                    style:
                        const TextStyle(
                      fontSize: 12,

                      color:
                          Color(0xff64748B),
                    ),
                  ),
                ],

                if (furnished) ...[
                  const SizedBox(height: 10),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration:
                        BoxDecoration(
                      color:
                          const Color(
                        0xffF1F5F9,
                      ),

                      borderRadius:
                          BorderRadius.circular(
                        6,
                      ),
                    ),

                    child: const Text(
                      'Furnished',

                      style:
                          TextStyle(
                        fontSize: 11,

                        color:
                            Color(0xff475569),

                        fontWeight:
                            FontWeight.w500,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // ================= BUTTONS =================

                if (!rented)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,

                          child:
                              ElevatedButton
                                  .icon(
                            onPressed: () {},

                            icon:
                                const Icon(
                              Icons.edit_outlined,

                              size: 17,

                              color:
                                  Colors.white,
                            ),

                            label:
                                const Text(
                              'Edit Listing',

                              style:
                                  TextStyle(
                                color:
                                    Colors.white,

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),

                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                0xff2563EB,
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      _smallActionButton(
                        Icons.share_outlined,
                      ),

                      const SizedBox(width: 8),

                      _smallActionButton(
                        Icons.more_vert,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,

                          child:
                              OutlinedButton(
                            onPressed: () {},

                            style:
                                OutlinedButton
                                    .styleFrom(
                              side:
                                  const BorderSide(
                                color:
                                    Color(
                                  0xff2563EB,
                                ),
                              ),

                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  8,
                                ),
                              ),
                            ),

                            child:
                                const Text(
                              'View Details',

                              style:
                                  TextStyle(
                                color:
                                    Color(
                                  0xff2563EB,
                                ),

                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      _smallActionButton(
                        Icons.analytics_outlined,
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

  // ================= SMALL BUTTON =================

  Widget _smallActionButton(
    IconData icon,
  ) {
    return Container(
      width: 44,
      height: 44,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(8),

        border: Border.all(
          color:
              const Color(0xffCBD5E1),
        ),
      ),

      child: IconButton(
        onPressed: () {},

        icon: Icon(
          icon,

          size: 19,

          color:
              const Color(0xff475569),
        ),
      ),
    );
  }
}