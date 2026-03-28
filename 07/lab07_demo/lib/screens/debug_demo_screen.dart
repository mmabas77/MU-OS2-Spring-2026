import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Lesson 32 debug demo — reproduces the "method called on null" crash
/// that was shown in the video.
///
/// The video showed:
///   1. App crashes with a red screen — "The method was called on null"
///   2. Developer reads the Run log, identifies the offending line
///   3. Sets a breakpoint on the `points` access line
///   4. Runs in Debug mode, inspects the Variables panel
///   5. Discovers `points` is null because the API JSON has no "points" key
///   6. Conclusion: the bug is in the API response, not the Dart code
///
/// This screen simulates that scenario with a toggle to switch between
/// "before fix" (null crash) and "after fix" (safe null-aware access).
class DebugDemoScreen extends StatefulWidget {
  const DebugDemoScreen({super.key});

  @override
  State<DebugDemoScreen> createState() => _DebugDemoScreenState();
}

class _DebugDemoScreenState extends State<DebugDemoScreen> {
  bool _showFixed = false;

  // Simulates a JSON response from the API that does NOT contain "points".
  // This is the real-world scenario from Lesson 32: the backend developer
  // forgot to include the "points" field in the response.
  final Map<String, dynamic> _apiResponseWithoutPoints = {
    'email': 'user@example.com',
    // 'points' key is absent — this is the bug
  };

  // Fixed response — backend added the "points" field
  final Map<String, dynamic> _apiResponseWithPoints = {
    'email': 'user@example.com',
    'points': 120,
  };

  @override
  Widget build(BuildContext context) {
    final json = _showFixed ? _apiResponseWithPoints : _apiResponseWithoutPoints;
    final user = UserModel.fromJson(json);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Demo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle to simulate before/after fix
            Row(
              children: [
                const Text('Simulate API fix (add points field):'),
                const SizedBox(width: 10),
                Switch(
                  value: _showFixed,
                  onChanged: (v) => setState(() => _showFixed = v),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Show the simulated API JSON
            Text(
              'API JSON response:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                json.toString(),
                style: const TextStyle(fontFamily: 'monospace'),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              'Parsed user:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text('Email: ${user.email}'),
            const SizedBox(height: 4),

            // Safe null-aware access — matches the fix from Lesson 32
            // BEFORE fix: trying to use user.points directly would crash
            //   (e.g. int rank = user.points! would throw)
            // AFTER fix: use null-aware operator ?? to provide a default
            Text(
              'Points: ${user.points ?? 'null — field missing in API response'}',
              style: TextStyle(
                color: user.points == null ? Colors.red[700] : Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 24),
            if (user.points == null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bug identified (Lesson 32 scenario):',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'user.points is null because the API JSON does not contain '
                      'the "points" key.\n\n'
                      'Debugging steps from the video:\n'
                      '1. Read the Run log — identify the null crash line\n'
                      '2. Set a breakpoint on the points access\n'
                      '3. Run in Debug mode — inspect Variables panel\n'
                      '4. Evaluate response.data — "points" key is absent\n'
                      '5. Root cause: API bug, not Dart code\n'
                      '6. Contact the backend developer to add "points" to the response',
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: const Text(
                  'Fixed: API now returns "points" in the response. '
                  'The app reads the value correctly.',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
