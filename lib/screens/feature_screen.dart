import 'dart:async';
import 'package:flutter/material.dart';
import '../data/content_data.dart';
import '../models/feature.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';
import '../services/notification_service.dart';

class FeatureScreen extends StatefulWidget {
  final Feature feature;
  final bool hindi;
  const FeatureScreen({super.key, required this.feature, required this.hindi});

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  final _storage = StorageService.instance;
  final _noteController = TextEditingController();
  String _mood = 'Good';
  int _energy = 3;
  double _sleep = 7;
  bool _loading = true;
  List<Map<String, Object?>> _journal = [];
  final Map<String, bool> _routine = {};
  int _question = 0;
  final List<int> _answers = [];
  Timer? _timer;
  int _seconds = 20 * 60;
  bool _running = false;

  bool get hi => widget.hindi;
  String get dayKey {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.feature.id == 8) {
      _journal = await _storage.getJournal();
    }
    if (widget.feature.id == 1) {
      for (var i = 0; i < routineLabels.length; i++) {
        _routine['$i'] = await _storage.routineDone(dayKey, '$i');
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _noteController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  static const routineLabels = [
    ('पानी पीना', 'Drink water'),
    ('हल्की स्ट्रेचिंग', 'Gentle stretching'),
    ('कुछ समय बाहर/धूप में', 'Spend time outdoors'),
    ('संतुलित भोजन', 'Balanced meal'),
    ('समय पर सोना', 'Sleep on time'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.feature.title(hi))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              _intro(),
              const SizedBox(height: 12),
              switch (widget.feature.id) {
                1 => _dailyRoutine(),
                2 => _guide(mudras),
                3 => _guide(plants),
                4 => _guide(recipes),
                5 => _guide(teas),
                6 => _guide(unaniTerms),
                7 => _prakriti(),
                8 => _journalPage(),
                9 => _eyeBreak(),
                10 => _reportPage(),
                _ => const SizedBox.shrink(),
              },
            ]),
    );
  }

  Widget _intro() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        Icon(widget.feature.icon, size: 32, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(
          hi ? 'छोटे, नियमित कदम आपकी दिनचर्या को बेहतर बना सकते हैं।' : 'Small, consistent steps can support a healthy routine.',
        )),
      ]),
    ),
  );

  Widget _dailyRoutine() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(hi ? 'आज की चेकलिस्ट' : "Today's checklist", style: Theme.of(context).textTheme.titleLarge),
    const SizedBox(height: 8),
    ...List.generate(routineLabels.length, (i) {
      final label = hi ? routineLabels[i].$1 : routineLabels[i].$2;
      return Card(child: CheckboxListTile(
        value: _routine['$i'] ?? false,
        title: Text(label),
        onChanged: (value) async {
          final done = value ?? false;
          setState(() => _routine['$i'] = done);
          await _storage.setRoutine(dayKey, '$i', done);
        },
      ));
    }),
    const SizedBox(height: 8),
    Text('${_routine.values.where((v) => v).length}/${routineLabels.length} ${hi ? 'पूरे हुए' : 'completed'}'),
  ]);

  Widget _guide(List<GuideItem> items) => Column(children: items.map((item) => Card(
    child: ExpansionTile(
      leading: const Icon(Icons.eco_outlined),
      title: Text(hi ? item.hi : item.en),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      children: [Align(
        alignment: Alignment.centerLeft,
        child: Text(hi ? item.descriptionHi : item.descriptionEn),
      )],
    ),
  )).toList());

  Widget _prakriti() {
    final questions = hi
      ? ['आपकी सामान्य ऊर्जा कैसी रहती है?', 'आपकी त्वचा/शरीर की प्रकृति कैसी लगती है?', 'आपका सामान्य काम करने का तरीका?']
      : ['How does your usual energy feel?', 'How would you describe your skin/body tendency?', 'What is your usual working style?'];
    final choices = hi
      ? [['बदलती रहती है', 'मध्यम और स्थिर', 'लगातार और धीमी'], ['रूखी/ठंडी', 'गर्म/संवेदनशील', 'नरम/तैलीय'], ['तेज़ और बदलता हुआ', 'लक्ष्य-केंद्रित', 'स्थिर और धैर्यवान']]
      : [['Variable', 'Moderate and steady', 'Steady and slow'], ['Dry/cool', 'Warm/sensitive', 'Soft/oily'], ['Quick and changing', 'Goal-focused', 'Steady and patient']];
    if (_question >= questions.length) {
      final vata = _answers.where((a) => a == 0).length;
      final pitta = _answers.where((a) => a == 1).length;
      final kapha = _answers.where((a) => a == 2).length;
      final max = [vata, pitta, kapha].reduce((a,b) => a > b ? a : b);
      final result = vata == max && pitta == max && kapha == max
          ? (hi ? 'मिश्रित उत्तर' : 'Mixed responses')
          : vata == max ? (hi ? 'वात से जुड़े उत्तर अधिक' : 'More Vata-associated responses')
          : pitta == max ? (hi ? 'पित्त से जुड़े उत्तर अधिक' : 'More Pitta-associated responses')
          : (hi ? 'कफ से जुड़े उत्तर अधिक' : 'More Kapha-associated responses');
      return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(result, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(hi
            ? 'यह केवल पारंपरिक स्व-चिंतन प्रश्नावली है, प्रमाणित निदान नहीं। स्वास्थ्य निर्णय के लिए योग्य चिकित्सक से सलाह लें।'
            : 'This is a traditional self-reflection questionnaire, not a validated diagnosis. Consult a qualified clinician for health decisions.'),
          const SizedBox(height: 12),
          FilledButton(onPressed: () => setState(() { _question = 0; _answers.clear(); }),
            child: Text(hi ? 'फिर से शुरू करें' : 'Start again')),
        ],
      )));
    }
    return Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${hi ? 'प्रश्न' : 'Question'} ${_question + 1}/${questions.length}',
          style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 10),
        Text(questions[_question], style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...List.generate(3, (i) => RadioListTile<int>(
          value: i, groupValue: _answers.length > _question ? _answers[_question] : null,
          title: Text(choices[_question][i]),
          onChanged: (v) {
            if (v == null) return;
            setState(() {
              if (_answers.length > _question) {
                _answers[_question] = v;
              } else {
                _answers.add(v);
              }
            });
          },
        )),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _answers.length <= _question ? null : () async {
            if (_question == questions.length - 1) {
              final v = _answers.where((a) => a == 0).length;
              final p = _answers.where((a) => a == 1).length;
              final k = _answers.where((a) => a == 2).length;
              await _storage.addPrakritiResult(v, p, k);
            }
            setState(() => _question++);
          },
          child: Text(_question == questions.length - 1
              ? (hi ? 'परिणाम देखें' : 'View result')
              : (hi ? 'आगे बढ़ें' : 'Continue')),
        ),
      ],
    )));
  }

  Widget _journalPage() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(hi ? 'आज की एंट्री' : 'New entry', style: Theme.of(context).textTheme.titleLarge),
    const SizedBox(height: 10),
    Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
      DropdownButtonFormField<String>(
        value: _mood,
        decoration: InputDecoration(labelText: hi ? 'मूड' : 'Mood'),
        items: const [
          DropdownMenuItem(value: 'Good', child: Text('🙂 Good / अच्छा')),
          DropdownMenuItem(value: 'Okay', child: Text('😐 Okay / ठीक')),
          DropdownMenuItem(value: 'Low', child: Text('🙁 Low / उदास')),
          DropdownMenuItem(value: 'Stressed', child: Text('😣 Stressed / तनाव')),
        ],
        onChanged: (v) => setState(() => _mood = v ?? 'Good'),
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: Text(hi ? 'ऊर्जा: $_energy/5' : 'Energy: $_energy/5')),
        Expanded(child: Slider(value: _energy.toDouble(), min: 1, max: 5, divisions: 4,
          onChanged: (v) => setState(() => _energy = v.round()))),
      ]),
      Row(children: [
        Expanded(child: Text(hi ? 'नींद: ${_sleep.toStringAsFixed(1)} घंटे' : 'Sleep: ${_sleep.toStringAsFixed(1)} h')),
        Expanded(child: Slider(value: _sleep, min: 0, max: 12, divisions: 24,
          onChanged: (v) => setState(() => _sleep = v))),
      ]),
      TextField(controller: _noteController, maxLines: 3,
        decoration: InputDecoration(labelText: hi ? 'नोट्स (वैकल्पिक)' : 'Notes (optional)')),
      const SizedBox(height: 12),
      SizedBox(width: double.infinity, child: FilledButton.icon(
        onPressed: () async {
          await _storage.addJournal(mood: _mood, energy: _energy, sleepHours: _sleep, note: _noteController.text.trim());
          _noteController.clear();
          await _load();
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(hi ? 'रिकॉर्ड फोन में सेव हो गया' : 'Entry saved on this phone')));
        },
        icon: const Icon(Icons.save_outlined),
        label: Text(hi ? 'रिकॉर्ड सेव करें' : 'Save entry'),
      )),
    ]))),
    const SizedBox(height: 12),
    Text(hi ? 'पुराने रिकॉर्ड' : 'Past entries', style: Theme.of(context).textTheme.titleLarge),
    if (_journal.isEmpty) Padding(padding: const EdgeInsets.all(12), child: Text(hi ? 'अभी कोई रिकॉर्ड नहीं है।' : 'No entries yet.')),
    ..._journal.map((e) => Card(child: ListTile(
      title: Text('${e['mood']} • ${e['energy']}/5'),
      subtitle: Text('${e['created_at']}\n${e['note']}'),
      isThreeLine: true,
      trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
        await _storage.deleteJournal(e['id'] as int);
        await _load();
      }),
    ))),
  ]);

  Widget _eyeBreak() => Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
    children: [
      const Icon(Icons.remove_red_eye_rounded, size: 54),
      const SizedBox(height: 10),
      Text(hi ? '20-20-20 नियम' : '20-20-20 rule', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      Text(hi
        ? 'हर 20 मिनट पर लगभग 20 फीट दूर किसी चीज़ को 20 सेकंड देखें। यह सरल सुझाव है, चिकित्सा सलाह नहीं।'
        : 'Every 20 minutes, look at something about 20 feet away for 20 seconds. This is general guidance, not medical advice.'),
      const SizedBox(height: 18),
      Text(_running ? '${(_seconds ~/ 60).toString().padLeft(2, '0')}:${(_seconds % 60).toString().padLeft(2, '0')}' : '20:00',
        style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      Wrap(spacing: 10, children: [
        FilledButton(onPressed: _running ? null : _startTimer,
          child: Text(hi ? 'टाइमर शुरू करें' : 'Start timer')),
        OutlinedButton(onPressed: () { _timer?.cancel(); setState(() { _running = false; _seconds = 20 * 60; }); },
          child: Text(hi ? 'रीसेट' : 'Reset')),
      ]),
      const SizedBox(height: 8),
      Text(hi ? 'टाइमर ऐप खुला रहने पर चलता है। बैकग्राउंड नोटिफिकेशन के लिए भविष्य में Android पर अलग परीक्षण जरूरी है।' :
        'Timer runs while the app is open. Background reminders require additional Android testing.'),
    ],
  )));

  void _startTimer() {
    _timer?.cancel();
    setState(() { _running = true; _seconds = 20 * 60; });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_seconds <= 1) {
        timer.cancel();
        setState(() { _seconds = 0; _running = false; });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(hi ? 'अब दूर देखें और आँखों को आराम दें।' : 'Look away and rest your eyes.')));
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Widget _reportPage() => FutureBuilder<List<Map<String, Object?>>>(
    future: _storage.getJournal(),
    builder: (context, snapshot) {
      final rows = snapshot.data ?? [];
      return Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.picture_as_pdf_rounded, size: 44),
          const SizedBox(height: 10),
          Text(hi ? 'वेलनेस रिकॉर्ड की PDF' : 'Wellness record PDF', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(hi
            ? 'आपकी ${rows.length} डायरी एंट्री से रिपोर्ट बनाई जाएगी। अभी रिकॉर्ड न होने पर खाली रिपोर्ट बनेगी।'
            : 'A report will be made from ${rows.length} journal entries. If there are no entries, an empty report will be generated.'),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: FilledButton.icon(
            onPressed: () => PdfReportService.shareReport(journal: rows, hindi: hi),
            icon: const Icon(Icons.share),
            label: Text(hi ? 'PDF बनाएँ और शेयर करें' : 'Create & share PDF'),
          )),
          const SizedBox(height: 8),
          Text(hi ? 'PDF में दर्ज रिकॉर्ड शामिल होंगे; यह चिकित्सकीय प्रमाणपत्र नहीं है।' :
            'The PDF contains entered records; it is not a medical certificate.'),
        ],
      )));
    },
  );
}
