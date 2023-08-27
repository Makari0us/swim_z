import 'package:flutter/material.dart';

enum Gender { Male, Female }

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  double? bmi;
  double? weight;
  double? height;
  int? age;
  Gender? gender;

  TextEditingController carbohydratesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController sugarController = TextEditingController();
  TextEditingController vegetablesController = TextEditingController();
  TextEditingController fruitsController = TextEditingController();

  // ... Calculate BMI, BMR, TDEE methods

  void calculateNutrition() {
    if (bmi != null && weight != null && height != null && age != null && gender != null) {
      setState(() {
        // Calculate nutrient advice based on user input and BMI
        String sugarAdvice = getSugarAdvice();
        String vegetablesAdvice = getVegetablesAdvice();
        String fruitsAdvice = getFruitsAdvice();
        // ... Repeat for other nutrients
      });
    } else {
      _showValidationErrorDialog();
    }
  }

  String getCarbohydratesAdvice() {
    if (bmi != null && weight != null && height != null && age != null && gender != null) {
      double carbsNeeded = 0.0; // Calculate based on user info, BMI, and activity level
      double carbsIntake = double.parse(carbohydratesController.text);
      
      if (carbsIntake < carbsNeeded * 0.8) {
        return 'Consider increasing your carbohydrate intake for energy.';
      } else if (carbsIntake > carbsNeeded * 1.2) {
        return 'Your carbohydrate intake seems high. Adjust based on your activity level.';
      } else {
        return 'Your carbohydrate intake is balanced for your needs.';
      }
    } else {
      return 'Please fill in all required information to get personalized advice.';
    }
  }

  String getProteinAdvice() {
  if (bmi != null && weight != null && height != null && age != null) {
    double proteinNeeded = 0.0; // Calculate based on user info, BMI, and activity level
    double proteinIntake = double.parse(proteinController.text);

    if (proteinIntake < proteinNeeded * 0.8) {
      return 'Consider increasing your protein intake to support your body\'s needs.';
    } else if (proteinIntake > proteinNeeded * 1.2) {
      return 'Your protein intake seems high. Adjust based on your activity level.';
    } else {
      return 'Your protein intake is balanced for your needs.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getSugarAdvice() {
  if (bmi != null && weight != null && height != null && age != null && gender != null) {
    double sugarIntake = double.parse(sugarController.text);

    if (sugarIntake > 50) {
      return 'Limit your sugar intake for better health.';
    } else {
      return 'Your sugar intake is within recommended limits.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getVegetablesAdvice() {
  if (bmi != null && weight != null && height != null && age != null && gender != null) {
    double vegetablesIntake = double.parse(vegetablesController.text);

    if (vegetablesIntake < 200) {
      return 'Increase your vegetable intake for a more balanced diet.';
    } else {
      return 'Your vegetable intake is good for your health.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}

String getFruitsAdvice() {
  if (bmi != null && weight != null && height != null && age != null && gender != null) {
    double fruitsIntake = double.parse(fruitsController.text);

    if (fruitsIntake < 150) {
      return 'Include more fruits in your diet for essential vitamins.';
    } else {
      return 'Your fruit intake is contributing to a healthy diet.';
    }
  } else {
    return 'Please fill in all required information to get personalized advice.';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Advisor'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ... Input fields for user information (BMI, weight, height, age, gender)
                DropdownButtonFormField<Gender>(
                  value: gender,
                  items: Gender.values.map((Gender value) {
                    return DropdownMenuItem<Gender>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (Gender? newValue) {
                    setState(() {
                      gender = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                // ... Repeat for other user inputs

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

                // Add ListTile widgets for sugar, vegetables, and fruits
                _buildNutrientInfoTile(
                  title: 'Sugar',
                  value: sugarController.text,
                  advice: getSugarAdvice(),
                ),
                _buildNutrientInfoTile(
                  title: 'Vegetables',
                  value: vegetablesController.text,
                  advice: getVegetablesAdvice(),
                ),
                _buildNutrientInfoTile(
                  title: 'Fruits',
                  value: fruitsController.text,
                  advice: getFruitsAdvice(),
                ),
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
}

void main() {
  runApp(MaterialApp(home: NutritionPage()));
}
