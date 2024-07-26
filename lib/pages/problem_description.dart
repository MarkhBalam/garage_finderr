import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garage_finder/pages/map_pages.dart'; // Import your MapPage

class ProblemDescriptionFormPage extends StatefulWidget {
  @override
  _ProblemDescriptionFormState createState() => _ProblemDescriptionFormState();
}

class _ProblemDescriptionFormState extends State<ProblemDescriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  // Map of car brands and their models
  final Map<String, List<String>> _carModelsByBrand = {
    'Toyota': ['Camry', 'Corolla', 'Prius', 'RAV4', 'Highlander'],
    'Honda': ['Accord', 'Civic', 'CR-V', 'Pilot', 'Fit'],
    'Ford': ['F-150', 'Mustang', 'Explorer', 'Fusion', 'Escape'],
    'Chevrolet': ['Silverado', 'Malibu', 'Equinox', 'Tahoe', 'Impala'],
    'Nissan': ['Altima', 'Sentra', 'Rogue', 'Pathfinder', 'Maxima'],
    'Hyundai': ['Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Kona'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', '7 Series'],
    'Mercedes-Benz': ['C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE'],
    'Audi': ['A4', 'A6', 'Q5', 'Q7', 'A3'],
    'Volkswagen': ['Jetta', 'Passat', 'Golf', 'Tiguan', 'Atlas'],
    'Subaru': ['Outback', 'Forester', 'Impreza', 'Crosstrek', 'Legacy'],
    'Mazda': ['Mazda3', 'Mazda6', 'CX-5', 'CX-9', 'MX-5 Miata'],
    'Kia': ['Optima', 'Soul', 'Sorento', 'Sportage', 'Forte'],
    'Tesla': ['Model S', 'Model 3', 'Model X', 'Model Y'],
  };

  String? _selectedBrand;
  String? _selectedCarModel;
  String? _manualCarBrand;
  String? _manualCarModel;
  List<String> _availableModels = [];

  @override
  void dispose() {
    _problemController.dispose();
    _contactNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final startTime = DateTime.now();
      final ref = FirebaseStorage.instance
          .ref()
          .child('problem_images')
          .child(DateTime.now().toIso8601String() + '.jpg');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask;
      final endTime = DateTime.now();
      print(
          'Image upload time: ${endTime.difference(startTime).inSeconds} seconds');
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final problemDescription = _problemController.text;
      final carBrand = _selectedBrand ?? _manualCarBrand ?? '';
      final carModel = _selectedCarModel ?? _manualCarModel ?? '';
      final contactNumber = _contactNumberController.text;

      String? imageUrl;
      final imageStartTime = DateTime.now();
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }
      final imageEndTime = DateTime.now();
      print(
          'Total image upload time: ${imageEndTime.difference(imageStartTime).inSeconds} seconds');

      final firestoreStartTime = DateTime.now();
      User? currentUser = FirebaseAuth.instance.currentUser;
      String? username = currentUser?.displayName ?? 'Anonymous';

      await FirebaseFirestore.instance.collection('problems').add({
        'problemDescription': problemDescription,
        'carBrand': carBrand, // Save car brand
        'carModel': carModel, // Save car model
        'contactNumber': contactNumber,
        'imagePath': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
      });
      final firestoreEndTime = DateTime.now();
      print(
          'Firestore write time: ${firestoreEndTime.difference(firestoreStartTime).inSeconds} seconds');

      _problemController.clear();
      _contactNumberController.clear();
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Problem submitted successfully!')),
      );

      // Navigate to MapPage after successful submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MapPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customTextStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey[800],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Problem Description Form'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/images/c.jpg'), // Path to your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Form content
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 8,
              margin: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Describe Your Car Problem To Locate Suitable Mechanic',
                          style: customTextStyle,
                        ),
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _problemController,
                          decoration: InputDecoration(
                            labelText: 'Problem Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                          ),
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description of your problem';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 13),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Car Brand',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                          ),
                          value: _selectedBrand,
                          items: _carModelsByBrand.keys.map((brand) {
                            return DropdownMenuItem<String>(
                              value: brand,
                              child: Text(brand),
                            );
                          }).toList()
                            ..add(DropdownMenuItem<String>(
                              value: 'Other',
                              child: Text('Other'),
                            )),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedBrand = newValue;
                              if (newValue != 'Other') {
                                _availableModels = _carModelsByBrand[newValue]!;
                                _selectedCarModel = null;
                              } else {
                                _availableModels = [];
                              }
                              _manualCarBrand = null; // Reset manual input
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your car brand';
                            }
                            return null;
                          },
                        ),
                        if (_selectedBrand == 'Other') ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Enter Car Brand',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              _manualCarBrand = value;
                            },
                            validator: (value) {
                              if (_selectedBrand == 'Other' &&
                                  (value == null || value.isEmpty)) {
                                return 'Please enter your car brand';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 13),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Car Model',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                          ),
                          value: _selectedCarModel,
                          items: _availableModels.map((model) {
                            return DropdownMenuItem<String>(
                              value: model,
                              child: Text(model),
                            );
                          }).toList()
                            ..add(DropdownMenuItem<String>(
                              value: 'Other',
                              child: Text('Other'),
                            )),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCarModel = newValue;
                              if (newValue != 'Other') {
                                _manualCarModel = null; // Reset manual input
                              }
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your car model';
                            }
                            return null;
                          },
                        ),
                        if (_selectedCarModel == 'Other') ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Enter Car Model',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            onChanged: (value) {
                              _manualCarModel = value;
                            },
                            validator: (value) {
                              if (_selectedCarModel == 'Other' &&
                                  (value == null || value.isEmpty)) {
                                return 'Please enter your car model';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 13),
                        TextFormField(
                          controller: _contactNumberController,
                          decoration: InputDecoration(
                            labelText: 'Contact Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.blueGrey[50],
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your contact number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _selectedImage == null
                            ? GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.blueGrey,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.blueGrey[50],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Upload Picture',
                                        style: TextStyle(
                                          color: Colors.blueGrey[800],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      _selectedImage!,
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _pickImage,
                                    child: Text(
                                      'Change Picture',
                                      style: TextStyle(
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                ),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
