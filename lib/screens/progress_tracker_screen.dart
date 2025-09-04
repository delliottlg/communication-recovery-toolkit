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
          _buildTextField('Notes (optional)', _notesController),
          const SizedBox(height: 20),
          Center(
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
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final challenges = _challenges.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final progressData = ProgressData()
      ..date = DateTime.now()
      ..mood = _selectedMood ?? ''
      ..confidence = _confidenceLevel
      ..challenges = challenges
      ..goal = _goalController.text
      ..notes = _notesController.text;

    progressProvider.addProgress(progressData);

    // Clear the form
    setState(() {
      _selectedMood = null;
      _confidenceLevel = 5;
      _challenges.updateAll((key, value) => false);
      _goalController.clear();
      _notesController.clear();
    });
  }

  Widget _buildMoodSelector() {
    final moods = ['😊', '😄', '😐', '😕', '😢'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How are you feeling today?', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: moods.map((mood) {
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = mood),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _selectedMood == mood ? AppTheme.primaryColor.withOpacity(0.2) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  mood,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildConfidenceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Communication Confidence', style: Theme.of(context).textTheme.titleMedium),
        Slider(
          value: _confidenceLevel,
          min: 1,
          max: 10,
          divisions: 9,
          label: _confidenceLevel.round().toString(),
          onChanged: (double value) {
            setState(() {
              _confidenceLevel = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildChallengesCheckboxes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today\'s Challenges', style: Theme.of(context).textTheme.titleMedium),
        ..._challenges.keys.map((String key) {
          return CheckboxListTile(
            title: Text(key),
            value: _challenges[key],
            onChanged: (bool? value) {
              setState(() {
                _challenges[key] = value!;
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
          Consumer<ProgressProvider>(
            builder: (context, provider, child) {
              return SizedBox(
                height: 200,
                child: ProgressChart(progressData: provider.progressData),
              );
            },
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
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, child) {
        final streak = _calculateStreak(progressProvider.progressData);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Streak', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('$streak days', style: const TextStyle(fontSize: 16)),
              ],
            ),
            Column(
              children: [
                const Text('Badges', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Row(
                  children: _getBadges(streak),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  int _calculateStreak(List<ProgressData> progressData) {
    if (progressData.isEmpty) {
      return 0;
    }

    int streak = 0;
    DateTime today = DateTime.now();
    DateTime currentDate = DateTime(today.year, today.month, today.day);

    progressData.sort((a, b) => b.date.compareTo(a.date));

    for (var i = 0; i < progressData.length; i++) {
      DateTime entryDate = DateTime(progressData[i].date.year, progressData[i].date.month, progressData[i].date.day);
      if (entryDate == currentDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (entryDate.isBefore(currentDate)) {
        break;
      }
    }

    return streak;
  }

  List<Widget> _getBadges(int streak) {
    List<Widget> badges = [];
    if (streak >= 7) {
      badges.add(const Icon(Icons.star, color: Colors.amber));
    }
    if (streak >= 30) {
      badges.add(const Icon(Icons.star, color: Colors.amber));
    }
    if (streak >= 90) {
      badges.add(const Icon(Icons.star, color: Colors.amber));
    }
    return badges;
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
          Text(
            'Goal Setting',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const GoalSettingDialog(),
                );
              },
              child: const Text('Set Weekly Goals'),
            ),
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
          Text(
            'History View',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            onDaySelected: (selectedDay, focusedDay) {
              final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
              final progressData = progressProvider.progressData.where((data) {
                return data.date.year == selectedDay.year &&
                    data.date.month == selectedDay.month &&
                    data.date.day == selectedDay.day;
              }).toList();
              // TODO: Display the progress data
              print(progressData);
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Export Data'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Backup'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Restore'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
