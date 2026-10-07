import 'package:flutter/material.dart';

import 'owner_dashboard.dart';
import 'properties.dart';
import 'manage_bookings.dart';
import 'property_analytics.dart';
import 'owner_profile.dart';
import '../resources/imagescreen.dart';

class rentalrequests extends StatefulWidget {
  const rentalrequests({super.key});

  @override
  State<rentalrequests> createState() => _rentalrequestsState();
}

class _rentalrequestsState extends State<rentalrequests> {
  int _selectedIndex = 2;
  int _selectedTab = 0;

  final TextEditingController _searchController =
      TextEditingController();

  final List<String> _tabs = [
    'All',
    'Pending',
    'Approved',
    'Rejected',
  ];

  // ============================================================
  // STATIC RENTAL REQUESTS
  // ============================================================

  final List<Map<String, dynamic>> _requests = [
    {
      'requestId': 'request1',
      'tenantName': 'Sarah Jenkins',
      'profession': 'Software Engineer',
      'phone': '+1 555 234 5678',
      'status': 'Pending',
      'propertyName': 'The Aura - Luxury Loft',
      'location': 'Grand Avenue, Downtown, NYC',
      'rent': '₹4,250/month',
      'image': 'property1',
      'requestDate': 'October 24, 2026',
      'duration': '12 months',
      'occupants': '2 Adults',
      'budget': '₹4,500',
    },
    {
      'requestId': 'request2',
      'tenantName': 'Mark Thompson',
      'profession': 'Business Consultant',
      'phone': '+1 555 678 1234',
      'status': 'Approved',
      'propertyName': 'Sunset Studio',
      'location': 'Downtown, NYC',
      'rent': '₹2,850/month',
      'image': 'property2',
      'requestDate': 'October 22, 2026',
      'duration': '6 months',
      'occupants': '1 Adult',
      'budget': '₹3,000',
    },
    {
      'requestId': 'request3',
      'tenantName': 'Elena Rodriguez',
      'profession': 'Marketing Manager',
      'phone': '+1 555 987 6543',
      'status': 'Rejected',
      'propertyName': 'Modern City Apartment',
      'location': 'Central Avenue, NYC',
      'rent': '₹3,600/month',
      'image': 'property1',
      'requestDate': 'October 20, 2026',
      'duration': '12 months',
      'occupants': '2 Adults',
      'budget': '₹3,500',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  String _getString(
    dynamic value, [
    String fallback = '',
  ]) {
    if (value == null) return fallback;

    final String result = value.toString().trim();

    if (result.isEmpty) return fallback;

    return result;
  }

  String _getStatus(Map<String, dynamic> data) {
    return _getString(
      data['status'],
      'Pending',
    );
  }

  String _getPropertyImage(String imageName) {
    switch (imageName) {
      case 'property1':
        return property1;

      case 'property2':
        return property2;

      default:
        return property1;
    }
  }

  // ============================================================
  // REQUEST SEARCH
  // ============================================================

  bool _matchesSearch(
    Map<String, dynamic> data,
  ) {
    final String search =
        _searchController.text.trim().toLowerCase();

    if (search.isEmpty) {
      return true;
    }

    final String tenantName =
        _getString(
      data['tenantName'],
    ).toLowerCase();

    final String propertyName =
        _getString(
      data['propertyName'],
    ).toLowerCase();

    final String requestId =
        _getString(
      data['requestId'],
    ).toLowerCase();

    final String status =
        _getString(
      data['status'],
    ).toLowerCase();

    return tenantName.contains(search) ||
        propertyName.contains(search) ||
        requestId.contains(search) ||
        status.contains(search);
  }

  // ============================================================
  // TAB FILTER
  // ============================================================

  bool _matchesTab(
    Map<String, dynamic> data,
  ) {
    final String status =
        _getStatus(data).toLowerCase();

    if (_selectedTab == 0) {
      return true;
    }

    return status ==
        _tabs[_selectedTab].toLowerCase();
  }

  // ============================================================
  // UPDATE REQUEST STATUS - STATIC
  // ============================================================

  void _updateRequestStatus(
    String requestId,
    String newStatus,
  ) {
    final int index = _requests.indexWhere(
      (request) =>
          request['requestId'] == requestId,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _requests[index]['status'] = newStatus;
    });

    _showMessage(
      newStatus == 'Approved'
          ? 'Request approved successfully'
          : 'Request rejected successfully',
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),

        const Expanded(
          child: Text(
            'Rental Requests',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Stack(
          children: [
            IconButton(
              onPressed: () {
                _showMessage(
                  'No new notifications',
                );
              },
              icon: const Icon(
                Icons.notifications_none,
                size: 28,
              ),
            ),

            Positioned(
              right: 10,
              top: 8,
              child: Container(
                height: 9,
                width: 9,
                decoration:
                    const BoxDecoration(
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

  // ============================================================
  // SEARCH
  // ============================================================

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: TextField(
              controller:
                  _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration:
                  const InputDecoration(
                hintText:
                    'Search applicants',
                prefixIcon:
                    Icon(Icons.search),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(
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
            color: Colors.grey.shade100,
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              _showMessage(
                'Filter options',
              );
            },
            icon: const Icon(
              Icons.tune,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(
          _tabs.length,
          (index) {
            final bool isSelected =
                _selectedTab == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTab = index;
                  });
                },
                child: Container(
                  margin:
                      const EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(9),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(
                                0.06,
                              ),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.black
                            : Colors
                                .grey
                                .shade600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(
    String status,
  ) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor =
            Colors.green.shade50;
        textColor =
            Colors.green.shade700;
        break;

      case 'rejected':
        backgroundColor =
            Colors.red.shade50;
        textColor =
            Colors.red.shade700;
        break;

      default:
        backgroundColor =
            Colors.orange.shade50;
        textColor =
            Colors.orange.shade800;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // APPLICANT HEADER
  // ============================================================

  Widget _buildApplicantHeader({
    required String name,
    required String profession,
    required String phone,
    required String imagePath,
    required String status,
  }) {
    return Row(
      children: [
        ClipRRect(
          borderRadius:
              BorderRadius.circular(14),
          child: Image.asset(
            imagePath,
            height: 50,
            width: 50,
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
                ),
              ),

              const SizedBox(height: 4),

              Text(
                profession,
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                phone,
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        _buildStatusBadge(status),
      ],
    );
  }

  // ============================================================
  // PROPERTY INFO
  // ============================================================

  Widget _buildPropertyInfo({
    required String propertyName,
    required String location,
    required String price,
    required String imagePath,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(top: 18),
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons
                          .location_on_outlined,
                      size: 14,
                      color:
                          Colors.grey.shade600,
                    ),

                    const SizedBox(width: 3),

                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              Colors.grey
                                  .shade600,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  price,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAY DETAILS
  // ============================================================

  Widget _buildStayDetails({
    required String moveIn,
    required String duration,
    required String occupants,
    required String budget,
  }) {
    return Container(
      margin:
          const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  Icons
                      .calendar_today_outlined,
                  'Move-in',
                  moveIn,
                ),
              ),

              Expanded(
                child: _detailItem(
                  Icons.access_time,
                  'Duration',
                  duration,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _detailItem(
                  Icons.people_outline,
                  'Occupants',
                  occupants,
                ),
              ),

              Expanded(
                child: _detailItem(
                  Icons
                      .account_balance_wallet_outlined,
                  'Budget',
                  budget,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color:
                      Colors.grey.shade500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                style:
                    const TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTION ICONS
  // ============================================================

  Widget _buildActionIcons({
    required String phone,
  }) {
    return Row(
      children: [
        _actionIcon(
          Icons.person_outline,
          () {
            _showMessage(
              'Opening applicant profile',
            );
          },
        ),

        const SizedBox(width: 8),

        _actionIcon(
          Icons.description_outlined,
          () {
            _showMessage(
              'Opening documents',
            );
          },
        ),

        const SizedBox(width: 8),

        _actionIcon(
          Icons.chat_bubble_outline,
          () {
            _showMessage(
              'Opening chat',
            );
          },
        ),

        const SizedBox(width: 8),

        _actionIcon(
          Icons.call_outlined,
          () {
            if (phone.isEmpty) {
              _showMessage(
                'Phone number not available',
              );
            } else {
              _showMessage(
                'Calling $phone',
              );
            }
          },
        ),
      ],
    );
  }

  Widget _actionIcon(
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(9),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius:
              BorderRadius.circular(9),
        ),
        child: Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  // ============================================================
  // DECISION BUTTONS
  // ============================================================

  Widget _buildDecisionButtons({
    required String requestId,
    required String status,
  }) {
    final bool isPending =
        status.toLowerCase() == 'pending';

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isPending
                ? () {
                    _updateRequestStatus(
                      requestId,
                      'Rejected',
                    );
                  }
                : null,
            style:
                OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(
                color: Colors.red,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
            child: const Text(
              'Reject',
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: ElevatedButton(
            onPressed: isPending
                ? () {
                    _updateRequestStatus(
                      requestId,
                      'Approved',
                    );
                  }
                : null,
            style:
                ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor:
                  Colors.white,
              disabledBackgroundColor:
                  Colors.grey.shade300,
              disabledForegroundColor:
                  Colors.grey.shade600,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              padding:
                  const EdgeInsets.symmetric(
                vertical: 12,
              ),
            ),
            child: const Text(
              'Approve',
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REQUEST CARD
  // ============================================================

  Widget _buildRequestCard(
    Map<String, dynamic> data,
  ) {
    final String requestId =
        _getString(
      data['requestId'],
    );

    final String tenantName =
        _getString(
      data['tenantName'],
      'Applicant',
    );

    final String profession =
        _getString(
      data['profession'],
      'Tenant',
    );

    final String phone =
        _getString(
      data['phone'],
      '(Phone not available)',
    );

    final String status =
        _getStatus(data);

    final String propertyName =
        _getString(
      data['propertyName'],
      'Property',
    );

    final String location =
        _getString(
      data['location'],
      'Location not available',
    );

    final String price =
        _getString(
      data['rent'],
      '₹0/mo',
    );

    final String imageName =
        _getString(
      data['image'],
      'property1',
    );

    final String requestDate =
        _getString(
      data['requestDate'],
      'Not specified',
    );

    final String duration =
        _getString(
      data['duration'],
      '12 months',
    );

    final String occupants =
        _getString(
      data['occupants'],
      '2 Adults',
    );

    final String budget =
        _getString(
      data['budget'],
      '₹4,500',
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.04),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [

          _buildApplicantHeader(
            name: tenantName,
            profession: profession,
            phone: phone,
            imagePath: rentalProfile,
            status: status,
          ),

          _buildPropertyInfo(
            propertyName: propertyName,
            location: location,
            price: price,
            imagePath:
                _getPropertyImage(
              imageName,
            ),
          ),

          _buildStayDetails(
            moveIn: requestDate,
            duration: duration,
            occupants: occupants,
            budget: budget,
          ),

          const SizedBox(height: 18),

          const Divider(),

          const SizedBox(height: 8),

          Row(
            children: [
              const Text(
                'Applicant Actions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w600,
                ),
              ),

              const Spacer(),

              _buildActionIcons(
                phone: phone,
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildDecisionButtons(
            requestId: requestId,
            status: status,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    String message;

    if (_searchController.text
        .trim()
        .isNotEmpty) {
      message =
          'No requests found for your search.';
    } else if (_selectedTab == 1) {
      message =
          'No pending rental requests.';
    } else if (_selectedTab == 2) {
      message =
          'No approved rental requests.';
    } else if (_selectedTab == 3) {
      message =
          'No rejected rental requests.';
    } else {
      message =
          'No rental requests available.';
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 45,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 50,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 12),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUEST LIST - STATIC
  // ============================================================

  Widget _buildRequestList() {
    final List<Map<String, dynamic>>
        filteredRequests =
        _requests.where((request) {
      return _matchesTab(request) &&
          _matchesSearch(request);
    }).toList();

    if (filteredRequests.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        for (
          int i = 0;
          i < filteredRequests.length;
          i++
        ) ...[
          _buildRequestCard(
            filteredRequests[i],
          ),

          if (i !=
              filteredRequests.length - 1)
            const SizedBox(height: 16),
        ],
      ],
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  void _onBottomNavTap(
    int index,
  ) {
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
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const ownerprofile(),
        ),
      );
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      type:
          BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: _onBottomNavTap,
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

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar:
          _buildBottomNavigation(),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            25,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              _buildHeader(),

              const SizedBox(height: 22),

              _buildSearchBar(),

              const SizedBox(height: 18),

              _buildTabs(),

              const SizedBox(height: 25),

              const Text(
                'Rental Requests',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 14),

              _buildRequestList(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}