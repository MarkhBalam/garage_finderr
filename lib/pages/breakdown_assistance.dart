import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BreakdownAssistancePage extends StatefulWidget {
  @override
  _BreakdownAssistancePageState createState() =>
      _BreakdownAssistancePageState();
}

class _BreakdownAssistancePageState extends State<BreakdownAssistancePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _carModelController = TextEditingController();
  String? _carSize;
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _carModelController.dispose();
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

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Simulate a network request or data submission
      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        // Show a success message or navigate to another page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tow truck requested successfully!')),
        );

        // Clear the form fields
        _carModelController.clear();
        setState(() {
          _carSize = null;
          _selectedImage = null;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakdown Assistance'),
        backgroundColor: Colors.blue,
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
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Fill form to Request a Tow Truck',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey[800])),
                          SizedBox(height: 16),
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
                                return 'Please enter your car model';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Car Size',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.blueGrey[50],
                            ),
                            value: _carSize,
                            items: ['Big', 'Small']
                                .map((size) => DropdownMenuItem(
                                      value: size,
                                      child: Text(size),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _carSize = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please choose the size of your car';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          _selectedImage == null
                              ? GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueGrey, width: 2),
                                      borderRadius: BorderRadius.circular(12),
                                      color: Colors.blueGrey[50],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image,
                                            size: 50, color: Colors.blueGrey),
                                        const SizedBox(height: 10),
                                        Text('Upload Picture',
                                            style: TextStyle(
                                                color: Colors.blueGrey[800])),
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
                                          style: TextStyle(
                                              color: Colors.blueGrey[800])),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 20),
                          _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                  ),
                                  child: Text('Request Tow Truck',
                                      style: TextStyle(fontSize: 16)),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
