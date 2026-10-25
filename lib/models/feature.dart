import 'package:flutter/material.dart';

class Feature {
  final int id;
  final String titleHi;
  final String titleEn;
  final String subtitleHi;
  final String subtitleEn;
  final IconData icon;
  const Feature(this.id, this.titleHi, this.titleEn, this.subtitleHi,
      this.subtitleEn, this.icon);

  String title(bool hindi) => hindi ? titleHi : titleEn;
  String subtitle(bool hindi) => hindi ? subtitleHi : subtitleEn;
}

const features = <Feature>[
  Feature(1, 'दैनिक दिनचर्या', 'Daily Routine', 'आदतों की चेकलिस्ट', 'Habit checklist', Icons.checklist_rounded),
  Feature(2, 'योग मुद्राएँ', 'Yoga Mudra Guide', 'मुद्राएँ और अभ्यास', 'Mudras and practice', Icons.self_improvement_rounded),
  Feature(3, 'औषधीय पौधे', 'Herbal Plant Guide', 'पौधों की जानकारी', 'Plant information', Icons.local_florist_rounded),
  Feature(4, 'हेल्दी रेसिपी', 'Healthy Recipe Book', 'स्वस्थ भोजन के विचार', 'Healthy meal ideas', Icons.restaurant_menu_rounded),
  Feature(5, 'हर्बल पेय', 'Herbal Tea Recipes', 'पेय बनाने की विधियाँ', 'Herbal drink recipes', Icons.emoji_food_beverage_rounded),
  Feature(6, 'यूनानी शब्दावली', 'Unani Terms Guide', 'सरल शब्द और अर्थ', 'Terms and meanings', Icons.menu_book_rounded),
  Feature(7, 'प्रकृति प्रश्नावली', 'Prakriti Questionnaire', 'पारंपरिक स्व-मूल्यांकन', 'Traditional self-reflection', Icons.quiz_rounded),
  Feature(8, 'वेलनेस डायरी', 'Wellness Journal', 'मूड, ऊर्जा और नोट्स', 'Mood, energy and notes', Icons.edit_note_rounded),
  Feature(9, 'आई ब्रेक', 'Eye Break Reminder', 'स्क्रीन से विराम', 'Screen break timer', Icons.remove_red_eye_rounded),
  Feature(10, 'PDF स्वास्थ्य रिपोर्ट', 'Health Report PDF', 'रिकॉर्ड की रिपोर्ट बनाएँ', 'Create a record report', Icons.picture_as_pdf_rounded),
];
