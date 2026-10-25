class GuideItem {
  final String hi, en, descriptionHi, descriptionEn;
  const GuideItem(this.hi, this.en, this.descriptionHi, this.descriptionEn);
}

const mudras = <GuideItem>[
  GuideItem('ज्ञान मुद्रा', 'Gyan Mudra', 'अंगूठे और तर्जनी के सिरों को हल्के से मिलाकर आराम से बैठें।', 'Gently touch the thumb and index fingertips while sitting comfortably.'),
  GuideItem('अंजलि मुद्रा', 'Anjali Mudra', 'हथेलियों को छाती के सामने जोड़ें और कंधों को सहज रखें।', 'Bring palms together at the chest and relax your shoulders.'),
  GuideItem('प्राण मुद्रा', 'Prana Mudra', 'पारंपरिक योग में अनामिका और छोटी उंगली को अंगूठे से मिलाया जाता है।', 'In traditional yoga, touch the ring and little fingertips to the thumb.'),
  GuideItem('ध्यान मुद्रा', 'Dhyana Mudra', 'आराम से बैठकर हाथों को गोद में टिकाएँ और सहज श्वास लें।', 'Sit comfortably, rest hands in the lap, and breathe naturally.'),
];

const plants = <GuideItem>[
  GuideItem('तुलसी', 'Holy Basil (Tulsi)', 'भारत में पारंपरिक रूप से उपयोग किया जाने वाला सुगंधित पौधा। औषधि की तरह उपयोग से पहले विशेषज्ञ से पूछें।', 'An aromatic plant traditionally used in India. Ask a professional before medicinal use.'),
  GuideItem('नीम', 'Neem', 'पारंपरिक उपयोग वाला पेड़। नीम के तेल या अर्क को निगलना जोखिमपूर्ण हो सकता है।', 'A tree with traditional uses. Swallowing neem oil or extracts can be dangerous.'),
  GuideItem('गिलोय', 'Giloy', 'पारंपरिक उपयोग वाला बेलदार पौधा; इससे जुड़े यकृत-सुरक्षा संबंधी मामले रिपोर्ट हुए हैं।', 'A traditionally used vine; liver-safety concerns have been reported.'),
  GuideItem('एलोवेरा', 'Aloe Vera', 'पत्ते में जेल होता है। त्वचा पर लगाने से पहले छोटे हिस्से पर जाँचें; मौखिक उत्पादों में सावधानी रखें।', 'The leaf contains gel. Patch-test topical use; use oral products cautiously.'),
  GuideItem('अश्वगंधा', 'Ashwagandha', 'आयुर्वेद में उपयोग की जाने वाली जड़ी-बूटी; दवाओं से इंटरैक्शन और गर्भावस्था में जोखिम संभव।', 'An herb used in Ayurveda; interactions and pregnancy risks are possible.'),
];

const recipes = <GuideItem>[
  GuideItem('मूंग दाल खिचड़ी', 'Moong Dal Khichdi', 'सामग्री: चावल, मूंग दाल, पानी और पसंद के मसाले। दाल-चावल धोकर पर्याप्त पानी में नरम होने तक पकाएँ।', 'Ingredients: rice, moong dal, water and spices. Rinse and cook with enough water until soft.'),
  GuideItem('सब्ज़ी दलिया', 'Vegetable Dalia', 'सामग्री: दलिया, मौसमी सब्ज़ियाँ, पानी और मसाले। सब्ज़ियाँ भूनकर दलिया और पानी डालें, फिर पकाएँ।', 'Ingredients: broken wheat, seasonal vegetables, water and spices. Sauté vegetables, add dalia and water, then cook.'),
  GuideItem('चना सलाद', 'Chickpea Salad', 'उबले चने, खीरा, टमाटर, नींबू और हरा धनिया मिलाएँ।', 'Mix cooked chickpeas, cucumber, tomato, lemon and coriander.'),
  GuideItem('फल और दही बाउल', 'Fruit and Yogurt Bowl', 'कटे फल और सादा दही मिलाएँ। एलर्जी या विशेष आहार की जरूरतों के अनुसार सामग्री चुनें।', 'Mix chopped fruit and plain yogurt. Choose ingredients for allergies and dietary needs.'),
];

const teas = <GuideItem>[
  GuideItem('अदरक पेय', 'Ginger Infusion', 'ताज़े अदरक के कुछ पतले टुकड़े गर्म पानी में 5–8 मिनट रखें। यह उपचार का विकल्प नहीं है।', 'Steep a few thin slices of fresh ginger in hot water for 5–8 minutes. Not a treatment.'),
  GuideItem('तुलसी पेय', 'Tulsi Infusion', 'धुले तुलसी पत्तों को गर्म पानी में कुछ मिनट रखें। गर्भावस्था या दवा उपयोग में विशेषज्ञ से पूछें।', 'Steep washed tulsi leaves in hot water for a few minutes. Ask a professional during pregnancy or medication use.'),
  GuideItem('नींबू पानी', 'Lemon Water', 'पानी में नींबू का रस मिलाएँ। चाहें तो बिना चीनी रखें।', 'Add lemon juice to water. Leave unsweetened if preferred.'),
  GuideItem('दालचीनी पेय', 'Cinnamon Infusion', 'दालचीनी की छोटी मात्रा गर्म पानी में डालें। अधिक मात्रा या सप्लीमेंट का नियमित उपयोग न करें।', 'Steep a small amount of cinnamon. Avoid high amounts or routine supplement use.'),
];

const unaniTerms = <GuideItem>[
  GuideItem('मिजाज', 'Mizaj (Temperament)', 'यूनानी परंपरा में शरीर या पदार्थ की पारंपरिक प्रकृति/गुणों का वर्णन।', 'A traditional Unani description of temperament or qualities.'),
  GuideItem('तबीयत', 'Tabiyat', 'यूनानी विचार में शरीर की प्राकृतिक कार्यशीलता से जुड़ी अवधारणा।', 'A concept related to the body’s natural functioning in Unani thought.'),
  GuideItem('اخلاط / اخلاط', 'Akhlat (Humours)', 'यूनानी चिकित्सा की ऐतिहासिक अवधारणा; आधुनिक चिकित्सा में इसे जैविक निदान के रूप में नहीं माना जाता।', 'A historical Unani concept; not a modern biomedical diagnosis.'),
  GuideItem('इलाज-बिल-गिज़ा', 'Ilaj-bil-Ghiza', 'आहार के माध्यम से देखभाल की पारंपरिक अवधारणा।', 'The traditional concept of care through diet.'),
];
