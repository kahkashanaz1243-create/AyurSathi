
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final ValueChanged<String>? onOpenFeature;

  const HomeScreen({
    super.key,
    this.onOpenFeature,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHindi = true;

  static const Color teal = Color(0xFF00897B);
  static const Color green = Color(0xFF43A047);
  static const Color background = Color(0xFFF5FAF8);

  final List<_HomeFeature> features = const [
    _HomeFeature(
      id: 'routine',
      hindi: 'दैनिक दिनचर्या',
      english: 'Daily Routine',
      subtitleHindi: 'अपनी दिनचर्या व्यवस्थित करें',
      subtitleEnglish: 'Build your daily routine',
      icon: Icons.wb_sunny_rounded,
      color: Color(0xFFFFA726),
    ),
    _HomeFeature(
      id: 'mudras',
      hindi: 'योग मुद्रा गाइड',
      english: 'Yoga Mudra Guide',
      subtitleHindi: 'विभिन्न योग मुद्राओं की जानकारी',
      subtitleEnglish: 'Explore traditional yoga mudras',
      icon: Icons.self_improvement_rounded,
      color: Color(0xFF00897B),
    ),
    _HomeFeature(
      id: 'plants',
      hindi: 'हर्बल पौधे',
      english: 'Herbal Plants',
      subtitleHindi: 'पौधों की पहचान और जानकारी',
      subtitleEnglish: 'Learn about herbal plants',
      icon: Icons.eco_rounded,
      color: Color(0xFF43A047),
    ),
    _HomeFeature(
      id: 'recipes',
      hindi: 'हेल्दी रेसिपी',
      english: 'Healthy Recipes',
      subtitleHindi: 'स्वस्थ भोजन के सरल विचार',
      subtitleEnglish: 'Simple healthy food ideas',
      icon: Icons.restaurant_menu_rounded,
      color: Color(0xFFEF6C00),
    ),
    _HomeFeature(
      id: 'teas',
      hindi: 'हर्बल टी गाइड',
      english: 'Herbal Tea Guide',
      subtitleHindi: 'हर्बल पेय बनाने के तरीके',
      subtitleEnglish: 'Explore herbal drink ideas',
      icon: Icons.emoji_food_beverage_rounded,
      color: Color(0xFF7E57C2),
    ),
    _HomeFeature(
      id: 'unani',
      hindi: 'यूनानी शब्दावली',
      english: 'Unani Terms',
      subtitleHindi: 'यूनानी चिकित्सा के पारंपरिक शब्द',
      subtitleEnglish: 'Learn traditional Unani terms',
      icon: Icons.menu_book_rounded,
      color: Color(0xFF039BE5),
    ),
    _HomeFeature(
      id: 'prakriti',
      hindi: 'प्रकृति प्रश्नावली',
      english: 'Prakriti Questionnaire',
      subtitleHindi: 'अपनी प्रकृति के बारे में जानें',
      subtitleEnglish: 'Explore traditional Prakriti concepts',
      icon: Icons.spa_rounded,
      color: Color(0xFF00897B),
    ),
    _HomeFeature(
      id: 'journal',
      hindi: 'वेलनेस जर्नल',
      english: 'Wellness Journal',
      subtitleHindi: 'अपने दैनिक अनुभव लिखें',
      subtitleEnglish: 'Record your daily reflections',
      icon: Icons.edit_note_rounded,
      color: Color(0xFF5C6BC0),
    ),
    _HomeFeature(
      id: 'eye_break',
      hindi: 'आई ब्रेक रिमाइंडर',
      english: 'Eye Break Reminder',
      subtitleHindi: 'स्क्रीन से समय-समय पर ब्रेक लें',
      subtitleEnglish: 'Remember to take screen breaks',
      icon: Icons.remove_red_eye_rounded,
      color: Color(0xFF26A69A),
    ),
    _HomeFeature(
      id: 'health_report',
      hindi: 'हेल्थ रिपोर्ट PDF',
      english: 'Health Report PDF',
      subtitleHindi: 'अपनी रिपोर्ट तैयार करें',
      subtitleEnglish: 'Prepare your wellness report',
      icon: Icons.picture_as_pdf_rounded,
      color: Color(0xFFE53935),
    ),
  ];

  String get textLanguage => isHindi ? 'हिंदी' : 'English';

  void openFeature(_HomeFeature feature) {
    if (widget.onOpenFeature != null) {
      widget.onOpenFeature!(feature.id);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHindi
              ? '${feature.hindi} स्क्रीन को अभी नेविगेशन से जोड़ना बाकी है।'
              : '${feature.english} screen still needs navigation wiring.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 700 ? 3 : 2;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: teal,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [teal, green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.spa_rounded,
                color: Colors.white,
                size: 27,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AyurSathi',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: Color(0xFF176B5B),
                    ),
                  ),
                  Text(
                    'Natural Wellness Guide',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: PopupMenuButton<bool>(
              tooltip: 'Language',
              onSelected: (value) {
                setState(() => isHindi = value);
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: true,
                  child: Text('हिंदी'),
                ),
                PopupMenuItem(
                  value: false,
                  child: Text('English'),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F4EF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.language_rounded,
                      size: 19,
                      color: teal,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      textLanguage,
                      style: const TextStyle(
                        color: teal,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: teal,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildWelcomeCard(),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          isHindi
                              ? 'आपकी वेलनेस यात्रा'
                              : 'Your Wellness Journey',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF203D36),
                          ),
                        ),
                      ),
                      Text(
                        '${features.length} ${isHindi ? 'फीचर' : 'Features'}',
                        style: const TextStyle(
                          color: teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isHindi
                        ? 'जानकारी चुनें और अपनी सुविधानुसार आगे बढ़ें।'
                        : 'Choose a guide and explore at your own pace.',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: features.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 174,
                    ),
                    itemBuilder: (context, index) {
                      final feature = features[index];
                      return _buildFeatureCard(feature);
                    },
                  ),
                  const SizedBox(height: 22),
                  _buildSafetyNote(),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      isHindi
                          ? 'आपकी सेहत, आपकी देखभाल 🌿'
                          : 'Your Wellness, Your Care 🌿',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF52776D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00796B), Color(0xFF43A047)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: teal.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: -12,
            child: Icon(
              Icons.spa_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  isHindi ? '🌿 प्राकृतिक वेलनेस' : '🌿 Natural Wellness',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isHindi
                    ? 'स्वस्थ जीवन की शुरुआत'
                    : 'Begin Your Wellness Journey',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 23,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isHindi
                    ? 'योग, हर्बल जानकारी, भोजन और दैनिक आदतों के लिए आपका साथी।'
                    : 'Your companion for yoga, herbal knowledge, food, and daily habits.',
                style: const TextStyle(
                  color: Colors.white,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.offline_bolt_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isHindi
                        ? 'बिना लॉगिन • ऑफलाइन उपयोग के लिए'
                        : 'No login • Designed for offline use',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(_HomeFeature feature) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => openFeature(feature),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE5EFEB),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: feature.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  feature.icon,
                  color: feature.color,
                  size: 26,
                ),
              ),
              const Spacer(),
              Text(
                isHindi ? feature.hindi : feature.english,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF203D36),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                isHindi
                    ? feature.subtitleHindi
                    : feature.subtitleEnglish,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 10.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyNote() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5F0),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.health_and_safety_outlined,
            color: teal,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isHindi ? 'स्वास्थ्य संबंधी सूचना' : 'Health Disclaimer',
                  style: const TextStyle(
                    color: Color(0xFF176B5B),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  isHindi
                      ? 'ऐप की जानकारी सामान्य शिक्षा के लिए है। यह डॉक्टर की सलाह, जाँच या उपचार का विकल्प नहीं है।'
                      : 'App content is for general education. It does not replace medical advice, diagnosis, or treatment.',
                  style: const TextStyle(
                    color: Color(0xFF45645B),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeFeature {
  final String id;
  final String hindi;
  final String english;
  final String subtitleHindi;
  final String subtitleEnglish;
  final IconData icon;
  final Color color;

  const _HomeFeature({
    required this.id,
    required this.hindi,
    required this.english,
    required this.subtitleHindi,
    required this.subtitleEnglish,
    required this.icon,
    required this.color,
  });
}
