import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  // TODO: Add real API Key or simulating for now
  static const String _apiKey = 'YOUR_API_KEY';

  Future<List<String>> breakdownTask(String task) async {
    // Simulation for demonstration purposes
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, we would call Gemini API here
    /*
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final content = [Content.text('Break down this task into 3-5 smaller actionable subtasks: $task')];
    final response = await model.generateContent(content);
    return response.text?.split('\n') ?? [];
    */

    return [
      'Research $task',
      'Outline methodology for $task',
      'Draft initial version of $task',
      'Review and refine $task',
    ];
  }
}
