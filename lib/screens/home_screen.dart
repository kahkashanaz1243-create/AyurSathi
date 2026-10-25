import 'package:flutter/material.dart';
import '../models/feature.dart';
import '../widgets/ad_banner.dart';
import 'feature_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hindi = true;
  int _tab = 0;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final visible = features.where((f) =>
      f.title(_hindi).toLowerCase().contains(_search.text.toLowerCase()) ||
      f.title(!_hindi).toLowerCase().contains(_search.text.toLowerCase())).toList();
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(13)),
            child: Icon(Icons.spa_rounded, color: Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 10),
          const Expanded(child: Text('AyurSathi', style: TextStyle(fontWeight: FontWeight.w800))),
        ]),
        actions: [
          TextButton(
            onPressed: () => setState(() => _hindi = !_hindi),
            child: Text(_hindi ? 'हिंदी' : 'English'),
          ),
        ],
      ),
      body: _tab == 0 ? _home(context, visible) : _settings(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (v) => setState(() => _tab = v),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: _hindi ? 'होम' : 'Home'),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: _hindi ? 'सेटिंग' : 'Settings'),
        ],
      ),
    );
  }

  Widget _home(BuildContext context, List<Feature> visible) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primaryContainer,
              const Color(0xFFE5F4EC),
            ]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_hindi ? 'नमस्ते! स्वस्थ रहें 🌿' : 'Hello! Stay well 🌿',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_hindi
                ? 'आयुर्वेद, पारंपरिक ज्ञान और रोज़मर्रा के वेलनेस टूल एक जगह।'
                : 'Ayurveda, traditional knowledge and everyday wellness tools in one place.'),
            const SizedBox(height: 14),
            Row(children: [
              const Icon(Icons.offline_bolt, size: 18),
              const SizedBox(width: 6),
              Text(_hindi ? 'ऑफलाइन उपयोग • बिना लॉगिन' : 'Offline use • No login',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ]),
          ]),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _search,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: _hindi ? 'फीचर खोजें...' : 'Search features...',
            filled: true, fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        Text(_hindi ? 'आपके वेलनेस टूल' : 'Your wellness tools',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visible.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12,
            childAspectRatio: 1.12,
          ),
          itemBuilder: (context, index) {
            final feature = visible[index];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FeatureScreen(feature: feature, hindi: _hindi),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(feature.icon, color: Theme.of(context).colorScheme.primary, size: 25),
                    ),
                    const SizedBox(height: 12),
                    Text(feature.title(_hindi), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(feature.subtitle(_hindi), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall),
                  ]),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 18),
        const AdBanner(),
        const SizedBox(height: 14),
        Text(_hindi
          ? 'स्वास्थ्य सूचना: यह ऐप सामान्य शैक्षिक जानकारी देता है। यह निदान या इलाज का विकल्प नहीं है।'
          : 'Health note: This app provides general educational information, not diagnosis or treatment.',
          style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _settings(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      Text(_hindi ? 'सेटिंग और गोपनीयता' : 'Settings & privacy',
          style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12),
      Card(child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(_hindi ? 'ऐप की भाषा' : 'App language'),
        subtitle: Text(_hindi ? 'अभी हिंदी' : 'Currently English'),
        trailing: const Icon(Icons.swap_horiz),
        onTap: () => setState(() => _hindi = !_hindi),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.storage),
        title: Text(_hindi ? 'स्थानीय डेटा' : 'Local data'),
        subtitle: Text(_hindi ? 'वेलनेस रिकॉर्ड इसी फोन में सेव होते हैं। ऐप हटाने से डेटा मिट सकता है।' : 'Wellness records stay on this phone. Uninstalling may erase them.'),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.privacy_tip_outlined),
        title: Text(_hindi ? 'विज्ञापन और गोपनीयता' : 'Ads & privacy'),
        subtitle: Text(_hindi ? 'विज्ञापनों के लिए इंटरनेट चाहिए। रिलीज़ से पहले गोपनीयता नीति और सहमति आवश्यकताएँ पूरी करें।' : 'Ads need internet. Complete privacy policy and consent requirements before release.'),
      )),
      Card(child: ListTile(
        leading: const Icon(Icons.health_and_safety_outlined),
        title: Text(_hindi ? 'स्वास्थ्य अस्वीकरण' : 'Health disclaimer'),
        subtitle: Text(_hindi ? 'हर्बल उत्पाद दवाओं से इंटरैक्ट कर सकते हैं। चिकित्सकीय सलाह लें।' : 'Herbs may interact with medicines. Seek qualified medical advice.'),
      )),
    ]);
  }
}
