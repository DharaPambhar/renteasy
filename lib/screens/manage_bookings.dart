
import 'package:flutter/material.dart';

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

  final TextEditingController _searchController =
      TextEditingController();

  final List<String> _tabs = [
    'All',
    'Pending',
    'Confirmed',
    'Upcoming',
  ];

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Alex Rivera',
      'property': 'Skyline Vista Penthouse',
      'location': 'Downtown Core',
      'price': '₹3,200',
      'id': 'RE-92841',
      'date': 'Oct 24, 2026',
      'duration': '12 Months',
      'guests': '2 Adults',
      'status': 'Pending',
      'image': property1,
      'phone': '+1 555 010 9284',
      'verified': true,
    },
    {
      'name': 'Sarah Jenkins',
      'property': 'The Loft at 5th Ave',
      'location': 'Midtown East',
      'price': '₹2,850',
      'id': 'RE-92842',
      'date': 'Nov 01, 2026',
      'duration': '12 Months',
      'guests': '2 Adults',
      'status': 'Confirmed',
      'image': property2,
      'phone': '+1 555 010 4281',
      'verified': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredBookings {
    final query = _searchController.text.toLowerCase().trim();

    return _bookings.where((booking) {
      final matchesTab = _selectedTab == 0 ||
          booking['status'] == _tabs[_selectedTab];

      final matchesSearch = query.isEmpty ||
          booking['name'].toString().toLowerCase().contains(query) ||
          booking['property'].toString().toLowerCase().contains(query) ||
          booking['id'].toString().toLowerCase().contains(query) ||
          booking['status'].toString().toLowerCase().contains(query);

      return matchesTab && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFFA726);
      case 'Confirmed':
        return const Color(0xFF16A34A);
      case 'Upcoming':
        return const Color(0xFF2563EB);
      case 'Cancelled':
        return const Color(0xFFDC2626);
      default:
        return Colors.grey;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirm Booking'),
        content: Text(
          'Do you want to confirm the booking for ${booking['name']}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                booking['status'] = 'Confirmed';
              });
              Navigator.pop(dialogContext);
              _showMessage('Booking confirmed successfully!');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: Text(
          'Are you sure you want to cancel ${booking['name']}\'s booking?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Keep Booking'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              setState(() {
                booking['status'] = 'Cancelled';
              });
              Navigator.pop(dialogContext);
              _showMessage('Booking cancelled.');
            },
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }

  Future<void> _rescheduleBooking(
    Map<String, dynamic> booking,
  ) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (selectedDate != null && mounted) {
      setState(() {
        booking['date'] =
            '${_monthName(selectedDate.month)} '
            '${selectedDate.day}, ${selectedDate.year}';
      });

      _showMessage('Visit date updated temporarily.');
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    return months[month - 1];
  }

  void _showContactDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(booking['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Information'),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone_outlined),
                const SizedBox(width: 10),
                Expanded(child: Text(booking['phone'])),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'This is sample contact information for the static UI.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLeaseDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Lease Agreement'),
        content: Text(
          'Booking ID: ${booking['id']}\n\n'
          'Tenant: ${booking['name']}\n'
          'Property: ${booking['property']}\n'
          'Monthly Rent: ${booking['price']}\n\n'
          'This is a static preview. No lease document is attached.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(Map<String, dynamic> booking) {
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
                'Booking Options',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Booking Details'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showLeaseDialog(booking);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.calendar_month_outlined,
                ),
                title: const Text('Reschedule Visit'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _rescheduleBooking(booking);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                ),
                title: const Text(
                  'Cancel Booking',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _cancelBooking(booking);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _overviewCard(
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
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFF202033),
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildOverview() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _overviewCard(
          'Total Bookings',
          '128',
          Icons.calendar_month_outlined,
          const Color(0xFF7354AD),
        ),
        _overviewCard(
          'Upcoming Visits',
          '12',
          Icons.event_available_outlined,
          const Color(0xFF2563EB),
        ),
        _overviewCard(
          'Active Rentals',
          '42',
          Icons.key_outlined,
          const Color(0xFF16A34A),
        ),
        _overviewCard(
          'Completed',
          '74',
          Icons.task_alt_outlined,
          const Color(0xFFF59E0B),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final status = booking['status'] as String;
    final isPending = status == 'Pending';
    final isConfirmed = status == 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _statusColor(status),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: _statusColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => _showMoreOptions(booking),
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  booking['image'],
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 76,
                      height: 76,
                      color: const Color(0xFFF0ECFA),
                      child: const Icon(
                        Icons.apartment,
                        size: 34,
                        color: Color(0xFF7354AD),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['property'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF242238),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            booking['location'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF7354AD),
                        ),
                        children: [
                          TextSpan(
                            text: booking['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const TextSpan(
                            text: ' / month',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  rentalProfile,
                  width: 42,
                  height: 42,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 42,
                      height: 42,
                      color: const Color(0xFFEDE7F6),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF7354AD),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            booking['name'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (booking['verified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 15,
                            color: Color(0xFF2563EB),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Booking ID: #${booking['id']}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _detailItem(
                  Icons.calendar_today_outlined,
                  isConfirmed ? 'Move-in Date' : 'Visit Date',
                  booking['date'],
                ),
              ),
              Expanded(
                child: _detailItem(
                  Icons.schedule_outlined,
                  'Duration',
                  booking['duration'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _detailItem(
            Icons.people_outline,
            'Tenants',
            booking['guests'],
          ),
          const SizedBox(height: 18),
          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContactDialog(booking),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showContactDialog(booking),
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Call'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7354AD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _confirmBooking(booking),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Booking'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _rescheduleBooking(booking),
                    child: const Text('Reschedule'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _cancelBooking(booking),
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ] else if (isConfirmed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Color(0xFF16A34A),
                    size: 19,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Deposit Paid',
                      style: TextStyle(
                        color: Color(0xFF15803D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLeaseDialog(booking),
                icon: const Icon(Icons.description_outlined),
                label: const Text('View Lease Agreement'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showContactDialog(booking),
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showLeaseDialog(booking),
                    icon: const Icon(Icons.info_outline),
                    label: const Text('Details'),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showLeaseDialog(booking),
                child: const Text('View Booking Details'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailItem(
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: const Color(0xFF7354AD),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF28263A),
                ),
              ),
            ],
          ),
        ),
      ],
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
                'Filter Bookings',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const properties(),
                ),
              );
              break;
            case 2:
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

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;

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
          'Manage Bookings',
          style: TextStyle(
            color: Color(0xFF28263A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMessage('No new notifications.'),
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF28263A),
            ),
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
              const Text(
                'Booking Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF28263A),
                ),
              ),
              const SizedBox(height: 14),
              _buildOverview(),
              const SizedBox(height: 24),
              const Text(
                'All Bookings',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF28263A),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search bookings...',
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEAEAF0),
                      ),
                    ),
                    child: IconButton(
                      onPressed: _showFilterOptions,
                      icon: const Icon(
                        Icons.tune,
                        color: Color(0xFF7354AD),
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
                          color: selected
                              ? Colors.white
                              : const Color(0xFF5E5B70),
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
              if (bookings.isEmpty)
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
                        'No bookings found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Try another search or filter.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              else
                ...bookings.map(_buildBookingCard),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
