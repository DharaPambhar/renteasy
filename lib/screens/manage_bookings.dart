
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

  // Blue color palette
  final Color primaryPurple = const Color(0xFF2563EB);
  final Color lightPurple = const Color(0xFFDBEAFE);
  final Color screenBackground = const Color(0xFFF8FAFC);
  final Color primaryText = const Color(0xFF111827);
  final Color secondaryText = const Color(0xFF6B7280);
  final Color borderColor = const Color(0xFFE5E7EB);
  final Color cancelRed = const Color(0xFFDC2626);

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'All';

  final List<Map<String, dynamic>> _bookings = [
    {
      'name': 'Alex Rivera',
      'property': 'Skyline Vista Penthouse',
      'location': 'Downtown Core',
      'price': '₹3,200',
      'id': '#RE-92841',
      'date': 'Oct 24, 2026',
      'duration': '12 Months',
      'guests': '2 Adults',
      'status': 'Pending',
      'image': property1,
      'profile': alex,
      'phone': '+1 (555) 0123',
      'verified': true,
      'depositPaid': false,
    },
    {
      'name': 'Sarah Jenkins',
      'property': 'The Loft at 5th Ave',
      'location': 'Midtown East',
      'price': '₹2,850',
      'id': '#RE-92842',
      'date': 'Nov 01, 2026',
      'duration': '12 Months',
      'guests': '2 Adults',
      'status': 'Confirmed',
      'image': property2,
      'profile': sarah,
      'phone': '+1 (555) 9876',
      'verified': true,
      'depositPaid': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredBookings {
    final query = _searchController.text.toLowerCase().trim();

    return _bookings.where((booking) {
      final matchesSearch =
          booking['name'].toString().toLowerCase().contains(query) ||
          booking['property'].toString().toLowerCase().contains(query) ||
          booking['id'].toString().toLowerCase().contains(query);

      final matchesFilter = _selectedFilter == 'All' ||
          booking['status'].toString() == _selectedFilter;

      return matchesSearch && matchesFilter;
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
        return const Color(0xFFD97706);
      case 'Confirmed':
        return const Color(0xFF2563EB);
      case 'Upcoming':
        return const Color(0xFF2563EB);
      case 'Completed':
        return const Color(0xFF15803D);
      case 'Cancelled':
        return cancelRed;
      default:
        return secondaryText;
    }
  }

  Color _statusBackground(String status) {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFFF4D9);
      case 'Confirmed':
        return const Color(0xFFDBEAFE);
      case 'Upcoming':
        return const Color(0xFFDBEAFE);
      case 'Completed':
        return const Color(0xFFE7F8ED);
      case 'Cancelled':
        return const Color(0xFFFFEEEE);
      default:
        return const Color(0xFFF0F0F5);
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: cancelRed,
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

  void _rescheduleBooking(Map<String, dynamic> booking) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryPurple,
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

      _showMessage('Booking date updated successfully.');
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
        title: Text(booking['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: lightPurple,
              backgroundImage: AssetImage(booking['profile']),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone_outlined, color: primaryPurple),
                const SizedBox(width: 10),
                Text(booking['phone']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.email_outlined, color: primaryPurple),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Contact through RentEasy'),
                ),
              ],
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
        title: const Text('Lease Agreement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tenant: ${booking['name']}'),
            const SizedBox(height: 8),
            Text('Property: ${booking['property']}'),
            const SizedBox(height: 8),
            Text('Rent: ${booking['price']} / month'),
            const SizedBox(height: 8),
            Text('Duration: ${booking['duration']}'),
            const SizedBox(height: 8),
            Text('Move-in / Booking date: ${booking['date']}'),
            const SizedBox(height: 12),
            const Text(
              'Lease information preview',
              style: TextStyle(
                color: Colors.grey,
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

  void _showMoreOptions(Map<String, dynamic> booking) {
    showModalBottomSheet(
      context: context,
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
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Booking Options',
                style: TextStyle(
                  color: primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Icon(
                  Icons.event_outlined,
                  color: primaryPurple,
                ),
                title: const Text('Reschedule Booking'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _rescheduleBooking(booking);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.description_outlined,
                  color: primaryPurple,
                ),
                title: const Text('View Lease Agreement'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showLeaseDialog(booking);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel_outlined,
                  color: cancelRed,
                ),
                title: const Text('Cancel Booking'),
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

  // Summary Cards: label on top, number below
  Widget _overviewCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(16),
  border: Border.all(
    color: const Color(0xFFE5E7EB),
  ),
),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: iconColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _overviewCard(
          title: 'Total Bookings',
          value: '128',
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xFF2563EB),
        ),
        _overviewCard(
          title: 'Upcoming Visits',
          value: '12',
          icon: Icons.event_available_outlined,
          iconColor: const Color(0xFFB7791F),
        ),
        _overviewCard(
          title: 'Active Rentals',
          value: '42',
          icon: Icons.key_outlined,
          iconColor: const Color(0xFF111827),
        ),
        _overviewCard(
          title: 'Completed',
          value: '74',
          icon: Icons.check_circle_outline,
          iconColor: const Color(0xFF111827),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _statusBackground(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _detailItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 17,
          color: secondaryText,
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: primaryText,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final isPending = booking['status'] == 'Pending';
    final isConfirmed = booking['status'] == 'Confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  booking['profile'] as String,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      color: lightPurple,
                      alignment: Alignment.center,
                      child: Text(
                        booking['name']
                            .toString()
                            .split(' ')
                            .map((part) => part[0])
                            .take(2)
                            .join(),
                        style: TextStyle(
                          color: primaryPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            booking['name'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: primaryText,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (booking['verified'] == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF3B82F6),
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      booking['phone'],
                      style: TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              _buildStatusBadge(booking['status']),
            ],
          ),

          const SizedBox(height: 16),

          // Property details
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    booking['image'] as String,
                    width: 94,
                    height: 92,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 94,
                        height: 92,
                        color: lightPurple,
                        child: Icon(
                          Icons.home_outlined,
                          color: primaryPurple,
                          size: 32,
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: secondaryText,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              booking['location'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: booking['price'],
                              style: TextStyle(
                                color: primaryPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: ' /mo',
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 11,
                              ),
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

          if (isPending) ...[
            Row(
              children: [
                Expanded(
                  child: _detailItem(
                    Icons.confirmation_number_outlined,
                    'Booking ID',
                    booking['id'],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _detailItem(
                    Icons.calendar_today_outlined,
                    'Visit Date',
                    booking['date'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _detailItem(
                    Icons.timelapse_outlined,
                    'Lease Duration',
                    booking['duration'],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _detailItem(
                    Icons.people_outline,
                    'Occupants',
                    booking['guests'],
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: _detailItem(
                    Icons.calendar_today_outlined,
                    'Move-in Date',
                    booking['date'],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _detailItem(
                    Icons.account_balance_wallet_outlined,
                    'Deposit Status',
                    booking['depositPaid'] == true
                        ? 'Deposit Paid'
                        : 'Not Paid',
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          Divider(color: borderColor, height: 1),
          const SizedBox(height: 14),

          // Chat and call actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showContactDialog(booking),
                  icon: Icon(
                    Icons.chat_bubble_outline,
                    size: 17,
                    color: primaryPurple,
                  ),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryPurple,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showContactDialog(booking),
                  icon: Icon(
                    Icons.call_outlined,
                    size: 17,
                    color: primaryPurple,
                  ),
                  label: const Text('Call'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryPurple,
                    side: BorderSide(color: borderColor),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
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

          if (isPending) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmBooking(booking),
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 18,
                ),
                label: const Text('Confirm Booking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rescheduleBooking(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryText,
                      side: BorderSide(color: borderColor),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Reschedule'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _cancelBooking(booking),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cancelRed,
                      side: BorderSide(
                        color: cancelRed.withValues(alpha: 0.35),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ] else if (isConfirmed) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showLeaseDialog(booking),
                icon: Icon(
                  Icons.description_outlined,
                  color: primaryPurple,
                  size: 18,
                ),
                label: const Text('View Lease Agreement'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryPurple,
                  side: BorderSide(color: borderColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('Booking Details'),
                      content: Text(
                        'Tenant: ${booking['name']}\n'
                        'Property: ${booking['property']}\n'
                        'Booking ID: ${booking['id']}\n'
                        'Move-in Date: ${booking['date']}\n'
                        'Deposit: ${booking['depositPaid'] == true ? 'Paid' : 'Not Paid'}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              const SizedBox(height: 15),
              ...['All', 'Pending', 'Confirmed', 'Upcoming', 'Completed']
                  .map(
                (filter) => ListTile(
                  title: Text(filter),
                  trailing: _selectedFilter == filter
                      ? Icon(
                          Icons.check_circle,
                          color: primaryPurple,
                        )
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
                    });
                    Navigator.pop(sheetContext);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      {
        'label': 'Dashboard',
        'icon': Icons.dashboard_outlined,
      },
      {
        'label': 'Properties',
        'icon': Icons.home_work_outlined,
      },
      {
        'label': 'Bookings',
        'icon': Icons.calendar_month_outlined,
      },
      {
        'label': 'Analytics',
        'icon': Icons.bar_chart_outlined,
      },
      {
        'label': 'Profile',
        'icon': Icons.person_outline,
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: borderColor),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = _selectedIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (index == _selectedIndex) return;

                    setState(() {
                      _selectedIndex = index;
                    });

                    Widget page;

                    switch (index) {
                      case 0:
                        page = const ownerdashboard();
                        break;
                      case 1:
                        page = const properties();
                        break;
                      case 3:
                        page = const propertyanalytics();
                        break;
                      case 4:
                        page = const ownerprofile();
                        break;
                      default:
                        page = const managebookings();
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => page,
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[index]['icon'] as IconData,
                          color: selected
                              ? primaryPurple
                              : secondaryText,
                          size: 22,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          items[index]['label'] as String,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: selected
                                ? primaryPurple
                                : secondaryText,
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackground,
      appBar: AppBar(
        backgroundColor: screenBackground,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: primaryPurple,
            size: 20,
          ),
        ),
        title: Text(
          'Manage Bookings',
          style: TextStyle(
            color: primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: () {
                    _showMessage('You are all caught up!');
                  },
                  icon: Icon(
                    Icons.notifications_none_rounded,
                    color: primaryPurple,
                    size: 27,
                  ),
                ),
                Positioned(
                  top: 9,
                  right: 9,
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
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverview(),
              const SizedBox(height: 22),

              // Search field and filter button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search bookings...',
                          hintStyle: TextStyle(
                            color: secondaryText,
                            fontSize: 13,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: secondaryText,
                          ),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 14),
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
                      border: Border.all(color: borderColor),
                    ),
                    child: IconButton(
                      onPressed: _showFilterOptions,
                      icon: Icon(
                        Icons.tune_rounded,
                        color: primaryText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Pending', 'Confirmed', 'Upcoming']
                      .map((filter) {
                    final selected = _selectedFilter == filter;

                    return Padding(
                      padding: const EdgeInsets.only(right: 9),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        showCheckmark: false,
                        selectedColor: primaryPurple,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected
                              ? Colors.white
                              : secondaryText,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(
                          color: selected
                              ? primaryPurple
                              : borderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Booking Requests',
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${_filteredBookings.length} bookings',
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 13),

              if (_filteredBookings.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 35,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off_rounded,
                        size: 42,
                        color: secondaryText,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No bookings found',
                        style: TextStyle(
                          color: primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Try another search or filter.',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ..._filteredBookings.map(_buildBookingCard),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
