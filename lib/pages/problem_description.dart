import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProblemDescriptionFormPage extends StatefulWidget {
  @override
  _ProblemDescriptionFormState createState() => _ProblemDescriptionFormState();
}

class _ProblemDescriptionFormState extends State<ProblemDescriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _problemController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _problemController.dispose();
    _carModelController.dispose();
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
      final ref = FirebaseStorage.instance
          .ref()
          .child('problem_images')
          .child(DateTime.now().toIso8601String() + '.jpg');
      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask;
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
      final carModel = _carModelController.text;
      final contactNumber = _contactNumberController.text;

      String? imageUrl;
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      User? currentUser = FirebaseAuth.instance.currentUser;
      String? username = currentUser?.displayName ?? 'Anonymous';

      await FirebaseFirestore.instance.collection('problems').add({
        'problemDescription': problemDescription,
        'carModel': carModel,
        'contactNumber': contactNumber,
        'imagePath': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'username': username,
      });

      _problemController.clear();
      _carModelController.clear();
      _contactNumberController.clear();
      setState(() {
        _selectedImage = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Problem submitted successfully!')),
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
        actions: [],
      ),
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Describe Your Car Problem To locate suitable meachanic',
                    style: customTextStyle),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _problemController,
                  decoration: InputDecoration(
                    labelText: 'Problem Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                TextFormField(
                  controller: _carModelController,
                  decoration: InputDecoration(
                    labelText: 'Car Model',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the model of your car';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 13),
                TextFormField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
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
                            border:
                                Border.all(color: Colors.blueGrey, width: 2),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blueGrey[50],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image,
                                  size: 50, color: Colors.blueGrey),
                              const SizedBox(height: 10),
                              Text('Upload Picture',
                                  style:
                                      TextStyle(color: Colors.blueGrey[800])),
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
                            child: Text('Change Picture',
                                style: TextStyle(color: Colors.blueGrey[800])),
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
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text('Submit', style: TextStyle(fontSize: 16)),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
