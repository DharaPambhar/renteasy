import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class addproperty extends StatefulWidget {
  const addproperty({super.key});

  @override
  State<addproperty> createState() => _addpropertyState();
}

class _addpropertyState extends State<addproperty> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController propertyNameController =
      TextEditingController();

  final TextEditingController locationController =
      TextEditingController();

  final TextEditingController rentController =
      TextEditingController();

  final TextEditingController bedroomsController =
      TextEditingController();

  final TextEditingController bathroomsController =
      TextEditingController();

  final TextEditingController areaController =
      TextEditingController();

  final TextEditingController ratingController =
      TextEditingController();

  String selectedStatus = 'Active';
  String selectedImage = 'property1';
  bool furnished = true;
  bool isLoading = false;

  String formatRent(String value) {
    final number = int.tryParse(value.replaceAll(',', ''));

    if (number == null) {
      return '₹$value';
    }

    final formatted = number.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    return '₹$formatted';
  }

  Future<void> addProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final String propertyName =
          propertyNameController.text.trim();

      final String location =
          locationController.text.trim();

      final String rent =
          formatRent(rentController.text.trim());

      final String bedrooms =
          bedroomsController.text.trim();

      final String bathrooms =
          bathroomsController.text.trim();

      final String area =
          areaController.text.trim();

      final double rating =
          double.tryParse(ratingController.text.trim()) ?? 0.0;

      final String specs =
          '$bedrooms Bed • $bathrooms Bath • $area sq.ft.';

      await FirebaseFirestore.instance
          .collection('properties')
          .add({
        'ownerId': user.uid,
        'propertyName': propertyName,
        'rent': rent,
        'location': location,
        'specs': specs,
        'status': selectedStatus,
        'rating': rating,
        'furnished': furnished,
        'image': selectedImage,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add property: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    propertyNameController.dispose();
    locationController.dispose();
    rentController.dispose();
    bedroomsController.dispose();
    bathroomsController.dispose();
    areaController.dispose();
    ratingController.dispose();

    super.dispose();
  }

  InputDecoration inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(
        icon,
        color: const Color(0xFF7354AD),
      ),
      filled: true,
      fillColor: const Color(0xFFF8F7FC),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Color(0xFF7354AD),
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: inputDecoration(label, icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add Property',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                'Property Information',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Add details about your property',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    buildTextField(
                      controller: propertyNameController,
                      label: 'Property Name',
                      icon: Icons.home_work_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter property name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    buildTextField(
                      controller: locationController,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    buildTextField(
                      controller: rentController,
                      label: 'Monthly Rent',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter monthly rent';
                        }

                        if (int.tryParse(
                              value.replaceAll(',', ''),
                            ) ==
                            null) {
                          return 'Enter valid rent';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [

                        Expanded(
                          child: buildTextField(
                            controller: bedroomsController,
                            label: 'Bedrooms',
                            icon: Icons.bed_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Required';
                              }

                              if (int.tryParse(value.trim()) == null) {
                                return 'Invalid';
                              }

                              return null;
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: buildTextField(
                            controller: bathroomsController,
                            label: 'Bathrooms',
                            icon: Icons.bathtub_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'Required';
                              }

                              if (int.tryParse(value.trim()) == null) {
                                return 'Invalid';
                              }

                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    buildTextField(
                      controller: areaController,
                      label: 'Area (sq.ft.)',
                      icon: Icons.square_foot,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter area';
                        }

                        if (int.tryParse(value.trim()) == null) {
                          return 'Enter valid area';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    buildTextField(
                      controller: ratingController,
                      label: 'Rating (0 - 5)',
                      icon: Icons.star_outline,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }

                        final rating =
                            double.tryParse(value.trim());

                        if (rating == null ||
                            rating < 0 ||
                            rating > 5) {
                          return 'Rating must be between 0 and 5';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              const Text(
                'Property Settings',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [

                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: inputDecoration(
                        'Status',
                        Icons.info_outline,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Active',
                          child: Text('Active'),
                        ),
                        DropdownMenuItem(
                          value: 'Pending',
                          child: Text('Pending'),
                        ),
                        DropdownMenuItem(
                          value: 'Rented',
                          child: Text('Rented'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedStatus = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedImage,
                      decoration: inputDecoration(
                        'Property Image',
                        Icons.image_outlined,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'property1',
                          child: Text('Property Image 1'),
                        ),
                        DropdownMenuItem(
                          value: 'property2',
                          child: Text('Property Image 2'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedImage = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 8),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Furnished',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        'Property is furnished',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      value: furnished,
                      activeThumbColor:
                          const Color(0xFF7354AD),
                      onChanged: (value) {
                        setState(() {
                          furnished = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading ? null : addProperty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7354AD),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Add Property',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}