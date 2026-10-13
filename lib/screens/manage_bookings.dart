
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

  final Color primaryPurple = const Color(0xFF7354AD);
  final Color lightPurple = const Color(0xFFF0ECFA);
  final Color screenBackground = const Color(0xFFF8F9FD);
  final Color primaryText = const Color(0xFF28263A);
  final Color secondaryText = const Color(0xFF777789);
  final Color borderColor = const Color(0xFFEAEAF0);
  final Color cancelRed = const Color(0xFFDC2626);

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
      'phone': '+1 (555) 0123',
      'verified': true,
      'depositPaid': false,
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
      'phone': '+1 (555) 9876',
      'verified': true,
      'depositPaid': true,
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
          booking['status'].toString().toLowerCase().contains(query) ||
          booking['phone'].toString().toLowerCase().contains(query);

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
        return const Color(0xFFC77720);
      case 'Confirmed':
        return primaryPurple;
      case 'Upcoming':
        return const Color(0xFF2563EB);
      case 'Cancelled':
        return cancelRed;
      default:
        return secondaryText;
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFFF0E0);
      case 'Confirmed':
        return lightPurple;
      case 'Upcoming':
        return const Color(0xFFEFF6FF);
      case 'Cancelled':
        return const Color(0xFFFEF2F2);
      default:
        return const Color(0xFFF3F4F6);
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
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryPurple,
              foregroundColor: Colors.white,
            ),
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
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: cancelRed,
              side: BorderSide(color: cancelRed),
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
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryPurple,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Expanded(child: Text(booking['name'])),
            if (booking['verified'] == true)
              const Icon(
                Icons.verified,
                color: Color(0xFF2563EB),
                size: 20,
              ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Information',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF28263A),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.phone_outlined, color: primaryPurple),
                const SizedBox(width: 10),
                Expanded(child: Text(booking['phone'])),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_month_outlined, color: primaryPurple),
                const SizedBox(width: 10),
                Expanded(child: Text('Booking ID: #${booking['id']}')),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Sample contact information. Calling and messaging are not connected to a phone service.',
              style: TextStyle(
                color: secondaryText,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: TextStyle(color: primaryPurple),
            ),
          ),
        ],
      ),
    );
  }

  void _showLeaseDialog(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Row(
          children: [
            Icon(Icons.description_outlined, color: primaryPurple),
            const SizedBox(width: 10),
            const Expanded(child: Text('Lease Agreement')),
          ],
        ),
        content: Text(
          'Booking ID: #${booking['id']}\n\n'
          'Tenant: ${booking['name']}\n'
          'Phone: ${booking['phone']}\n'
          'Property: ${booking['property']}\n'
          'Location: ${booking['location']}\n'
          'Monthly Rent: ${booking['price']}\n'
          'Move-in Date: ${booking['date']}\n'
          'Lease Duration: ${booking['duration']}\n\n'
          'This is a static preview. No actual lease document is attached.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Close',
              style: TextStyle(color: primaryPurple),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
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
                  color: Color(0xFF28263A),
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: primaryPurple,
                ),
                title: const Text('Booking Details'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showLeaseDialog(booking);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_month_outlined,
                  color: primaryPurple,
                ),
                title: const Text('Reschedule Visit'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _rescheduleBooking(booking);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel_outlined,
                  color: cancelRed,
                ),
                title: Text(
                  'Cancel Booking',
                  style: TextStyle(color: cancelRed),
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
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
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
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: secondaryText,
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
          primaryPurple,
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

  Widget _buildStatusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
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
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildStatusBadge(status),
              const Spacer(),
              IconButton(
                onPressed: () => _showMoreOptions(booking),
                icon: Icon(
                  Icons.more_horiz,
                  color: secondaryText,
                ),
                tooltip: 'More options',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Property information
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF8FE),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    booking['image'],
                    width: 82,
                    height: 88,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 82,
                        height: 88,
                        color: lightPurple,
                        child: Icon(
                          Icons.apartment,
                          size: 34,
                          color: primaryPurple,
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
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              booking['location'],
                              style: TextStyle(
                                fontSize: 12,
                                color: secondaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(color: primaryPurple),
                          children: [
                            TextSpan(
                              text: booking['price'],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text: ' /mo',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tenant information
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  rentalProfile,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 44,
                      height: 44,
                      color: lightPurple,
                      child: Icon(
                        Icons.person,
                        color: primaryPurple,
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: primaryText,
                            ),
                          ),
                        ),
                        if (booking['verified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 16,
                            color: Color(0xFF2563EB),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['phone'],
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'BOOKING ID  #${booking['id']}',
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 10,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(height: 1, color: borderColor),
          const SizedBox(height: 16),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _detailItem(
                  Icons.calendar_today_outlined,
                  isConfirmed ? 'MOVE-IN DATE' : 'VISIT DATE',
                  booking['date'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _detailItem(
                  Icons.schedule_outlined,
                  'LEASE DURATION',
                  booking['duration'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _detailItem(
            Icons.people_outline,
            'OCCUPANTS',
            booking['guests'],
          ),

          const SizedBox(height: 18),

          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryPurple,
                      backgroundColor: lightPurple.withValues(alpha: 0.45),
                      side: BorderSide(
                        color: primaryPurple.withValues(alpha: 0.25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _showContactDialog(booking),
                    icon: const Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                    ),
                    label: const Text('Chat'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryPurple,
                      backgroundColor: lightPurple.withValues(alpha: 0.45),
                      side: BorderSide(
                        color: primaryPurple.withValues(alpha: 0.25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _showContactDialog(booking),
                    icon: const Icon(
                      Icons.call_outlined,
                      size: 18,
                    ),
                    label: const Text('Call'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                onPressed: () => _confirmBooking(booking),
                icon: const Icon(Icons.check_circle_outline, size: 19),
                label: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _rescheduleBooking(booking),
                    child: Text(
                      'Reschedule',
                      style: TextStyle(
                        color: primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cancelRed,
                      backgroundColor: const Color(0xFFFFF8F8),
                      side: BorderSide(
                        color: cancelRed.withValues(alpha: 0.65),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _cancelBooking(booking),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ] else if (isConfirmed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightPurple,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryPurple.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: primaryPurple,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking['depositPaid'] == true
                          ? 'Deposit Paid'
                          : 'Deposit Pending',
                      style: TextStyle(
                        color: primaryPurple,
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
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryPurple,
                  backgroundColor: lightPurple.withValues(alpha: 0.35),
                  side: BorderSide(
                    color: primaryPurple.withValues(alpha: 0.3),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _showLeaseDialog(booking),
                icon: const Icon(Icons.description_outlined, size: 18),
                label: const Text('View Lease Agreement'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showContactDialog(booking),
                    icon: Icon(
                      Icons.chat_bubble_outline,
                      color: primaryPurple,
                      size: 18,
                    ),
                    label: Text(
                      'Chat',
                      style: TextStyle(color: primaryPurple),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _showLeaseDialog(booking),
                    icon: Icon(
                      Icons.info_outline,
                      color: primaryPurple,
                      size: 18,
                    ),
                    label: Text(
                      'Details',
                      style: TextStyle(color: primaryPurple),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryPurple,
                  side: BorderSide(color: primaryPurple),
                ),
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
          color: primaryPurple,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 0.35,
                  color: secondaryText,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primaryText,
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Bookings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 14),
              ...List.generate(_tabs.length, (index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedTab,
                  title: Text(_tabs[index]),
                  activeColor: primaryPurple,
                  contentPadding: EdgeInsets.zero,
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryPurple,
        unselectedItemColor: const Color(0xFF9292A0),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        elevation: 0,
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
      backgroundColor: screenBackground,
      appBar: AppBar(
        backgroundColor: screenBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 19,
            color: primaryText,
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
        title: Text(
          'Manage Bookings',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMessage('No new notifications.'),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none,
                  color: primaryText,
                  size: 25,
                ),
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
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
              Text(
                'Booking Overview',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 14),
              _buildOverview(),

              const SizedBox(height: 24),

              Text(
                'All Bookings',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 14),

              // Search and filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        fontSize: 14,
                        color: primaryText,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search bookings',
                        hintStyle: TextStyle(
                          color: secondaryText,
                          fontSize: 13,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: secondaryText,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: primaryPurple,
                            width: 1.4,
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
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      onPressed: _showFilterOptions,
                      icon: Icon(
                        Icons.tune,
                        color: primaryPurple,
                      ),
                      tooltip: 'Filter bookings',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Category tabs
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
                        selectedColor: primaryPurple,
                        backgroundColor: Colors.white,
                        side: BorderSide(
                          color: selected
                              ? primaryPurple
                              : borderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : const Color(0xFF666477),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 42,
                        color: secondaryText,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No bookings found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try another search or filter.',
                        style: TextStyle(color: secondaryText),
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
