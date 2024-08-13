import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;

class BreakdownAssistancePage extends StatefulWidget {
  @override
  _BreakdownAssistancePageState createState() =>
      _BreakdownAssistancePageState();
}

class _BreakdownAssistancePageState extends State<BreakdownAssistancePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBrand;
  String? _selectedCarModel;
  String? _carSize;
  String? _manualCarBrand;
  String? _manualCarModel;
  File? _selectedImage;
  bool _isLoading = false;

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

  List<String> _availableModels = [];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        String imagePath = '';
        if (_selectedImage != null) {
          String fileName = path.basename(_selectedImage!.path);
          Reference storageReference = FirebaseStorage.instance
              .ref()
              .child('breakdown_images/$fileName');
          UploadTask uploadTask = storageReference.putFile(_selectedImage!);
          await uploadTask.whenComplete(() => null);
          imagePath = await storageReference.getDownloadURL();
        }

        await FirebaseFirestore.instance.collection('breakdown').add({
          'carBrand':
              _selectedBrand == 'Other' ? _manualCarBrand : _selectedBrand,
          'carModel': _selectedCarModel == 'Other'
              ? _manualCarModel
              : _selectedCarModel,
          'carSize': _carSize,
          'imagePath': imagePath,
          'timestamp': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tow truck requested successfully!')),
        );

        setState(() {
          _selectedBrand = null;
          _selectedCarModel = null;
          _manualCarBrand = null;
          _manualCarModel = null;
          _carSize = null;
          _selectedImage = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to request tow truck: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/c.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Car Brand',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
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
                                  _availableModels =
                                      _carModelsByBrand[newValue]!;
                                  _selectedCarModel = null;
                                  _manualCarBrand = null;
                                } else {
                                  _availableModels = [];
                                }
                                _manualCarModel = null;
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
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter Car Brand',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
                          SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Car Model',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
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
                                _manualCarModel = null;
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
                            SizedBox(height: 16),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Enter Car Model',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
