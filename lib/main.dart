import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const SalaryPredictorApp());

class SalaryPredictorApp extends StatelessWidget {
  const SalaryPredictorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      home: const WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://media.istockphoto.com/id/1830126474/photo/portrait-of-a-business-man-sitting-in-an-office.jpg?b=1&s=612x612&w=0&k=20&c=n1T_DyOqWIG7aTwPkjy5mP0kabIN-YaZsuJV5GniyPM=',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.attach_money, size: 100, color: Colors.teal[600]),
                  const SizedBox(height: 20),
                  const Text(
                    'Discover Your Potential Income',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Estimate your salary based on experience, employment type, and remote work ratio.\n\nMake smarter, data-driven career decisions!',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SalaryFormPage()),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SalaryFormPage extends StatefulWidget {
  const SalaryFormPage({super.key});

  @override
  State<SalaryFormPage> createState() => _SalaryFormPageState();
}

class _SalaryFormPageState extends State<SalaryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String experience = '';
  String employment = '';
  String companySize = '';
  String remoteRatio = '';
  String prediction = '';
  bool isLoading = false;

  Future<void> predictSalary() async {
    final url = Uri.parse('http://127.0.0.1:8000/predict');
    final body = json.encode({
      'experience_level': experience,
      'employment_type': employment,
      'company_size': companySize,
      'remote_ratio': int.tryParse(remoteRatio) ?? 0,
    });

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          prediction = "💰 Estimated Salary: \$${data['predicted_salary']}";
        });
      } else {
        setState(() {
          prediction = '❌ Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        prediction = '❌ Error: $e';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Prediction'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          Image.network(
            'https://media.istockphoto.com/id/1450969748/photo/developer-working-with-new-program.jpg?b=1&s=612x612&w=0&k=20&c=f1VAreml69K5fMxbwN8IoYed7x0bnF_zCJCnmHtPf84=',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.white.withOpacity(0.8)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Text(
                        'Fill in your job details:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Experience Level (EN, MI, SE, EX)',
                        ),
                        onChanged: (val) => experience = val.toUpperCase(),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Employment Type (FT, PT, FL, CT)',
                        ),
                        onChanged: (val) => employment = val.toUpperCase(),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Company Size (S, M, L)',
                        ),
                        onChanged: (val) => companySize = val.toUpperCase(),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Remote Ratio (0 to 100)',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) => remoteRatio = val,
                      ),
                      const SizedBox(height: 25),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.analytics),
                        onPressed: isLoading ? null : predictSalary,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        label: isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : const Text(
                          'Predict Salary',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 25),
                      if (prediction.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.teal, width: 1.5),
                          ),
                          child: Text(
                            prediction,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
