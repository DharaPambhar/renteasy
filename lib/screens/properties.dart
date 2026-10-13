
import 'package:flutter/material.dart';

import 'owner_dashboard.dart';
import 'manage_bookings.dart';
import 'property_analytics.dart';
import 'owner_profile.dart';
import '../resources/imagescreen.dart';

class properties extends StatefulWidget {
  const properties({super.key});

  @override
  State<properties> createState() => _propertiesState();
}

class _propertiesState extends State<properties> {
  int _selectedIndex = 1;
  int _selectedTab = 0;

  final TextEditingController _searchController =
      TextEditingController();


// Color palette
static const Color primaryColor = Color(0xFF2563EB);
static const Color lightPurple = Color(0xFFDBEAFE);
static const Color backgroundColor = Color(0xFFF8FAFC);
static const Color textColor = Color(0xFF111827);
static const Color secondaryColor = Color(0xFF6B7280);
static const Color borderColor = Color(0xFFE5E7EB);
static const Color activeColor = Color(0xFF2563EB);
static const Color rentedColor = Color(0xFFB45309);
static const Color pendingColor = Color(0xFF991B1B);

  final List<String> _tabs = [
    'All',
    'Active',
    'Pending',
    'Rented',
  ];

  final List<Map<String, dynamic>> _propertyList = [
    {
      'title': 'The Aura – Luxury Loft',
      'price': '₹4,250',
      'location': 'Grand Avenue, Downtown, NYC',
      'beds': '3 Bed',
      'baths': '2 Bath',
      'area': '1,450 sq.ft.',
      'id': 'RE-40592',
      'posted': 'Oct 12',
      'status': 'Active',
      'rating': '4.9',
      'tag': 'Furnished',
      'image': property1,
    },
    {
      'title': 'Harbor View Penthouse',
      'price': '₹5,800',
      'location': 'Seaport District, Boston',
      'beds': '4 Bed',
      'baths': '3 Bath',
      'area': '2,100 sq.ft.',
      'id': 'RE-40593',
      'posted': 'Oct 10',
      'status': 'Rented',
      'rating': '4.8',
      'tag': 'Premium',
      'image': property2,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Active':
        return activeColor;
      case 'Rented':
        return rentedColor;
      case 'Pending':
        return pendingColor;
      default:
        return secondaryColor;
    }
  }

