import 'dart:async';

import 'package:flutter/material.dart';

import '../data/content_data.dart';
import '../models/feature.dart';
import '../services/storage_service.dart';
import '../services/pdf_report_service.dart';

class FeatureScreen extends StatefulWidget {
  final Feature feature;
  final bool hindi;

  const FeatureScreen({
    super.key,
    required this.feature,
    required this.hindi,
  });

  @override
  State<FeatureScreen> createState() => _FeatureScreenState();
}

class _FeatureScreenState extends State<FeatureScreen> {
  final StorageService _storage = StorageService.instance;
  final TextEditingController _noteController = TextEditingController();

  String _mood = 'Good';
  int _energy = 3;
  double _sleep = 7;
  bool _loading = true;

  List<Map<String, Object?>> _journal = [];
  final Map<String, bool> _routine = {};

  int _question = 0;
  final List<int> _answers = [];

  Timer? _timer;
  int _seconds = 20;
  bool _running = false;

  bool get hi => widget.hindi;

  String get dayKey {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static const routineLabels = <(String, String)>[
    ('सुबह समय पर उठना', 'Wake up at a regular time'),
    ('सुबह पानी पीना', 'Drink water in the morning'),
    ('दाँत साफ करना', 'Brush your teeth'),
    ('जीभ की सफाई', 'Clean your tongue'),
    ('चेहरा धोना', 'Wash your face'),
    ('कुछ देर शांत बैठना', 'Spend a moment sitting quietly'),
    ('हल्की स्ट्रेचिंग', 'Do gentle stretching'),
    ('योग या हल्का व्यायाम', 'Do yoga or light exercise'),
    ('सुबह की ताजी हवा लेना', 'Get some fresh air'),
    ('धूप में आराम से समय बिताना', 'Spend a little time outdoors'),
    ('नाश्ता करना', 'Eat breakfast'),
    ('फल या सब्जी खाना', 'Eat fruit or vegetables'),
    ('संतुलित भोजन करना', 'Eat a balanced meal'),
    ('भोजन धीरे-धीरे खाना', 'Eat meals slowly'),
    ('भोजन के समय स्क्रीन से बचना', 'Avoid screens during meals'),
    ('दिन में नियमित पानी पीना', 'Drink water regularly'),
    ('लंबे समय बैठने से ब्रेक लेना', 'Take breaks from prolonged sitting'),
    ('आँखों को आराम देना', 'Give your eyes a break'),
    ('हाथ साफ रखना', 'Keep your hands clean'),
    ('काम के बीच छोटा ब्रेक लेना', 'Take short work breaks'),
    ('कुछ देर बाहर टहलना', 'Take a short walk outdoors'),
    ('परिवार या मित्र से बात करना', 'Connect with family or friends'),
    ('मनपसंद स्वस्थ गतिविधि करना', 'Enjoy a healthy activity'),
    ('शाम को हल्की गतिविधि करना', 'Do gentle evening activity'),
    ('रात का भोजन समय पर करना', 'Eat dinner at a regular time'),
    ('सोने से पहले स्क्रीन कम करना', 'Reduce screen use before bed'),
    ('सोने से पहले शांत होना', 'Wind down before sleep'),
    ('अगले दिन की योजना बनाना', 'Plan the next day'),
    ('सोने का नियमित समय रखना', 'Keep a regular bedtime'),
    ('पर्याप्त नींद का अवसर देना', 'Allow enough time for sleep'),
  ];

  // Educational self-reflection only; not a validated medical assessment.
  static const prakritiQuestions = <(String, String, List<(String, String)>)>[
    (
      'आपकी ऊर्जा सामान्यतः कैसी रहती है?',
      'How does your energy usually feel?',
      [
        ('बदलती रहती है', 'Variable'),
        ('मध्यम और स्थिर', 'Moderate and steady'),
        ('स्थिर और धीरे बढ़ती है', 'Steady and gradual'),
      ]
    ),
    (
      'आपका काम करने का तरीका कैसा है?',
      'What is your usual working style?',
      [
        ('तेज और बदलता हुआ', 'Quick and changing'),
        ('लक्ष्य पर केंद्रित', 'Goal-focused'),
        ('स्थिर और धैर्यवान', 'Steady and patient'),
      ]
    ),
    (
      'नई जानकारी सीखने का आपका तरीका?',
      'How do you usually learn new information?',
      [
        ('जल्दी सीखता हूँ, जल्दी भूल सकता हूँ', 'Learn quickly, may forget quickly'),
        ('ध्यान से समझकर सीखता हूँ', 'Learn by focusing carefully'),
        ('धीरे सीखता हूँ, लंबे समय याद रखता हूँ', 'Learn gradually, remember for longer'),
      ]
    ),
    (
      'आपकी दिनचर्या कैसी रहती है?',
      'How regular is your daily routine?',
      [
        ('अक्सर बदलती रहती है', 'Often changes'),
        ('अधिकतर व्यवस्थित', 'Mostly organized'),
        ('नियमित और स्थिर', 'Regular and steady'),
      ]
    ),
    (
      'तनाव के समय आपकी सामान्य प्रतिक्रिया?',
      'How do you usually respond to stress?',
      [
        ('बेचैनी या चिंता हो सकती है', 'May feel restless or worried'),
        ('समस्या हल करने पर ध्यान देता हूँ', 'Focus on solving the problem'),
        ('धीरे प्रतिक्रिया देता हूँ', 'Respond gradually'),
      ]
    ),
    (
      'आपकी बोलने की गति कैसी है?',
      'What is your usual speaking pace?',
      [
        ('तेज', 'Fast'),
        ('स्पष्ट और मध्यम', 'Clear and moderate'),
        ('धीमी और शांत', 'Slow and calm'),
      ]
    ),
    (
      'आपकी भूख का पैटर्न कैसा है?',
      'How is your usual appetite pattern?',
      [
        ('कभी अधिक, कभी कम', 'Varies'),
        ('समय पर भूख लगती है', 'Usually predictable'),
        ('धीरे भूख लगती है', 'Builds gradually'),
      ]
    ),
    (
      'आपको मौसम में कौन-सा बदलाव अधिक महसूस होता है?',
      'Which weather change do you notice more?',
      [
        ('ठंड और हवा', 'Cold and wind'),
        ('गर्मी', 'Heat'),
        ('नमी और भारीपन', 'Humidity and heaviness'),
      ]
    ),
    (
      'आपकी नींद का सामान्य अनुभव?',
      'How would you describe your usual sleep?',
      [
        ('हल्की या बीच-बीच में टूटती है', 'Light or interrupted'),
        ('मध्यम', 'Moderate'),
        ('गहरी या लंबी', 'Deep or long'),
      ]
    ),
    (
      'आप खाली समय में क्या पसंद करते हैं?',
      'What do you prefer in your free time?',
      [
        ('नई चीजें और बदलाव', 'New things and variety'),
        ('योजना वाले काम', 'Planned activities'),
        ('शांत और आरामदायक काम', 'Calm and comfortable activities'),
      ]
    ),
    (
      'आपकी याददाश्त का अनुभव कैसा है?',
      'How would you describe your memory?',
      [
        ('कई बातें याद रहती हैं, पर ध्यान बदलता है', 'Remember many things but attention shifts'),
        ('तथ्य और विवरण याद रहते हैं', 'Remember facts and details'),
        ('धीरे सीखता हूँ, लंबे समय याद रखता हूँ', 'Learn slowly, retain for a long time'),
      ]
    ),
    (
      'आप निर्णय कैसे लेते हैं?',
      'How do you usually make decisions?',
      [
        ('जल्दी निर्णय लेता हूँ', 'Decide quickly'),
        ('तुलना करके निर्णय लेता हूँ', 'Compare options before deciding'),
        ('समय लेकर निर्णय लेता हूँ', 'Take time to decide'),
      ]
    ),
    (
      'आपकी सामान्य गतिविधि की गति?',
      'What is your usual activity pace?',
      [
        ('तेज और बदलती हुई', 'Fast and variable'),
        ('मध्यम और केंद्रित', 'Moderate and focused'),
        ('स्थिर और आरामदायक', 'Steady and comfortable'),
      ]
    ),
    (
      'आपको किस प्रकार का काम अच्छा लगता है?',
      'What kind of work do you prefer?',
      [
        ('विविध और रचनात्मक', 'Varied and creative'),
        ('चुनौतीपूर्ण और लक्ष्य आधारित', 'Challenging and goal-oriented'),
        ('नियमित और पूर्वानुमेय', 'Regular and predictable'),
      ]
    ),
    (
      'आप बदलाव को कैसे लेते हैं?',
      'How do you usually handle change?',
      [
        ('जल्दी अपनाता हूँ, पर बेचैनी हो सकती है', 'Adapt quickly, may feel unsettled'),
        ('योजना बनाकर अपनाता हूँ', 'Adapt with a plan'),
        ('धीरे-धीरे अपनाता हूँ', 'Adapt gradually'),
      ]
    ),
    (
      'आपके आराम करने का पसंदीदा तरीका?',
      'What is your preferred way to relax?',
      [
        ('टहलना या गतिविधि बदलना', 'Walk or change activities'),
        ('शांत होकर कोई काम करना', 'Do a focused, calm activity'),
        ('आराम करना या शांत बैठना', 'Rest or sit quietly'),
      ]
    ),
    (
      'आपका ध्यान कितनी देर स्थिर रहता है?',
      'How steady is your attention?',
      [
        ('कई चीजों के बीच बदलता है', 'Moves between different things'),
        ('लक्ष्य पर अच्छा रहता है', 'Good when focused on a goal'),
        ('लंबे समय एक काम पर रहता है', 'Stays with one task for a long time'),
      ]
    ),
    (
      'आपकी सामान्य सहनशीलता कैसी है?',
      'How would you describe your usual patience?',
      [
        ('परिस्थिति के अनुसार बदलती है', 'Changes with the situation'),
        ('समस्या सुलझाने पर केंद्रित', 'Focused on resolving issues'),
        ('आमतौर पर धैर्यवान', 'Usually patient'),
      ]
    ),
    (
      'आप दिन की योजना कैसे बनाते हैं?',
      'How do you plan your day?',
      [
        ('लचीली योजना पसंद है', 'Prefer a flexible plan'),
        ('स्पष्ट लक्ष्य बनाता हूँ', 'Set clear goals'),
        ('नियमित दिनचर्या पसंद है', 'Prefer a regular routine'),
      ]
    ),
    (
      'किस तरह का वातावरण आपको सहज लगता है?',
      'Which environment feels most comfortable?',
      [
        ('शांत और कम उत्तेजना वाला', 'Quiet and low-stimulation'),
        ('सुव्यवस्थित और आरामदायक', 'Organized and comfortable'),
        ('गर्मजोशी और स्थिरता वाला', 'Warm and familiar'),
      ]
    ),
  ];

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

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.feature.title(hi))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
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
              ],
            ),
    );
  }

  Widget _intro() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              widget.feature.icon,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hi
                    ? 'छोटे और नियमित कदम आपकी दिनचर्या को बेहतर बनाने में मदद कर सकते हैं।'
                    : 'Small and consistent steps can support a healthier routine.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dailyRoutine() {
    final completed = _routine.values.where((v) => v).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hi ? 'आज की चेकलिस्ट' : "Today's checklist",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          hi
              ? 'अपनी सुविधा के अनुसार गतिविधियाँ चुनें। हर गतिविधि जरूरी नहीं है।'
              : 'Choose activities that suit you. You do not need to complete every item.',
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$completed / ${routineLabels.length} ${hi ? 'पूरे हुए' : 'completed'}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completed / routineLabels.length,
                ),
              ],
            ),
          ),
        ),
        ...List.generate(routineLabels.length, (i) {
          final label = hi ? routineLabels[i].$1 : routineLabels[i].$2;

          return Card(
            child: CheckboxListTile(
              value: _routine['$i'] ?? false,
              title: Text(label),
              onChanged: (value) async {
                final done = value ?? false;
                setState(() => _routine['$i'] = done);
                await _storage.setRoutine(dayKey, '$i', done);
              },
            ),
          );
        }),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () async {
            for (var i = 0; i < routineLabels.length; i++) {
              await _storage.setRoutine(dayKey, '$i', false);
            }
            if (!mounted) return;
            setState(() {
              for (var i = 0; i < routineLabels.length; i++) {
                _routine['$i'] = false;
              }
            });
          },
          icon: const Icon(Icons.restart_alt),
          label: Text(hi ? 'आज की चेकलिस्ट रीसेट करें' : 'Reset today’s checklist'),
        ),
      ],
    );
  }

  Widget _guide(List<GuideItem> items) {
    return Column(
      children: items.map((item) {
        return Card(
          child: ExpansionTile(
            leading: const Icon(Icons.eco_outlined),
            title: Text(hi ? item.title : item.englishTitle),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(hi ? item.description : item.englishDescription),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _prakriti() {
    final total = prakritiQuestions.length;

    if (_question >= total) {
      final vata = _answers.where((a) => a == 0).length;
      final pitta = _answers.where((a) => a == 1).length;
      final kapha = _answers.where((a) => a == 2).length;
      final maxScore = [vata, pitta, kapha].reduce((a, b) => a > b ? a : b);

      final result = vata == maxScore && pitta == maxScore && kapha == maxScore
          ? (hi ? 'मिश्रित उत्तर' : 'Mixed responses')
          : vata == maxScore
              ? (hi ? 'वात से जुड़े उत्तर अधिक' : 'More Vata-associated responses')
              : pitta == maxScore
                  ? (hi ? 'पित्त से जुड़े उत्तर अधिक' : 'More Pitta-associated responses')
                  : (hi ? 'कफ से जुड़े उत्तर अधिक' : 'More Kapha-associated responses');

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.spa_outlined, size: 42),
              const SizedBox(height: 10),
              Text(result, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                hi
                    ? 'वात-संबंधी उत्तर: $vata\nपित्त-संबंधी उत्तर: $pitta\nकफ-संबंधी उत्तर: $kapha'
                    : 'Vata-associated answers: $vata\nPitta-associated answers: $pitta\nKapha-associated answers: $kapha',
              ),
              const SizedBox(height: 12),
              Text(
                hi
                    ? 'यह पारंपरिक स्व-चिंतन अभ्यास है, वैज्ञानिक रूप से प्रमाणित प्रकृति परीक्षण या बीमारी का निदान नहीं। केवल इस परिणाम के आधार पर दवा, आहार या उपचार न बदलें।'
                    : 'This is a traditional self-reflection exercise, not a scientifically validated assessment or medical diagnosis. Do not change medicines, diet or treatment based only on this result.',
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    setState(() {
                      _question = 0;
                      _answers.clear();
                    });
                  },
                  child: Text(hi ? 'फिर से शुरू करें' : 'Start again'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final question = prakritiQuestions[_question];
    final choices = question.$3;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${hi ? 'प्रश्न' : 'Question'} ${_question + 1}/$total',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: (_question + 1) / total),
            const SizedBox(height: 16),
            Text(
              hi ? question.$1 : question.$2,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...List.generate(choices.length, (i) {
              return RadioListTile<int>(
                value: i,
                groupValue: _answers.length > _question
                    ? _answers[_question]
                    : null,
                title: Text(hi ? choices[i].$1 : choices[i].$2),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    if (_answers.length > _question) {
                      _answers[_question] = value;
                    } else {
                      _answers.add(value);
                    }
                  });
                },
              );
            }),
            const SizedBox(height: 8),
            Row(
              children: [
                if (_question > 0)
                  OutlinedButton(
                    onPressed: () => setState(() => _question--),
                    child: Text(hi ? 'पीछे' : 'Back'),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _answers.length <= _question
                      ? null
                      : () async {
                          if (_question == total - 1) {
                            final v = _answers.where((a) => a == 0).length;
                            final p = _answers.where((a) => a == 1).length;
                            final k = _answers.where((a) => a == 2).length;
                            await _storage.addPrakritiResult(v, p, k);
                          }
                          if (!mounted) return;
                          setState(() => _question++);
                        },
                  child: Text(
                    _question == total - 1
                        ? (hi ? 'परिणाम देखें' : 'View result')
                        : (hi ? 'आगे बढ़ें' : 'Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _journalPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hi ? 'आज की एंट्री' : 'New entry',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _mood,
                  decoration: InputDecoration(
                    labelText: hi ? 'आज का मूड' : 'Today’s mood',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Good',
                      child: Text('🙂 Good / अच्छा'),
                    ),
                    DropdownMenuItem(
                      value: 'Okay',
                      child: Text('😐 Okay / ठीक'),
                    ),
                    DropdownMenuItem(
                      value: 'Low',
                      child: Text('🙁 Low / उदास'),
                    ),
                    DropdownMenuItem(
                      value: 'Stressed',
                      child: Text('😣 Stressed / तनाव'),
                    ),
                    DropdownMenuItem(
                      value: 'Energetic',
                      child: Text('⚡ Energetic / ऊर्जावान'),
                    ),
                    DropdownMenuItem(
                      value: 'Calm',
                      child: Text('🌿 Calm / शांत'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => _mood = value ?? 'Good');
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hi ? 'ऊर्जा: $_energy/5' : 'Energy: $_energy/5',
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _energy.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        onChanged: (value) {
                          setState(() => _energy = value.round());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hi
                            ? 'नींद: ${_sleep.toStringAsFixed(1)} घंटे'
                            : 'Sleep: ${_sleep.toStringAsFixed(1)} hours',
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: _sleep,
                        min: 0,
                        max: 12,
                        divisions: 24,
                        onChanged: (value) {
                          setState(() => _sleep = value);
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _noteController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: hi ? 'आज के नोट्स' : 'Notes for today',
                    hintText: hi
                        ? 'अपने विचार या दिन का अनुभव लिखें'
                        : 'Write your thoughts or how your day felt',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _saveJournal,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(hi ? 'रिकॉर्ड सेव करें' : 'Save entry'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          hi ? 'पुराने रिकॉर्ड' : 'Past entries',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        if (_journal.isEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              hi ? 'अभी कोई रिकॉर्ड नहीं है।' : 'No entries yet.',
            ),
          ),
        ..._journal.map(
          (entry) => Card(
            child: ListTile(
              title: Text('${entry['mood']} • ${entry['energy']}/5'),
              subtitle: Text(
                '${entry['created_at']}\n${entry['note']}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: hi ? 'रिकॉर्ड हटाएँ' : 'Delete entry',
                onPressed: () async {
                  final id = entry['id'];
                  if (id is int) {
                    await _storage.deleteJournal(id);
                    await _load();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveJournal() async {
    await _storage.addJournal(
      mood: _mood,
      energy: _energy,
      sleepHours: _sleep,
      note: _noteController.text.trim(),
    );

    _noteController.clear();
    await _load();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hi ? 'रिकॉर्ड फोन में सेव हो गया।' : 'Entry saved on this phone.',
        ),
      ),
    );
  }

  Widget _eyeBreak() {
    final minutes = _seconds ~/ 60;
    final seconds = _seconds % 60;
    final timeText =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const Icon(Icons.remove_red_eye_rounded, size: 54),
            const SizedBox(height: 10),
            Text(
              hi ? '20-20-20 नियम' : '20-20-20 rule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              hi
                  ? 'स्क्रीन देखते समय नियमित ब्रेक लें। सामान्य सुझाव के अनुसार हर 20 मिनट बाद लगभग 20 फीट दूर किसी चीज़ को 20 सेकंड देखें।'
                  : 'Take regular screen breaks. A common suggestion is to look at something about 20 feet away for 20 seconds every 20 minutes.',
            ),
            const SizedBox(height: 18),
            Text(
              timeText,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                FilledButton(
                  onPressed: _running ? null : _startTimer,
                  child: Text(hi ? '20 सेकंड शुरू करें' : 'Start 20 seconds'),
                ),
                OutlinedButton(
                  onPressed: () {
                    _timer?.cancel();
                    setState(() {
                      _running = false;
                      _seconds = 20;
                    });
                  },
                  child: Text(hi ? 'रीसेट' : 'Reset'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              hi
                  ? 'टाइमर ऐप खुले रहने पर चलता है। यह बैकग्राउंड रिमाइंडर नहीं है।'
                  : 'The timer runs while the app is open. It is not a background reminder.',
            ),
          ],
        ),
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();

    setState(() {
      _running = true;
      _seconds = 20;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_seconds <= 1) {
        timer.cancel();

        setState(() {
          _seconds = 0;
          _running = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              hi
                  ? 'अब दूर देखें और आँखों को आराम दें।'
                  : 'Look away and rest your eyes.',
            ),
          ),
        );
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Widget _reportPage() {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: _storage.getJournal(),
      builder: (context, snapshot) {
        final rows = snapshot.data ?? [];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.picture_as_pdf_rounded, size: 44),
                const SizedBox(height: 10),
                Text(
                  hi ? 'वेलनेस रिकॉर्ड की PDF' : 'Wellness record PDF',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  hi
                      ? 'इस फोन में सेव ${rows.length} डायरी रिकॉर्ड रिपोर्ट में शामिल किए जा सकते हैं।'
                      : '${rows.length} journal entries saved on this phone can be included in the report.',
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: snapshot.connectionState ==
                            ConnectionState.waiting
                        ? null
                        : () => PdfReportService.shareReport(
                              journal: rows,
                              hindi: hi,
                            ),
                    icon: const Icon(Icons.share),
                    label: Text(
                      hi ? 'PDF बनाएँ और शेयर करें' : 'Create and share PDF',
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hi
                      ? 'यह व्यक्तिगत रिकॉर्ड का सारांश है, चिकित्सकीय प्रमाणपत्र या बीमारी का निदान नहीं।'
                      : 'This is a summary of personal records, not a medical certificate or diagnosis.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
