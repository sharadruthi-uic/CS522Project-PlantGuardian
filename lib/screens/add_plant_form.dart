import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/add_plant_service.dart';
import 'dart:io';


class AddPlantForm extends StatefulWidget {
  const AddPlantForm({super.key});

  @override
  _AddPlantFormState createState() => _AddPlantFormState();
}

class _AddPlantFormState extends State<AddPlantForm> {
  int _currentStep = 0;
  double sunlightValue = 1;
  File? _selectedPhoto; // Store the selected photo
  final ImagePicker _picker = ImagePicker();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  final TextEditingController _plantNameController = TextEditingController();
  final TextEditingController _plantTypeController = TextEditingController();
  final TextEditingController _specialCareController = TextEditingController();

  String waterRecommendation = '';
  String fertilizerRecommendation = '';

  @override
  void initState() {
    super.initState();

    // Listen for changes in plant type
    _plantTypeController.addListener(_updateRecommendations);
  }

  void _updateRecommendations() {
    setState(() {
      waterRecommendation = AddPlantService.getWaterRecommendation(_plantTypeController.text);
      fertilizerRecommendation = AddPlantService.getFertilizerRecommendation(_plantTypeController.text);
    });
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      if (arguments['familyName'] != null) {
        _plantTypeController.text = arguments['familyName']; // Pre-fill the type
      }
      if (arguments['imageFile'] != null) {
        _selectedPhoto = arguments['imageFile']; // Set the image file
      }
    }

