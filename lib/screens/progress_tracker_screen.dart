import 'package:communication_recovery_toolkit/widgets/confidence_bar_chart.dart';
import 'package:communication_recovery_toolkit/models/progress_data.dart';
import 'package:communication_recovery_toolkit/providers/progress_provider.dart';
import 'package:communication_recovery_toolkit/widgets/goal_setting_dialog.dart';
import 'package:communication_recovery_toolkit/widgets/progress_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_theme.dart';

class ProgressTrackerScreen extends StatefulWidget {
  const ProgressTrackerScreen({super.key});

  @override
  State<ProgressTrackerScreen> createState() => _ProgressTrackerScreenState();
}

class _ProgressTrackerScreenState extends State<ProgressTrackerScreen> {
  double _confidenceLevel = 5;
  final Map<String, bool> _challenges = {
    'Speaking clearly': false,
    'Finding words': false,
    'Writing': false,
    'Understanding others': false,
    'Memory': false,
  };
  String? _selectedMood;
  final _goalController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Progress Tracker',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDailyCheckIn(),
            const SizedBox(height: 24),
            _buildProgressVisualization(),
            const SizedBox(height: 24),
            _buildGoalSetting(),
            const SizedBox(height: 24),
            _buildHistoryView(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckIn() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Check-in',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          _buildMoodSelector(),
          const SizedBox(height: 20),
          _buildConfidenceSlider(),
          const SizedBox(height: 20),
          _buildChallengesCheckboxes(),
          const SizedBox(height: 20),
          _buildTextField('Goal for today', _goalController),
          const SizedBox(height: 20),
          _buildTextField('Notes', _notesController),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saveProgress,
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  void _saveProgress() {
    if (_selectedMood == null) return;
    final data = ProgressData()
      ..date = DateTime.now()
      ..mood = _selectedMood!
      ..confidence = _confidenceLevel
      ..challenges = _challenges.entries.where((e) => e.value).map((e) => e.key).toList()
      ..goal = _goalController.text.trim()
      ..notes = _notesController.text.trim();
    context.read<ProgressProvider>().addProgress(data);
    _goalController.clear();
    _notesController.clear();
    setState(() {
      _selectedMood = null;
      _confidenceLevel = 5;
      for (final k in _challenges.keys) {
        _challenges[k] = false;
      }
    });
  }

  Widget _buildMoodSelector() {
    final moods = ['😊 Happy', '😐 Okay', '😟 Concerned', '😞 Sad'];
    return Wrap(
      spacing: 8,
      children: moods.map((m) {
        final selected = m == _selectedMood;
        return ChoiceChip(
          label: Text(m),
          selected: selected,
          onSelected: (_) => setState(() => _selectedMood = m),
        );
      }).toList(),
    );
  }

  Widget _buildConfidenceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Confidence: ${_confidenceLevel.toStringAsFixed(0)} / 10'),
        Slider(
          min: 0,
          max: 10,
          divisions: 10,
          value: _confidenceLevel,
          onChanged: (v) => setState(() => _confidenceLevel = v),
        ),
      ],
    );
  }

  Widget _buildChallengesCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Challenges", style: Theme.of(context).textTheme.titleMedium),
        ..._challenges.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _challenges[key],
            onChanged: (bool? value) {
              setState(() {
                _challenges[key] = value ?? false;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildProgressVisualization() {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [AppTheme.cardShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progress Visualization',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ConfidenceBarChart(progressData: progressProvider.progressData),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: ProgressChart(progressData: progressProvider.progressData),
              ),
              const SizedBox(height: 20),
              _buildStreakAndBadges(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreakAndBadges() {
    return Row(
      children: const [
        Icon(Icons.emoji_events, color: Colors.amber),
        SizedBox(width: 8),
        Text('Streak: 3 days • Badges: 2'),
      ],
    );
  }

  Widget _buildGoalSetting() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Goal Setting', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (_) => const GoalSettingDialog(),
              );
              // Optionally store result
            },
            child: const Text('Set Weekly Goals'),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [AppTheme.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('History', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
          ),
        ],
      ),
    );
  }
}
