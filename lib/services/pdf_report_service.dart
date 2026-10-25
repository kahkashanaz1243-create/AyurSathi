import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PdfReportService {
  static Future<void> shareReport({
    required List<Map<String, Object?>> journal,
    required bool hindi,
  }) async {
    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      build: (context) => [
        pw.Text(hindi ? 'AyurSathi - वेलनेस रिपोर्ट' : 'AyurSathi - Wellness Report',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Text('${hindi ? 'रिपोर्ट बनाई गई' : 'Generated'}: ${DateTime.now()}'),
        pw.SizedBox(height: 16),
        if (journal.isEmpty)
          pw.Text(hindi ? 'अभी कोई वेलनेस रिकॉर्ड उपलब्ध नहीं है।' : 'No wellness entries yet.')
        else
          ...journal.map((entry) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(border: pw.Border.all()),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('${entry['created_at'] ?? ''}'),
              pw.Text('${hindi ? 'मूड' : 'Mood'}: ${entry['mood'] ?? ''}  |  '
                  '${hindi ? 'ऊर्जा' : 'Energy'}: ${entry['energy'] ?? ''}/5'),
              pw.Text('${hindi ? 'नींद' : 'Sleep'}: ${entry['sleep_hours'] ?? ''} h'),
              pw.Text('${entry['note'] ?? ''}'),
            ]),
          )),
        pw.SizedBox(height: 16),
        pw.Text(hindi
            ? 'यह उपयोगकर्ता द्वारा दर्ज जानकारी है, चिकित्सकीय रिपोर्ट या निदान नहीं।'
            : 'This is user-entered information, not a medical report or diagnosis.'),
      ],
    ));
    await Printing.sharePdf(bytes: await doc.save(), filename: 'ayursathi_wellness_report.pdf');
  }
}
