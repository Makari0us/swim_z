import 'package:flutter/material.dart';

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  double? bmi;
  double? weight;
  double? height;
  int? age;

  TextEditingController carbohydratesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController sugarController = TextEditingController();
  TextEditingController vegetablesController = TextEditingController();
  TextEditingController fruitsController = TextEditingController();

  // ... Calculate BMI, BMR, TDEE methods

  void calculateNutrition() {
    if (bmi != null && weight != null && height != null && age != null) {
      setState(() {
        // Calculate nutrient advice based on user input and BMI
      });
    } else {
      _showValidationErrorDialog();
    }
  }

  void _showValidationErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Please enter all the required information.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String getCarbohydratesAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    if (bmi! < 18.5) {
      return 'You might need to increase your carbohydrate intake for energy.';
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return 'Your carbohydrate intake seems balanced for your BMI.';
    } else {
      return 'Consider moderating your carbohydrate intake for optimal health.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getProteinAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    if (bmi! < 18.5) {
      return 'Increasing protein intake can help with muscle growth and recovery.';
    } else if (bmi! >= 18.5 && bmi! < 25) {
      return 'Your protein intake seems balanced for your BMI.';
    } else {
      return 'Maintaining a balanced protein intake supports overall health.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getSugarAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    // Implement sugar advice calculation logic
    // Example logic: Adjust advice based on user's health and nutritional needs
    return '';
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getVegetablesAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    // Implement vegetables advice calculation logic
    // Example logic: Adjust advice based on user's health and nutritional needs
    return '';
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getFruitsAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    // Implement fruits advice calculation logic
    // Example logic: Adjust advice based on user's health and nutritional needs
    return '';
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swimmer Nutrition Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... Input fields for user information (BMI, weight, height, age)
                // Implement your widgets for BMI, weight, height, and age input here

                // Nutrient intake input fields
                _buildNutrientInputField(
                  controller: carbohydratesController,
                  label: 'Carbohydrates Intake (grams)',
                ),
                _buildNutrientInputField(
                  controller: proteinController,
                  label: 'Protein Intake (grams)',
                ),
                // ... Repeat for other nutrients

                ElevatedButton(
                  onPressed: calculateNutrition,
                  child: Text('Calculate Nutrition'),
                ),

                // Nutrient information and advice
                _buildNutrientInfoTile(
                  title: 'Carbohydrates',
                  value: carbohydratesController.text,
                  advice: getCarbohydratesAdvice(),
                ),
                _buildNutrientInfoTile(
                  title: 'Protein',
                  value: proteinController.text,
                  advice: getProteinAdvice(),
                ),
                // ... Repeat for other nutrients
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInputField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildNutrientInfoTile({
    required String title,
    required String value,
    required String advice,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Intake: $value grams'),
          SizedBox(height: 8),
          Text(advice),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: NutritionPage()));
}