    setState(() {
      waterRecommendation = AddPlantService.getWaterRecommendation(_plantTypeController.text);
      fertilizerRecommendation = AddPlantService.getFertilizerRecommendation(_plantTypeController.text);
    });
  }


  bool _hasValidationError = false;
  String? _reminderTimeError;
  String? _specialCareError;
  String? _dateError;
  String? _imageError;
  String? _plantNameError;
  String? _plantTypeError;




  bool _validateForm() {
    setState(() {
      _hasValidationError = false; // Reset errors before validation

      // Validate plant name
      if (_plantNameController.text.isEmpty) {
        _hasValidationError = true;
        _plantNameError = "Plant name is required.";
      } else {
        _plantNameError = null;
      }

      // Validate plant type
      if (_plantTypeController.text.isEmpty) {
        _hasValidationError = true;
        _plantTypeError = "Plant type is required.";
      } else {
        _plantTypeError = null;
      }

      // Validate reminder time
      if (_selectedTime == null) {
        _hasValidationError = true;
        _reminderTimeError = "Please select a reminder time.";
      } else {
        _reminderTimeError = null;
      }

      // Validate special care instructions
      if (_specialCareController.text.isEmpty) {
        _hasValidationError = true;
        _specialCareError = "Please provide special care instructions.";
      } else {
        _specialCareError = null;
      }

      // Validate date
      if (_selectedDate == null) {
        _hasValidationError = true;
        _dateError = "Please select a date.";
      } else {
        _dateError = null;
      }

      // Validate image upload
      if (_selectedPhoto == null) {
        _hasValidationError = true;
        _imageError = "Please upload an image of your plant.";
      } else {
        _imageError = null;
      }
    });

    return !_hasValidationError;
  }



  String formatTime(TimeOfDay time) {
    final int hours = time.hour;
    final int minutes = time.minute;
    final int seconds = 0; // Add seconds as 0 since TimeOfDay does not include seconds
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day-$month-$year';
  }



  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(),  // Latest selectable date
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _pickPhoto() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedPhoto = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedPhoto = File(pickedFile.path);
                    });
                  }
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            // Handle navigation to home
            Navigator.pushNamed(context, '/home');
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Text(
            "ADD NEW PLANT",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF409C6B),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFA9E6A2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (_currentStep < 3) _buildStepper(),
                  const SizedBox(height: 20),
                  Expanded(child: _buildStepContent()),
                  if (_currentStep < 3) _buildNextButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator("Plant Bio", _currentStep == 0, true),
        _buildStepIndicator("Care Preferences", _currentStep == 1, true),
        _buildStepIndicator("Additional Info.", _currentStep == 2, false),
      ],
    );
  }

  Widget _buildStepIndicator(String title, bool isActive, bool hasNextStep) {
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: isActive ? Colors.green : Colors.white,
              child: isActive
                  ? const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.white,
              )
                  : null,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
        if (hasNextStep)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            height: 2,
            width: 40,
            color: Colors.white,
          ),
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildPlantBio();
      case 1:
        return _buildCarePreferences();
      case 2:
        return _buildAdditionalInfo();
      case 3:
        return _buildSuccessScreen();
      default:
        return Container();
    }
  }

  Widget _buildPlantBio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Let's get to know your plant!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Provide some details about your plant to help us create a personalized care plan",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          "What's your plant's name?",
          "Desk Ivy, Succulent Betty...",
          _plantNameController,
          isRequired: true,
          errorText: _plantNameError,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          "What type of plant is it?",
          "Orchid",
          _plantTypeController,
          isRequired: true,
          errorText: _plantTypeError,
        ),        const SizedBox(height: 20),
        const Text(
          "Optional: Add a photo of your plant!",
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _pickPhoto, // Opens the image picker
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey),
                ),
                child: _selectedPhoto != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.file(
                    _selectedPhoto!,
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt, size: 30, color: Colors.grey),
                    Text(
                      "Click or upload a photo.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              if (_imageError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    _imageError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),


      ],
    );
  }

  Widget _buildCarePreferences() {
    double waterFrequencyValue = 2; // Default value for the slider (Weekly)
    double fertilizeFrequencyValue = 2; // Default value for the slider (Weekly)
    String waterFrequencyLabel = "Weekly"; // Default label
    String fertilizeFrequencyLabel = "Weekly"; // Default label

    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView( // Added to enable scrolling
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Set Your Plant's Care Preferences",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "We'll guide you with suggestions based on your plant type.",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),

              Slider(
                value: waterFrequencyValue,
                min: 0,
                max: 3,
                divisions: 3,
                label: waterFrequencyLabel,
                onChanged: (value) {
                  setState(() {
                    waterFrequencyValue = value;
                    waterFrequencyLabel = _getFrequencyLabel(value);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Daily"),
                  Text("Twice a week"),
                  Text("Weekly"),
                  Text("Bi-Weekly"),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  SizedBox(width: 5),
                  Text(
                    "What We Recommend",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                waterRecommendation.isNotEmpty
                    ? "Water Recommendation: $waterRecommendation"
                    : "Enter plant type to see water recommendations.",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                "How often will you fertilize your plant?",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Slider(
                value: fertilizeFrequencyValue,
                min: 0,
                max: 3,
                divisions: 3,
                label: fertilizeFrequencyLabel,
                onChanged: (value) {
                  setState(() {
                    fertilizeFrequencyValue = value;
                    fertilizeFrequencyLabel = _getFrequencyLabel(value);
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Daily"),
                  Text("Twice a week"),
                  Text("Weekly"),
                  Text("Bi-Weekly"),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  SizedBox(width: 5),
                  Text(
                    "What We Recommend",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  Spacer(),
                  Icon(Icons.chevron_right, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                fertilizerRecommendation.isNotEmpty
                    ? "Fertilizer Recommendation: $fertilizerRecommendation"
                    : "Enter plant type to see fertilizer recommendations.",
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                "When should we remind you?",
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectTime, // Opens the time picker
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : "Select Time",
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          const Icon(Icons.access_time, color: Colors.black),
                        ],
                      ),
                    ),
                    if (_reminderTimeError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          _reminderTimeError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getFrequencyLabel(double value) {
    switch (value.toInt()) {
      case 0:
        return "Daily";
      case 1:
        return "Twice a week";
      case 2:
        return "Weekly";
      case 3:
        return "Bi-Weekly";
      default:
        return "";
    }
  }


  Widget _buildAdditionalInfo() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Additional Details for Your Plant",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "How much sunlight does your plant get?",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Slider(
              value: sunlightValue,
              min: 0,
              max: 3,
              divisions: 3,
              label: _getSunlightLabel(sunlightValue),
              onChanged: (value) {
                setState(() {
                  sunlightValue = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Shade"),
                Text("Partial Shade"),
                Text("Bright Indirect"),
                Text("Full Sun"),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              "Any special care instructions?",
              "e.g., Prune leaves every month",
              _specialCareController,
              isRequired: true,
              errorText: _specialCareError,
            ),
            const SizedBox(height: 15),
            const Text(
              "When did you get your plant?",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _selectDate, // Opens the date picker
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black54),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                              : "Select Date",
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.black),
                      ],
                    ),
                  ),
                  if (_dateError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        _dateError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check_circle, size: 100, color: Colors.green),
          const SizedBox(height: 20),
          const Text(
            "Your plant has been successfully added!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "You can now view its profile to start managing its care and growth.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle navigation to plant profile
              Navigator.pushNamed(context, '/plants');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF409C6B),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Go to plant profile",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    String buttonText = ""; // Button label text
    Color backgroundColor = Colors.green; // Default background color
    Color textColor = Colors.white; // Default text color

    // Set button label and colors based on the current step
    switch (_currentStep) {
      case 0:
        buttonText = "Set Care Preference";
        backgroundColor = Colors.white;
        textColor = Colors.black;
        break;
      case 1:
        buttonText = "Give Additional Info";
        backgroundColor = Colors.white;
        textColor = Colors.black;
        break;
      case 2:
        buttonText = "All DoneSubmit";
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
      default:
        buttonText = "Next";
        backgroundColor = Colors.green;
        textColor = Colors.white;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0) // Show Back button only if it's not the first step
          TextButton(
            onPressed: () {
              setState(() {
                _currentStep--; // Go to the previous step
              });
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              foregroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text("Back"),
          ),
        ElevatedButton(
          onPressed: () async {
            if (_currentStep == 2) {
              if (_validateForm()) {
                // Show a loading dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Prepare form data
                final String name = _plantNameController.text;
                final String type = _plantTypeController.text;
                final String specialCare = _specialCareController.text;
                final String wateringSchedule = "Weekly"; // Example static value
                final String fertilizingSchedule = "Bi-Weekly"; // Example static value
                final String sunlightRequirement = sunlightValue.toString();
                final String purchaseDate = formatDate(_selectedDate!);
                final String reminderTime = formatTime(_selectedTime!);

                try {
                  // Call the service
                  final result = await AddPlantService.addPlant(
                    name: name,
                    type: type,
                    wateringSchedule: wateringSchedule,
                    fertilizingSchedule: fertilizingSchedule,
                    sunlightRequirement: sunlightRequirement,
                    specialCare: specialCare,
                    purchaseDate: purchaseDate,
                    reminderTime: reminderTime,
                    photo: _selectedPhoto!,
                  );

                  Navigator.pop(context); // Close loading dialog

                  if (result['success']) {
                    // Navigate to success screen
                    setState(() {
                      _currentStep = 3; // Show the success screen
                    });
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'])),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context); // Close loading dialog

                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('An error occurred: $e')),
                  );
                }
              } else {
                // Show validation error message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill out all required fields."),
                  ),
                );
              }
            } else {
              setState(() {
                _currentStep++;
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, // Dynamic background color
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: textColor), // Dynamic text color
          ),
        ),
      ],
    );
  }


  String _getSunlightLabel(double value) {
    switch (value.toInt()) {
      case 0:
        return "Shade";
      case 1:
        return "Partial Shade";
      case 2:
        return "Bright Indirect";
      case 3:
        return "Full Sun";
      default:
        return "";
    }
  }

  Widget _buildTextField(
      String label,
      String placeholder,
      TextEditingController controller, {
        bool isRequired = false,
        String? errorText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: placeholder,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }


}