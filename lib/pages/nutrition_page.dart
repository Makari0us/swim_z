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
  double? carbohydrates;
  double? protein;
  double? sugar;
  double? vegetables;
  double? fruits;

  void calculateNutrition() {
    if (bmi != null && weight != null && height != null && age != null) {
      double bmr;
      if (age! >= 18) {
        bmr = 88.362 + (13.397 * weight!) + (4.799 * height!) - (5.677 * age!);
      } else {
        bmr = 447.593 + (9.247 * weight!) + (3.098 * height!) - (4.330 * age!);
      }

      double tdee;
      if (bmi! < 18.5) {
        tdee = bmr * 1.6;
      } else if (bmi! >= 18.5 && bmi! < 25) {
        tdee = bmr * 1.8;
      } else {
        tdee = bmr * 2.0;
      }

      setState(() {
        carbohydrates = tdee * 0.55 / 4;
        protein = tdee * 0.15 / 4;
        sugar = tdee * 0.1 / 4;
        vegetables = tdee * 0.3;
        fruits = tdee * 0.15;
      });
    } else {
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

  String getCarbohydratesAdvice() {
    if (carbohydrates == null) {
      return '';
    }

    if (carbohydrates! < 50) {
      return 'You need to consume more carbohydrates for optimal energy.';
    } else if (carbohydrates! >= 50 && carbohydrates! <= 60) {
      return 'Your carbohydrate intake is adequate for optimal energy.';
    } else {
      return 'You have exceeded the recommended carbohydrate intake.';
    }
  }

  String getProteinAdvice() {
    if (protein == null) {
      return '';
    }

    if (protein! < 20) {
      return 'You need to consume more protein for muscle recovery and repair.';
    } else if (protein! >= 20 && protein! <= 30) {
      return 'Your protein intake is adequate for muscle recovery and repair.';
    } else {
      return 'You have exceeded the recommended protein intake.';
    }
  }

  String getSugarAdvice() {
    if (sugar == null) {
      return '';
    }

    if (sugar! < 10) {
      return 'Your sugar intake is within the recommended limit.';
    } else {
      return 'You have exceeded the recommended sugar intake.';
    }
  }

  String getVegetablesAdvice() {
    if (vegetables == null) {
      return '';
    }

    if (vegetables! < 300) {
      return 'You need to consume more vegetables for essential nutrients.';
    } else if (vegetables! >= 300 && vegetables! <= 500) {
      return 'Your vegetable intake is adequate for essential nutrients.';
    } else {
      return 'You have exceeded the recommended vegetable intake.';
    }
  }

  String getFruitsAdvice() {
    if (fruits == null) {
      return '';
    }

    if (fruits! < 150) {
      return 'You need to consume more fruits for essential nutrients.';
    } else if (fruits! >= 150 && fruits! <= 250) {
      return 'Your fruit intake is adequate for essential nutrients.';
    } else {
      return 'You have exceeded the recommended fruit intake.';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your details:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Body Mass Index (BMI)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    bmi = double.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    weight = double.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    height = double.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    age = int.tryParse(value);
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: calculateNutrition,
                child: Text('Calculate Nutrition'),
              ),
              SizedBox(height: 32),
              Text(
                'Nutrition Information:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Carbohydrates'),
                subtitle:
                    Text('${carbohydrates?.toStringAsFixed(2) ?? '-'} grams'),
              ),
              ListTile(
                title: Text('Protein'),
                subtitle: Text('${protein?.toStringAsFixed(2) ?? '-'} grams'),
              ),
              ListTile(
                title: Text('Sugar'),
                subtitle: Text('${sugar?.toStringAsFixed(2) ?? '-'} grams'),
              ),
              ListTile(
                title: Text('Vegetables'),
                subtitle:
                    Text('${vegetables?.toStringAsFixed(2) ?? '-'} grams'),
              ),
              ListTile(
                title: Text('Fruits'),
                subtitle: Text('${fruits?.toStringAsFixed(2) ?? '-'} grams'),
              ),
              SizedBox(height: 32),
              Text(
                'Nutrition Advice:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(getCarbohydratesAdvice()),
              Text(getProteinAdvice()),
              Text(getSugarAdvice()),
              Text(getVegetablesAdvice()),
              Text(getFruitsAdvice()),
            ],
          ),
        ),
      ),
    );
  }
}