  List<Map<String, dynamic>> get _filteredProperties {
    final query = _searchController.text.toLowerCase().trim();

    return _propertyList.where((property) {
      final matchesTab = _selectedTab == 0 ||
          property['status'] == _tabs[_selectedTab];

      final matchesSearch = query.isEmpty ||
          property['title']
              .toString()
              .toLowerCase()
              .contains(query) ||
          property['location']
              .toString()
              .toLowerCase()
              .contains(query) ||
          property['id']
              .toString()
              .toLowerCase()
              .contains(query) ||
          property['status']
              .toString()
              .toLowerCase()
              .contains(query);

      return matchesTab && matchesSearch;
    }).toList();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ownerdashboard(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: primaryColor,
            size: 21,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'My Properties',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                _showMessage('No new notifications.');
              },
              icon: const Icon(
                Icons.notifications_none,
                color: primaryColor,
                size: 27,
              ),
            ),
            Positioned(
              right: 11,
              top: 9,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= SUMMARY CARD =================
  // Fixed: reduced padding and spacing to prevent overflow.

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,

      // Fixed: increased card height to prevent bottom overflow.
      childAspectRatio: 1.25,

      children: [
        _summaryCard(
          'Total Properties',
          '24',
          Icons.apartment,
          primaryColor,
        ),
        _summaryCard(
          'Active',
          '18',
          Icons.verified_outlined,
          primaryColor,
        ),
        _summaryCard(
          'Rented',
          '12',
          Icons.key_outlined,
          rentedColor,
        ),
        _summaryCard(
          'Pending',
          '06',
          Icons.hourglass_empty,
          pendingColor,
        ),
      ],
    );
  }

  // ================= SEARCH AND FILTER =================

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search properties...',
              hintStyle: const TextStyle(
                color: secondaryColor,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: secondaryColor,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: borderColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: primaryColor,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: IconButton(
            onPressed: _showFilterOptions,
            icon: const Icon(
              Icons.tune,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final selected = _selectedTab == index;

          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: ChoiceChip(
              label: Text(_tabs[index]),
              selected: selected,
              showCheckmark: false,
              selectedColor: primaryColor,
              backgroundColor: lightPurple,
              side: BorderSide(
                color: selected ? primaryColor : lightPurple,
              ),
              labelStyle: TextStyle(
                color: selected ? Colors.white : secondaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              onSelected: (_) {
                setState(() {
                  _selectedTab = index;
                });
              },
            ),
          );
        }),
      ),
    );
  }

  // ================= PROPERTY CARD =================

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final status = property['status'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(19),
                ),
                child: Image.asset(
                  property['image'],
                  width: double.infinity,
                  height: 205,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 205,
                      color: lightPurple,
                      child: const Icon(
                        Icons.apartment,
                        size: 60,
                        color: primaryColor,
                      ),
                    );
                  },
                ),
              ),

              // Rating badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property['rating'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Property status
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Property title
                Text(
                  property['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 8),

                // Price
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: primaryColor,
                    ),
                    children: [
                      TextSpan(
                        text: property['price'],
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' per month',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Location
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 18,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        property['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Property specifications
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _specification(
                          Icons.bed_outlined,
                          property['beds'],
                        ),
                      ),
                      Expanded(
                        child: _specification(
                          Icons.bathtub_outlined,
                          property['baths'],
                        ),
                      ),
                      Expanded(
                        child: _specification(
                          Icons.square_foot,
                          property['area'],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Property ID and posting date
                Row(
                  children: [
                    const Icon(
                      Icons.tag,
                      size: 15,
                      color: secondaryColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'ID: #${property['id']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                    Text(
                      'Posted ${property['posted']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Furnished / Premium tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: lightPurple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.chair_outlined,
                        size: 15,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        property['tag'],
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Active property actions
                if (status == 'Active')
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showMessage(
                              'Edit Listing: ${property['title']}',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 17,
                          ),
                          label: const Text(
                            'Edit Listing',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _smallActionButton(
                        Icons.share_outlined,
                        () {
                          _showMessage(
                            'Share: ${property['title']}',
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      _smallActionButton(
                        Icons.more_horiz,
                        () => _showPropertyOptions(property),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _showPropertyDetails(property),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                            side: const BorderSide(
                              color: primaryColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _smallActionButton(
                        Icons.bar_chart,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const propertyanalytics(),
                            ),
                          );
                        },
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

  Widget _specification(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: primaryColor,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              color: secondaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _smallActionButton(
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        color: lightPurple,
        borderRadius: BorderRadius.circular(11),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: primaryColor,
          size: 20,
        ),
      ),
    );
  }

  // ================= PROPERTY DETAILS =================

  void _showPropertyDetails(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                property['title'],
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 12),
              Text('Rent: ${property['price']} / month'),
              const SizedBox(height: 8),
              Text('Location: ${property['location']}'),
              const SizedBox(height: 8),
              Text(
                'Specifications: ${property['beds']} | '
                '${property['baths']} | ${property['area']}',
              ),
              const SizedBox(height: 8),
              Text('Status: ${property['status']}'),
              const SizedBox(height: 8),
              Text('Property ID: #${property['id']}'),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(sheetContext),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPropertyOptions(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.visibility_outlined,
                color: primaryColor,
              ),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showPropertyDetails(property);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.share_outlined,
                color: primaryColor,
              ),
              title: const Text('Share Listing'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showMessage('Share: ${property['title']}');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                color: primaryColor,
              ),
              title: const Text('Edit Listing'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showMessage(
                  'Edit Listing: ${property['title']}',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ================= FILTER BOTTOM SHEET =================

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Properties',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(_tabs.length, (index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedTab,
                  title: Text(_tabs[index]),
                  activeColor: primaryColor,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedTab = value;
                    });
                    Navigator.pop(sheetContext);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ================= BOTTOM NAVIGATION =================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          if (index == 1) {
            setState(() {
              _selectedIndex = 1;
            });
            return;
          }

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ownerdashboard(),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const managebookings(),
                ),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const propertyanalytics(),
                ),
              );
              break;
            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ownerprofile(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment_outlined),
            activeIcon: Icon(Icons.apartment),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            activeIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // ================= MAIN SCREEN =================

  @override
  Widget build(BuildContext context) {
    final filteredProperties = _filteredProperties;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 4),
              child: _buildHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummary(),
                    const SizedBox(height: 24),
                    _buildSearchBar(),
                    const SizedBox(height: 15),
                    _buildFilterChips(),
                    const SizedBox(height: 20),

                    if (filteredProperties.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 42,
                              color: secondaryColor,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No properties found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Try another search or status filter.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...filteredProperties.map(_buildPropertyCard),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
