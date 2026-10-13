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

  final List<String> _tabs = [
    'All',
    'Active',
    'Pending',
    'Rented',
  ];

  // Only 2 properties remain
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
        return const Color(0xFF16A34A);
      case 'Rented':
        return const Color(0xFF2563EB);
      case 'Pending':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF7354AD);
    }
  }

  List<Map<String, dynamic>> get _filteredProperties {
    final query = _searchController.text.toLowerCase().trim();

    return _propertyList.where((property) {
      final matchesTab = _selectedTab == 0 ||
          property['status'] == _tabs[_selectedTab];

      final matchesSearch = query.isEmpty ||
          property['title'].toString().toLowerCase().contains(query) ||
          property['location'].toString().toLowerCase().contains(query) ||
          property['id'].toString().toLowerCase().contains(query) ||
          property['status'].toString().toLowerCase().contains(query);

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

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEAEAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF242238),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF777789),
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
      childAspectRatio: 1.65,
      children: [
        _summaryCard(
          'Total Properties',
          '24',
          Icons.apartment,
          const Color(0xFF2563EB),
        ),
        _summaryCard(
          'Active',
          '18',
          Icons.verified_outlined,
          const Color(0xFF16A34A),
        ),
        _summaryCard(
          'Rented',
          '12',
          Icons.key_outlined,
          const Color(0xFF7354AD),
        ),
        _summaryCard(
          'Pending',
          '06',
          Icons.hourglass_empty,
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final status = property['status'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
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
                      color: const Color(0xFFF0ECFA),
                      child: const Icon(
                        Icons.apartment,
                        size: 60,
                        color: Color(0xFF7354AD),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
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
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFF59E0B),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        property['rating'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
                Text(
                  property['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF242238),
                  ),
                ),
                const SizedBox(height: 9),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFF7354AD),
                    ),
                    children: [
                      TextSpan(
                        text: property['price'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' / month',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 17,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        property['location'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF777789),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7FC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _specification(
                        Icons.bed_outlined,
                        property['beds'],
                      ),
                      _specification(
                        Icons.bathtub_outlined,
                        property['baths'],
                      ),
                      Flexible(
                        child: _specification(
                          Icons.square_foot,
                          property['area'],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.tag,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'ID: #${property['id']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Text(
                      'Posted ${property['posted']}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE7F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chair_outlined,
                          size: 15,
                          color: Color(0xFF7354AD),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          property['tag'],
                          style: const TextStyle(
                            color: Color(0xFF7354AD),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (status == 'Active') ...[
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
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(
                            Icons.edit_outlined,
                            size: 17,
                          ),
                          label: const Text('Edit Listing'),
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
                  ),
                ] else ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              _showPropertyDetails(property),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF7354AD),
                            padding: const EdgeInsets.symmetric(
                              vertical: 13,
                            ),
                            side: const BorderSide(
                              color: Color(0xFF7354AD),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('View Details'),
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
          color: const Color(0xFF7354AD),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF5F5B70),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE4E1ED)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: const Color(0xFF5F5B70),
          size: 20,
        ),
      ),
    );
  }

  void _showPropertyDetails(Map<String, dynamic> property) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
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
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showPropertyDetails(property);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Share Listing'),
              onTap: () {
                Navigator.pop(sheetContext);
                _showMessage('Share: ${property['title']}');
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
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

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEAEAF0)),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF7354AD),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        onTap: (index) {
          setState(() => _selectedIndex = index);

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ownerdashboard(),
                ),
              );
              break;
            case 1:
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.apartment_outlined),
            activeIcon: Icon(Icons.apartment),
            label: 'Properties',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.calendar_month_outlined),
                Positioned(
                  right: -5,
                  top: -4,
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
            activeIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.calendar_month),
                Positioned(
                  right: -5,
                  top: -4,
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
            label: 'Bookings',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties = _filteredProperties;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7FC),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: Color(0xFF28263A),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const ownerdashboard(),
              ),
            );
          },
        ),
        title: const Text(
          'My Properties',
          style: TextStyle(
            color: Color(0xFF28263A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () =>
                    _showMessage('No new notifications.'),
                icon: const Icon(
                  Icons.notifications_none,
                  color: Color(0xFF28263A),
                ),
              ),
              Positioned(
                right: 11,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummary(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search properties...',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEAEAF0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFEAEAF0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF7354AD),
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
                      color: const Color(0xFF7354AD),
                      borderRadius: BorderRadius.circular(12),
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
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final selected = _selectedTab == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(_tabs[index]),
                        selected: selected,
                        showCheckmark: false,
                        selectedColor: const Color(0xFF7354AD),
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? const Color(0xFF7354AD)
                              : const Color(0xFFEAEAF0),
                        ),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (_) {
                          setState(() => _selectedTab = index);
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 18),
              if (filteredProperties.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 42,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No properties found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Try another search or status filter.',
                        style: TextStyle(color: Colors.grey),
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
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
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(_tabs.length, (index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedTab,
                  title: Text(_tabs[index]),
                  activeColor: const Color(0xFF7354AD),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedTab = value);
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
}