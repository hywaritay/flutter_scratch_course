import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_scratch_course/core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class PredictionResult {
  final bool isFaulty;
  final String problem;
  final String solution;
  final double confidence;

  PredictionResult({
    required this.isFaulty,
    required this.problem,
    required this.solution,
    required this.confidence,
  });
}

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  PredictionResult? _predictionResult;
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
          _predictionResult = null; // Reset previous result
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI analysis delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock prediction logic based on image file name or random
    // In a real app, this would call an AI/ML service
    final result = _mockPrediction(_selectedImage!.name);

    setState(() {
      _predictionResult = result;
      _isAnalyzing = false;
    });
  }

  PredictionResult _mockPrediction(String imageName) {
    // Mock prediction based on filename or random
    // In reality, this would analyze the actual image
    final problems = [
      {
        'faulty': true,
        'problem': 'Screen Crack Detected',
        'solution':
            'Replace the screen panel. Contact authorized service center for professional repair.',
        'confidence': 0.92,
      },
      {
        'faulty': true,
        'problem': 'Battery Swelling',
        'solution':
            'Stop using immediately. Replace battery at authorized service center. Do not attempt to open device.',
        'confidence': 0.88,
      },
      {
        'faulty': true,
        'problem': 'Port Damage',
        'solution':
            'Clean the port gently with compressed air. If damaged, replace charging port assembly.',
        'confidence': 0.85,
      },
      {
        'faulty': false,
        'problem': 'No Issues Detected',
        'solution':
            'Device appears to be in good condition. Continue normal usage and maintenance.',
        'confidence': 0.95,
      },
      {
        'faulty': true,
        'problem': 'Overheating Components',
        'solution':
            'Clean internal fans and vents. Ensure proper ventilation. Update device firmware.',
        'confidence': 0.78,
      },
    ];

    // Simple mock logic - in real app, this would be AI analysis
    final randomIndex = imageName.hashCode % problems.length;
    final problem = problems[randomIndex];

    return PredictionResult(
      isFaulty: problem['faulty'] as bool,
      problem: problem['problem'] as String,
      solution: problem['solution'] as String,
      confidence: problem['confidence'] as double,
    );
  }

  void _reset() {
    setState(() {
      _selectedImage = null;
      _predictionResult = null;
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Prediction'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _reset,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            const Text(
              'AI Product Fault Detection',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Upload or take a photo of your product for instant fault analysis',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Image Selection Area
            if (_selectedImage == null) ...[
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No image selected',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Image Source Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Selected Image Display
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(_selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Analyze Button
              if (!_isAnalyzing)
                ElevatedButton.icon(
                  onPressed: _analyzeImage,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Analyze Product'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                )
              else
                const Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyzing image...'),
                  ],
                ),
            ],

            const SizedBox(height: 32),

            // Prediction Results
            if (_predictionResult != null) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _predictionResult!.isFaulty
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  border: Border.all(
                    color: _predictionResult!.isFaulty
                        ? Colors.red
                        : Colors.green,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _predictionResult!.isFaulty
                              ? Icons.error
                              : Icons.check_circle,
                          color: _predictionResult!.isFaulty
                              ? Colors.red
                              : Colors.green,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _predictionResult!.isFaulty
                                ? 'Fault Detected'
                                : 'No Faults Found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: _predictionResult!.isFaulty
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Confidence: ${(_predictionResult!.confidence * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Problem:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _predictionResult!.problem,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Recommended Solution:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _predictionResult!.solution,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton.icon(
                    onPressed: _reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Analysis'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Could navigate to service booking or contact support
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contacting support...')),
                      );
                    },
                    icon: const Icon(Icons.support_agent),
                    label: const Text('Get Help'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
