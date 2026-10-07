import 'package:flutter/material.dart';

import 'owner_login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Static simulation - no Firebase/backend
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Reset Link Sent',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'A password reset link has been sent to your registered email address. Please check your inbox.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ownerlogin(),
                  ),
                );
              },
              child: const Text(
                'Back to Login',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 450,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Header
                    Row(
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
                          child: Center(
                            child: Text(
                              'RentEasy',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 48),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Step Indicator
                    Row(
                      children: [
                        _step(
                          number: '1',
                          title: 'Details',
                          active: true,
                        ),

                        Expanded(
                          child: Container(
                            height: 2,
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),

                        _step(
                          number: '2',
                          title: 'Verify',
                          active: false,
                        ),

                        Expanded(
                          child: Container(
                            height: 2,
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),

                        _step(
                          number: '3',
                          title: 'New',
                          active: false,
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // Illustration
                    Center(
                      child: Container(
                        height: 190,
                        width: 240,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.lock_reset_rounded,
                            size: 90,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title
                    const Center(
                      child: Text(
                        'Forgot Password?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Subtitle
                    const Center(
                      child: Text(
                        'Enter your registered email or mobile number to reset your owner account password.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            'Email Address / Mobile Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'owner@example.com',
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2563EB),
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Email cannot be blank';
                              }

                              final emailRegex = RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              );

                              if (!emailRegex.hasMatch(
                                value.trim(),
                              )) {
                                return 'Please enter a valid email address';
                              }

                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // Send Reset Link
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _sendResetLink,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    const Color(0xFF93B4F4),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<
                                                Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Send Reset Link',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Login
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Remember your password? ',
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ownerlogin(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Login Now',
                                  style: TextStyle(
                                    color: Color(0xFF2563EB),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _step({
    required String number,
    required String title,
    required bool active,
  }) {
    return Column(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active
                ? const Color(0xFF2563EB)
                : const Color(0xFFE5E7EB),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: active
                    ? Colors.white
                    : const Color(0xFF6B7280),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight:
                active ? FontWeight.w600 : FontWeight.normal,
            color: active
                ? const Color(0xFF2563EB)
                : const Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}