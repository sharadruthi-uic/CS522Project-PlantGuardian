import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PlantIdentifyScreen extends StatefulWidget {
  @override
  _PlantIdentifyScreenState createState() => _PlantIdentifyScreenState();
}

class _PlantIdentifyScreenState extends State<PlantIdentifyScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _pickImage(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                      _result = null; // Clear previous results
                      _error = null;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                      _result = null; // Clear previous results
                      _error = null;
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _identifyPlant() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      // Construct API request
      final Uri url = Uri.parse(
          'https://my-api.plantnet.org/v2/identify/all?include-related-images=false&no-reject=false&nb-results=10&lang=en&api-key=2b10VD3NEPuZonc2iCpr4tYkOu');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('images', _selectedImage!.path));
      request.fields['organs'] = 'auto';

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        setState(() {
          _result = data;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _error = 'Species not found. Please try again.';
        });
      } else {
        setState(() {
          _error = 'Something went wrong. Please try again later.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identify Plant'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Picker Section
            GestureDetector(
              onTap: () => _pickImage(context),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _selectedImage != null
                    ? Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                )
                    : const Center(
                  child: Text(
                    'Tap to select an image',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _identifyPlant,
              icon: const Icon(Icons.search),
              label: const Text('Identify Plant'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
            ),
            const SizedBox(height: 20),

            // Loader Section
            if (_isLoading) const CircularProgressIndicator(),

            // Results Section
            if (_error != null)
              Text(
                _error!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              )
            else if (_result != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _result!['results'].length,
                  itemBuilder: (context, index) {
                    final species = _result!['results'][index]['species'];
                    final commonNames = species['commonNames'] as List<dynamic>? ?? [];
                    final genus = species['genus']['scientificNameWithoutAuthor'];
                    final family = species['family']['scientificNameWithoutAuthor'];
                    final scientificName = species['scientificName'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: const Icon(Icons.local_florist, color: Colors.green),
                        title: Text(scientificName ?? 'Unknown Species'),
                        subtitle: Text(
                          'Genus: $genus\nFamily: $family\nCommon Names: ${commonNames.join(', ')}',
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
