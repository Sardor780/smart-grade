import 'dart:math';
import 'package:flutter/material.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import 'main.dart';

enum ImportedQuestionType { short, trueFalse, mcq }

class ImportedQuestion {
  String text;
  String? answer;
  ImportedQuestionType type;
  List<String> options;
  int correctIndex;
  bool isTrue;

  ImportedQuestion({
    required this.text,
    this.answer,
    this.type = ImportedQuestionType.short,
    List<String>? options,
    this.correctIndex = 0,
    this.isTrue = true,
  }) : options = options ?? List.filled(4, '');

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'type': type.name,
      'answer': answer,
      'options': options,
      'correctIndex': correctIndex,
      'isTrue': isTrue,
    };
  }
}

class BulkImportScreen extends StatefulWidget {
  const BulkImportScreen({super.key});

  @override
  State<BulkImportScreen> createState() => _BulkImportScreenState();
}

class _BulkImportScreenState extends State<BulkImportScreen> {
  final List<ImportedQuestion> _questions = [];
  bool _isLoading = false;
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _sheetsController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    _sheetsController.dispose();
    super.dispose();
  }

  Future<void> _pickExcelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result != null && result.files.first.bytes != null) {
        setState(() => _isLoading = true);
        final bytes = result.files.first.bytes!;
        final excel = Excel.decodeBytes(bytes);
        final List<ImportedQuestion> newQuestions = [];

        for (var table in excel.tables.keys) {
          final sheet = excel.tables[table]!;
          // Skip header row
          for (var i = 1; i < sheet.rows.length; i++) {
            final row = sheet.rows[i];
            if (row.isEmpty || row[0] == null) continue;

            final qText = row[0]?.value?.toString().trim() ?? '';
            if (qText.isEmpty) continue;

            final colB = row.length > 1 ? row[1]?.value?.toString().trim() ?? '' : '';
            final colC = row.length > 2 ? row[2]?.value?.toString().trim() ?? '' : '';
            final extraData = row.map((e) => e?.value?.toString().trim() ?? '').toList();

            newQuestions.add(_detectQuestionType(qText, colB, colC, extraData));
          }
        }
        setState(() => _questions.addAll(newQuestions));
      }
    } catch (e) {
      _showError('Excel error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _importFromSheets() async {
    final url = _sheetsController.text.trim();
    if (url.isEmpty) return;

    final id = _extractSheetId(url);
    if (id == null) {
      _showError(L10n.s('error'));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://docs.google.com/spreadsheets/d/$id/export?format=csv'));

      if (response.statusCode == 200) {
        final csvData = const CsvToListConverter().convert(response.body);
        final List<ImportedQuestion> newQuestions = [];

        for (var i = 1; i < csvData.length; i++) {
          final row = csvData[i];
          if (row.isEmpty || row[0] == null) continue;

          final qText = row[0].toString().trim();
          if (qText.isEmpty) continue;

          final colB = row.length > 1 ? row[1].toString().trim() : '';
          final colC = row.length > 2 ? row[2].toString().trim() : '';
          final extraData = row.map((e) => e.toString().trim()).toList();

          newQuestions.add(_detectQuestionType(qText, colB, colC, extraData));
        }
        setState(() => _questions.addAll(newQuestions));
        _sheetsController.clear();
      } else {
        _showError('Failed to fetch Google Sheet');
      }
    } catch (e) {
      _showError('Sheets error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  ImportedQuestion _detectQuestionType(String qText, String colB, String colC, List<String> row) {
    final lowerB = colB.toLowerCase();
    final tfWords = ['правда', 'ложь', 'true', 'false', 'rost', 'yolg\'on', 'yolgon'];

    // 1. True/False detection
    if (tfWords.contains(lowerB)) {
      return ImportedQuestion(
        text: qText,
        type: ImportedQuestionType.trueFalse,
        isTrue: lowerB == 'правда' || lowerB == 'true' || lowerB == 'rost',
      );
    }

    // 2. MCQ detection (Multiple Choice)
    // If column B contains commas OR if there are more than 3 data columns
    if (colB.contains(',') || row.length > 3) {
      List<String> options = [];
      int correctIdx = 0;

      if (colB.contains(',')) {
        options = colB.split(',').map((e) => e.trim()).toList();
        correctIdx = (int.tryParse(colC) ?? 1) - 1;
      } else {
        // Assume columns B, C, D, E are options and F is correct index
        for (int i = 1; i < min(row.length, 5); i++) {
          final val = row[i];
          if (val.isNotEmpty) options.add(val);
        }
        // Correct index is usually the next cell after options
        final correctCellIndex = options.length + 1;
        final lastCell = row.length > correctCellIndex ? row[correctCellIndex] : null;
        correctIdx = (int.tryParse(lastCell ?? '1') ?? 1) - 1;
      }

      while (options.length < 4) {
        options.add('');
      }

      return ImportedQuestion(
        text: qText,
        type: ImportedQuestionType.mcq,
        options: options.take(4).toList(),
        correctIndex: correctIdx.clamp(0, 3),
      );
    }

    // 3. Default to Short Answer
    return ImportedQuestion(
      text: qText,
      type: ImportedQuestionType.short,
      answer: colB,
    );
  }

  void _parseText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final newQuestions = <ImportedQuestion>[];

    int i = 0;
    while (i < lines.length) {
      final questionText = lines[i].replaceAll(RegExp(r'^\d+[.)\s]+'), '');
      if (i + 1 >= lines.length) break;

      final secondLine = lines[i + 1];
      final lowerB = secondLine.toLowerCase();
      final tfWords = ['правда', 'ложь', 'true', 'false', 'rost', 'yolg\'on', 'yolgon'];

      if (tfWords.contains(lowerB)) {
        newQuestions.add(ImportedQuestion(
          text: questionText,
          type: ImportedQuestionType.trueFalse,
          isTrue: lowerB == 'правда' || lowerB == 'true' || lowerB == 'rost',
        ));
        i += 2;
      } else if (secondLine.contains(',') && i + 2 < lines.length && int.tryParse(lines[i + 2]) != null) {
        final options = secondLine.split(',').map((o) => o.trim()).toList();
        final correctIdx = (int.tryParse(lines[i + 2]) ?? 1) - 1;
        while (options.length < 4) {
        options.add('');
      }
        newQuestions.add(ImportedQuestion(
          text: questionText,
          type: ImportedQuestionType.mcq,
          options: options.take(4).toList(),
          correctIndex: correctIdx.clamp(0, 3),
        ));
        i += 3;
      } else {
        newQuestions.add(ImportedQuestion(
          text: questionText,
          type: ImportedQuestionType.short,
          answer: secondLine,
        ));
        i += 2;
      }
    }

    setState(() {
      _questions.addAll(newQuestions);
      _textController.clear();
    });
  }

  String? _extractSheetId(String url) {
    final regExp = RegExp(r'/d/([^/]+)');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.s('bulk_import')),
        actions: [
          if (_questions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FilledButton.tonal(
                onPressed: () => Navigator.pop(context, _questions),
                child: Text(L10n.s('finish_btn')),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _buildSourceSelection(),
              const Divider(height: 1),
              Expanded(
                child: _questions.isEmpty ? _buildEmptyState() : _buildPreviewList(),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: Card(
                  elevation: 8,
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSourceSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
      child: Row(
        children: [
          Expanded(
            child: _SourceCard(
              icon: Icons.table_chart_rounded,
              label: L10n.s('excel_label'),
              onTap: _pickExcelFile,
              color: Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SourceCard(
              icon: Icons.cloud_download_rounded,
              label: L10n.s('sheets_label'),
              onTap: _showSheetsDialog,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SourceCard(
              icon: Icons.text_fields_rounded,
              label: L10n.s('text_label'),
              onTap: _showTextDialog,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.auto_awesome_motion_rounded, size: 80, color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
          const SizedBox(height: 24),
          Text(
            L10n.s('how_to_import'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          _buildHelpCard(
            title: 'Excel / Google Sheets',
            icon: Icons.table_view_rounded,
            color: Colors.green,
            content: L10n.s('help_excel_desc'),
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            title: L10n.s('bulk_import'),
            icon: Icons.text_snippet_rounded,
            color: Colors.blue,
            content: L10n.s('help_text_desc'),
          ),
          const SizedBox(height: 16),
          _buildHelpCard(
            title: L10n.s('true_false'),
            icon: Icons.flaky_rounded,
            color: Colors.orange,
            content: L10n.s('help_tf_desc'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({required String title, required IconData icon, required String content, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildPreviewList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        final q = _questions[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(q.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildBadge(q.type),
                const SizedBox(height: 8),
                _buildAnswerPreview(q),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: () => setState(() => _questions.removeAt(index)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerPreview(ImportedQuestion q) {
    if (q.type == ImportedQuestionType.short) {
      return Text('${L10n.s('your_answer')}: ${q.answer}', style: const TextStyle(fontSize: 13));
    } else if (q.type == ImportedQuestionType.trueFalse) {
      return Text('${L10n.s('your_answer')}: ${q.isTrue ? L10n.s('true') : L10n.s('false')}', style: const TextStyle(fontSize: 13));
    } else {
      final opts = q.options.where((o) => o.isNotEmpty).toList();
      return Text(
        '${L10n.s('variant')}: ${opts.join(", ")} (${L10n.s('correct_answer')}: ${q.correctIndex + 1})',
        style: const TextStyle(fontSize: 13),
      );
    }
  }

  Widget _buildBadge(ImportedQuestionType type) {
    Color color = Colors.blue;
    String label = 'Short';
    if (type == ImportedQuestionType.trueFalse) {
      color = Colors.orange;
      label = 'T/F';
    } else if (type == ImportedQuestionType.mcq) {
      color = Colors.green;
      label = 'MCQ';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _showTextDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('import_from_text')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: TextField(
          controller: _textController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: L10n.s('text_import_hint'),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(L10n.s('cancel'))),
          FilledButton(
            onPressed: () {
              _parseText();
              Navigator.pop(context);
            },
            child: Text(L10n.s('parse_btn')),
          ),
        ],
      ),
    );
  }

  void _showSheetsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('google_sheets_url')),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(L10n.s('google_sheets_hint'), style: const TextStyle(fontSize: 13, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: _sheetsController,
              decoration: const InputDecoration(
                hintText: 'https://docs.google.com/spreadsheets/d/...',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(L10n.s('cancel'))),
          FilledButton(
            onPressed: () {
              _importFromSheets();
              Navigator.pop(context);
            },
            child: Text(L10n.s('import_btn')),
          ),
        ],
      ),
    );
  }
}

class _SourceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _SourceCard({required this.icon, required this.label, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
