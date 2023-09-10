import 'package:flutter/material.dart';

enum Gender { Male, Female }

class NutritionPage extends StatefulWidget {
  @override
  _NutritionPageState createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  double? bmi = 0;
  double? weight;
  double? height;
  int? age;
  Gender? gender;
  double? carbohydrates = 0;
  double? protein = 0;

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  TextEditingController carbohydratesController = TextEditingController();
  TextEditingController proteinController = TextEditingController();
  TextEditingController fatController = TextEditingController();

  String carbohydratesAdvice =
      'Please fill in all required information to get personalized advice.';
  String proteinAdvice =
      'Please fill in all required information to get personalized advice.';
  // String fatAdvice = '';

  void calculateBMI() {
    if (weight != null && height != null) {
      double heightInMeters = height! / 100;
      double bmiValue = weight! / (heightInMeters * heightInMeters);
      setState(() {
        bmi = bmiValue;
      });
    }
  }

  void calculateNutrition() {
    if (weight != null &&
        height != null &&
        age != null &&
        gender != null &&
        (carbohydrates != null && carbohydrates != 0) &&
        (protein != null && protein != 0)) {
      calculateBMI();
      setState(() {
        carbohydratesAdvice = getCarbohydratesAdvice();
        proteinAdvice = getProteinAdvice();
        // fatAdvice = getFatAdvice();

        // _showNutrientAdviceDialog('Carbohydrates Advice', carbohydratesAdvice);
        // _showNutrientAdviceDialog('Protein Advice', proteinAdvice);
        // _showNutrientAdviceDialog('Fat Advice', fatAdvice);
      });
    } else {
      _showValidationErrorDialog();
    }
  }

  // void _showNutrientAdviceDialog(String nutrient, String advice) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('$nutrient'),
  //       content: Text('$advice'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //           child: Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  double calculateBMR() {
    if (weight != null && height != null && age != null && gender != null) {
      if (gender == Gender.Male) {
        return 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        return 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }
    } else {
      return 0.0;
    }
  }

  String getCarbohydratesAdvice() {
    if (bmi != null &&
        weight != null &&
        height != null &&
        age != null &&
        gender != null) {
      double bmr;
      if (gender == Gender.Male) {
        bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }

      double tdee = bmr;
      double carbsNeeded = (tdee * 0.6) / 4.0;

      double carbsIntake = carbohydrates ?? 0.0;

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
    if ((bmi != null && bmi != 0) &&
        weight != null &&
        height != null &&
        age != null) {
      double bmr;
      if (gender == Gender.Male) {
        bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }

      double tdee = bmr;
      double proteinNeeded = (tdee * 0.15) / 4.0;

      double proteinIntake = protein ?? 0.0;

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

  String getBMIAdvice() {
    if (bmi != null && bmi != 0) {
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

  // String getFatAdvice() {
  //   if (bmi != null && weight != null && height != null && age != null) {
  //     double bmr = calculateBMR();

  //     double fatNeeded = (bmr * 0.25) / 9.0;

  //     double fatIntake = double.tryParse(fatController.text) ?? 0.0;

  //     if (fatIntake < fatNeeded * 0.8) {
  //       return 'Consider increasing your healthy fat intake for overall health.';
  //     } else if (fatIntake > fatNeeded * 1.2) {
  //       return 'Your fat intake seems high. Focus on moderation for a balanced diet.';
  //     } else {
  //       if (bmi! < 18.5) {
  //         return 'Your fat intake is balanced, but ensure you are meeting nutrient needs for your weight.';
  //       } else if (bmi! < 24.9) {
  //         return 'Your fat intake is appropriate for your weight and activity level.';
  //       } else if (bmi! < 29.9) {
  //         return 'Your fat intake is balanced. Focus on maintaining your weight with a balanced diet.';
  //       } else {
  //         return 'Your fat intake is balanced, but consider consulting a healthcare professional for weight management advice.';
  //       }
  //     }
  //   } else {
  //     return 'Please fill in all required information to get personalized advice.';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Nutrition Advisor',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[600],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
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
                    decoration: InputDecoration(
                      hintText: 'Gender',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.bar_chart,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        weight = double.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: heightController,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.height,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        height = double.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                      labelText: 'Age (y)',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.cake,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        age = int.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: carbohydratesController,
                    decoration: InputDecoration(
                      labelText: 'Carbohydrates (g)',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.agriculture,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        carbohydrates = double.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: proteinController,
                    decoration: InputDecoration(
                      labelText: 'Protein (g)',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          color: Colors.blue[800]!,
                          width: 3.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.fastfood_sharp,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        protein = double.tryParse(value);
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: calculateNutrition,
                      child: Text(
                        'Calculate Nutrition',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.blue.shade800,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        ListTile(
                          title: Text(
                            'Carbohydrates',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Intake: ${carbohydrates} grams',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(carbohydratesAdvice),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ListTile(
                          title: Text(
                            'Protein',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Intake: ${protein} grams',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(proteinAdvice),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        ListTile(
                          title: Text(
                            'BMI',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Value: ${bmi!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(getBMIAdvice()),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
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
