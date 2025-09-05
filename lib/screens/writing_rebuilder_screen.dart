import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/writing_provider.dart';
import '../widgets/writing_tracing_canvas.dart';
import '../models/writing_sample.dart';
import '../services/tts_service.dart';
import '../utils/text_similarity.dart';

class WritingRebuilderScreen extends StatelessWidget {
  const WritingRebuilderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WritingProvider(),
      child: const _WritingScaffold(),
    );
  }
}

class _WritingScaffold extends StatefulWidget {
  const _WritingScaffold();

  @override
  State<_WritingScaffold> createState() => _WritingScaffoldState();
}

class _WritingScaffoldState extends State<_WritingScaffold>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _tts = TTSService();
  final _dictationController = TextEditingController();
  final _copyController = TextEditingController();
  final _creativeController = TextEditingController();
  double _tracingAccuracy = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    _dictationController.dispose();
    _copyController.dispose();
    _creativeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WritingProvider>();
    final controls = _buildControls(context, p);
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Writing Rebuilder',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Tracing'),
            Tab(text: 'Copying'),
            Tab(text: 'Dictation'),
            Tab(text: 'Creative'),
          ],
          onTap: (i) {
            final modes = [
              WritingMode.tracing,
              WritingMode.copying,
              WritingMode.dictation,
              WritingMode.creative
            ];
            p.setMode(modes[i]);
          },
        ),
      ),
      body: Row(
        children: p.leftHanded
            ? [controls, Expanded(child: _buildBody(context, p))]
            : [Expanded(child: _buildBody(context, p)), controls],
      ),
    );
  }

  Widget _buildControls(BuildContext context, WritingProvider p) {
    String timerLabel() {
      final ms = p.elapsedMs;
      final s = (ms ~/ 1000) % 60;
      final m = (ms ~/ 60000);
      return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [AppTheme.cardShadow],
      ),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Font'),
                Expanded(
                  child: Slider(
                    value: p.fontSize,
                    min: 48,
                    max: 160,
                    onChanged: (v) => p.setFontSize(v),
                  ),
                ),
              ],
            ),
            SwitchListTile(
              value: p.showLineGuides,
              onChanged: p.setLineGuides,
              title: const Text('Line guides'),
              dense: true,
            ),
            SwitchListTile(
              value: p.leftHanded,
              onChanged: p.setLeftHanded,
              title: const Text('Left-handed mode'),
              dense: true,
            ),
            SwitchListTile(
              value: p.timerEnabled,
              onChanged: p.setTimerEnabled,
              title: const Text('Timer'),
              dense: true,
            ),
            if (p.timerEnabled)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: p.isTiming ? null : p.startTimer,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: p.isTiming ? p.stopTimer : null,
                    icon: const Icon(Icons.stop),
                    label: Text(timerLabel()),
                  ),
                ],
              ),
            const Divider(height: 24),
            const Text('History', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...p.history.take(8).map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(
                        h.mode == WritingMode.tracing
                            ? Icons.brush
                            : h.mode == WritingMode.copying
                                ? Icons.text_fields
                                : h.mode == WritingMode.dictation
                                    ? Icons.hearing
                                    : Icons.edit_note,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${h.mode.name} • ${h.wordCount}w • ${(h.accuracy ?? 0).toStringAsFixed(2)} • ${h.date.toLocal().toIso8601String().substring(0,16)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WritingProvider p) {
    return TabBarView(
      controller: _tab,
      children: [
        _buildTracing(context, p),
        _buildCopying(context, p),
        _buildDictation(context, p),
        _buildCreative(context, p),
      ],
    );
  }

  Widget _buildTracing(BuildContext context, WritingProvider p) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Text('Lowercase'),
              Switch(value: p.lowercase, onChanged: p.toggleLowercase),
              const SizedBox(width: 12),
              const Text('Include 0-9'),
              Switch(value: p.includeNumbers, onChanged: p.setIncludeNumbers),
              const Spacer(),
              IconButton(onPressed: p.prevChar, icon: const Icon(Icons.chevron_left)),
              Text(p.currentChar, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              IconButton(onPressed: p.nextChar, icon: const Icon(Icons.chevron_right)),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 2,
              child: WritingTracingCanvas(
                target: p.currentChar,
                fontSize: p.fontSize,
                showGuides: p.showLineGuides,
                guideColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                onAccuracy: (a) => setState(() => _tracingAccuracy = a),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Text('Accuracy: ${(_tracingAccuracy * 100).toStringAsFixed(0)}%'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await context.read<WritingProvider>().recordSample(
                        mode: WritingMode.tracing,
                        content: 'traced ${p.currentChar}',
                        target: p.currentChar,
                        accuracy: _tracingAccuracy,
                      );
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCopying(BuildContext context, WritingProvider p) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton<String>(
                value: p.currentCategory,
                items: const [
                  DropdownMenuItem(value: 'family', child: Text('Family')),
                  DropdownMenuItem(value: 'food', child: Text('Food')),
                  DropdownMenuItem(value: 'daily', child: Text('Daily Activities')),
                ],
                onChanged: (v) => v == null ? null : p.setCategory(v),
              ),
              const SizedBox(width: 16),
              const Text('Length'),
              const SizedBox(width: 8),
              DropdownButton<int>(
                value: p.minLen,
                items: const [3,4,5,6,7,8].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
                onChanged: (v){ if(v!=null) p.setDifficultyRange(v, p.maxLen); },
              ),
              const Text('-'),
              DropdownButton<int>(
                value: p.maxLen,
                items: const [5,6,7,8,9,10].map((e) => DropdownMenuItem(value: e, child: Text('$e'))).toList(),
                onChanged: (v){ if(v!=null) p.setDifficultyRange(p.minLen, v); },
              ),
              const Spacer(),
              Text('Target: ', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              Chip(label: Text(p.targetWord, style: TextStyle(fontSize: p.fontSize * 0.25))),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => context.read<WritingProvider>().setDifficultyRange(p.minLen, p.maxLen),
                icon: const Icon(Icons.refresh),
                label: const Text('New'),
              )
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _copyController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Type the word',
            ),
          ),
          const SizedBox(height: 12),
          _AccuracyBar(target: p.targetWord, input: _copyController.text),
          const Spacer(),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final acc = p.copyingAccuracy(_copyController.text);
                  final mistakes = p.copyingMistakes(_copyController.text);
                  await p.recordSample(
                    mode: WritingMode.copying,
                    content: _copyController.text,
                    target: p.targetWord,
                    accuracy: acc,
                    mistakes: mistakes,
                  );
                  _copyController.clear();
                },
                icon: const Icon(Icons.check),
                label: const Text('Check & Save'),
              ),
              const SizedBox(width: 12),
              Text('Accuracy: ${(p.copyingAccuracy(_copyController.text)*100).toStringAsFixed(0)}%'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDictation(BuildContext context, WritingProvider p) {
    final target = p.dictationTarget;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _tts.speak(target),
                icon: const Icon(Icons.volume_up),
                label: const Text('Play'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () => _tts.speak(target),
                icon: const Icon(Icons.replay),
                label: const Text('Replay'),
              ),
              const Spacer(),
              Chip(label: Text(p.dictationSentence ? 'Sentence' : 'Word')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _dictationController,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Write what you hear',
            ),
            minLines: 1,
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          _AccuracyBar(target: target, input: _dictationController.text),
          const Spacer(),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final acc = p.dictationAccuracy(_dictationController.text);
                  final mistakes = p.dictationMistakes(_dictationController.text);
                  await p.recordSample(
                    mode: WritingMode.dictation,
                    content: _dictationController.text,
                    target: target,
                    accuracy: acc,
                    mistakes: mistakes,
                  );
                  _dictationController.clear();
                  p.setDifficultyRange(p.minLen, p.maxLen); // pick new
                },
                icon: const Icon(Icons.check),
                label: const Text('Check & Save'),
              ),
              const SizedBox(width: 12),
              Text('Accuracy: ${(p.dictationAccuracy(_dictationController.text)*100).toStringAsFixed(0)}%'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCreative(BuildContext context, WritingProvider p) {
    final prompt = _dailyPrompt();
    final wordCount = _creativeController.text.trim().isEmpty
        ? 0
        : _creativeController.text.trim().split(RegExp(r"\s+")).length;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.amber),
              const SizedBox(width: 8),
              Expanded(child: Text(prompt, style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(width: 8),
              Container(
                width: 64, height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('🖼️', style: TextStyle(fontSize: 28)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TextField(
              controller: _creativeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write your response here...'
              ),
              expands: true,
              maxLines: null,
              minLines: null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Words: $wordCount'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  await p.recordSample(
                    mode: WritingMode.creative,
                    content: _creativeController.text,
                    target: prompt,
                    accuracy: null,
                  );
                  _creativeController.clear();
                },
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Progress timeline'),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: p.history.length,
              itemBuilder: (context, i) {
                final h = p.history[i];
                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [AppTheme.cardShadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.date.toLocal().toIso8601String().substring(0,10), style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(h.target ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.text_snippet, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text('${h.wordCount}w'),
                          const Spacer(),
                          Text(h.accuracy == null ? '' : '${(h.accuracy!*100).toStringAsFixed(0)}%'),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String _dailyPrompt() {
    final prompts = [
      'Describe your breakfast.',
      'Write about the weather.',
      'What made you smile today?',
      'Tell a short story about a friend.',
      'Describe your favorite place.'
    ];
    final day = DateTime.now().day;
    return prompts[day % prompts.length];
  }
}

class _AccuracyBar extends StatelessWidget {
  final String target;
  final String input;
  const _AccuracyBar({required this.target, required this.input});

  @override
  Widget build(BuildContext context) {
    final sim = TextSimilarity.similarity(target, input);
    final color = sim > 0.9 ? Colors.green : sim > 0.7 ? Colors.orange : Colors.red;
    final mistakes = TextSimilarity.analyze(target, input);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(value: sim, minHeight: 10, color: color),
        const SizedBox(height: 6),
        Text(
          'subs ${mistakes['substitutions']}, ins ${mistakes['insertions']}, del ${mistakes['deletions']}, swap ${mistakes['transpositions']}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        _diffView(target, input),
      ],
    );
  }

  Widget _diffView(String a, String b) {
    final maxLen = (a.length > b.length) ? a.length : b.length;
    final spans = <TextSpan>[];
    for (int i = 0; i < maxLen; i++) {
      final ca = i < a.length ? a[i] : '';
      final cb = i < b.length ? b[i] : '';
      if (ca == cb) {
        spans.add(const TextSpan(text: '', style: TextStyle())) ;
        if (cb.isNotEmpty) {
          spans.add(TextSpan(text: cb, style: const TextStyle(color: Colors.green)));
        }
      } else {
        spans.add(TextSpan(text: cb.isEmpty ? '∅' : cb, style: const TextStyle(color: Colors.red)));
      }
    }
    return RichText(text: TextSpan(style: const TextStyle(color: Colors.black), children: spans));
  }
}
