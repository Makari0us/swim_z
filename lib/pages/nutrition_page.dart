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

  void calculateNutrition() {
    if (bmi != null &&
        weight != null &&
        height != null &&
        age != null &&
        gender != null) {
      setState(() {
        String carbohydratesAdvice = getCarbohydratesAdvice();
        String proteinAdvice = getProteinAdvice();
        String fatAdvice = getFatAdvice();

        _showNutrientAdviceDialog('Carbohydrates Advice', carbohydratesAdvice);
        _showNutrientAdviceDialog('Protein Advice', proteinAdvice);
        _showNutrientAdviceDialog('Fat Advice', fatAdvice);
      });
    } else {
      _showValidationErrorDialog();
    }
  }

  void _showNutrientAdviceDialog(String nutrient, String advice) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$nutrient'),
        content: Text('$advice'),
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

  void calculateBMI() {
    if (weight != null && height != null) {
      double heightInMeters = height! / 100; // Convert height to meters
      double bmiValue = weight! / (heightInMeters * heightInMeters);
      setState(() {
        bmi = bmiValue;
      });
    }
  }

  String getBMIAdvice() {
    if (bmi != null) {
      if (bmi! < 18.5) {
        return 'You are underweight. Consider increasing your nutrient intake.';
      } else if (bmi! < 24.9) {
        return 'Your weight is within the normal range. Maintain a balanced diet.';
      } else if (bmi! < 29.9) {
        return 'You are overweight. Focus on portion control and regular exercise.';
      } else {
        return 'You are in the obese range. Consult a healthcare professional for advice.';
      }
    } else {
      return 'Please enter weight and height to calculate BMI.';
    }
  }

  double calculateBMR() {
    if (weight != null && height != null && age != null && gender != null) {
      if (gender == Gender.Male) {
        return 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        return 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }
    } else {
      return 0.0; // Default BMR value if inputs are missing
    }
  }

  String getCarbohydratesAdvice() {
    if (bmi != null &&
        weight != null &&
        height != null &&
        age != null &&
        gender != null) {
      double bmr; // Basal Metabolic Rate - calories needed at rest
      if (gender == Gender.Male) {
        bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }

      double tdee = bmr;
      double carbsNeeded = (tdee * 0.6) / 4.0;

      double carbsIntake = double.tryParse(carbohydratesController.text) ?? 0.0;

      if (carbsIntake < carbsNeeded * 0.8) {
        return 'Consider increasing your carbohydrate intake for energy.';
      } else if (carbsIntake > carbsNeeded * 1.2) {
        return 'Your carbohydrate intake seems high. Adjust based on your activity level.';
      } else {
        if (bmi! < 18.5) {
          return 'Your carbohydrate intake is appropriate for energy, but ensure you are getting enough nutrients to support your weight.';
        } else if (bmi! < 24.9) {
          return 'Your carbohydrate intake is balanced for your weight and energy needs.';
        } else if (bmi! < 29.9) {
          return 'Your carbohydrate intake is balanced. Focus on portion control and a balanced diet to maintain a healthy weight.';
        } else {
          return 'Your carbohydrate intake is balanced, but consider consulting a healthcare professional for weight management advice.';
        }
      }
    } else {
      return 'Please fill in all required information to get personalized advice.';
    }
  }

  String getProteinAdvice() {
    if (bmi != null && weight != null && height != null && age != null) {
      double bmr; // Basal Metabolic Rate - calories needed at rest
      if (gender == Gender.Male) {
        bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }

      double tdee = bmr;
      double proteinNeeded =
          (tdee * 0.15) / 4.0; // Assuming 15% of calories from protein

      double proteinIntake = double.tryParse(proteinController.text) ?? 0.0;

      if (proteinIntake < proteinNeeded * 0.8) {
        return 'Consider increasing your protein intake to support your body\'s needs.';
      } else if (proteinIntake > proteinNeeded * 1.2) {
        return 'Your protein intake seems high. Adjust based on your activity level.';
      } else {
        if (bmi! < 18.5) {
          return 'Your protein intake is balanced, but ensure you are meeting your nutrient needs for your weight.';
        } else if (bmi! < 24.9) {
          return 'Your protein intake is appropriate for your weight and activity level.';
        } else if (bmi! < 29.9) {
          return 'Your protein intake is balanced. Focus on maintaining your weight with a balanced diet.';
        } else {
          return 'Your protein intake is balanced, but consider consulting a healthcare professional for weight management advice.';
        }
      }
    } else {
      return 'Please fill in all required information to get personalized advice.';
    }
  }

  String getFatAdvice() {
    if (bmi != null && weight != null && height != null && age != null) {
      double bmr = calculateBMR(); // Basal Metabolic Rate
      // Calculate BMR based on gender, weight, height, and age

      double fatNeeded =
          (bmr * 0.25) / 9.0; // Assuming 25% of calories from fat

      TextEditingController fatController = TextEditingController();
      double fatIntake = double.tryParse(fatController.text) ?? 0.0;

      if (fatIntake < fatNeeded * 0.8) {
        return 'Consider increasing your healthy fat intake for overall health.';
      } else if (fatIntake > fatNeeded * 1.2) {
        return 'Your fat intake seems high. Focus on moderation for a balanced diet.';
      } else {
        if (bmi! < 18.5) {
          return 'Your fat intake is balanced, but ensure you are meeting nutrient needs for your weight.';
        } else if (bmi! < 24.9) {
          return 'Your fat intake is appropriate for your weight and activity level.';
        } else if (bmi! < 29.9) {
          return 'Your fat intake is balanced. Focus on maintaining your weight with a balanced diet.';
        } else {
          return 'Your fat intake is balanced, but consider consulting a healthcare professional for weight management advice.';
        }
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
                  advice: getFatAdvice(),
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
