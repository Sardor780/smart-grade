import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class RoomAccessManagementScreen extends StatefulWidget {
  final String roomCode;
  const RoomAccessManagementScreen({super.key, required this.roomCode});

  @override
  State<RoomAccessManagementScreen> createState() => _RoomAccessManagementScreenState();
}

class _RoomAccessManagementScreenState extends State<RoomAccessManagementScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _accessSettings = {
    'defaultAttempts': 1,
    'groupAccess': {},
  };
  List<String> _groups = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final doc = await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).get();
      final submissions = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('submissions')
          .get();

      final foundGroups = submissions.docs
          .map((d) => d.data()['studentGroup']?.toString() ?? '')
          .where((g) => g.isNotEmpty)
          .toSet()
          .toList();

      setState(() {
        _accessSettings = doc.data()?['accessSettings'] ?? _accessSettings;
        _groups = foundGroups;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(widget.roomCode).update({
        'accessSettings': _accessSettings,
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.s('save_success'))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetAttempts({String? group}) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(L10n.s('mass_reset')),
        content: Text(group == null 
            ? L10n.s('reset_confirm') 
            : '${L10n.s('reset_group_confirm')} $group?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(L10n.s('cancel'))),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(L10n.s('continue'))),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final query = FirebaseFirestore.instance
          .collection('rooms')
          .doc(widget.roomCode)
          .collection('submissions');
      
      QuerySnapshot snapshot;
      if (group != null) {
        snapshot = await query.where('studentGroup', isEqualTo: group).get();
      } else {
        snapshot = await query.get();
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {'allowRetake': true});
      }
      await batch.commit();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(L10n.s('attempts_reset_success'))));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.s('access_management')),
        actions: [
          IconButton(onPressed: _isLoading ? null : _saveSettings, icon: const Icon(Icons.save_rounded)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(L10n.s('limit_attempts'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          initialValue: _accessSettings['defaultAttempts'],
                          items: [1, 2, 3, 5, 10, 0].map((v) {
                            return DropdownMenuItem(
                              value: v,
                              child: Text(v == 0 ? L10n.s('no_limit') : v.toString()),
                            );
                          }).toList(),
                          onChanged: (v) {
                            setState(() => _accessSettings['defaultAttempts'] = v);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionHeader(title: L10n.s('group_access')),
                ..._groups.map((group) {
                  final hasAccess = _accessSettings['groupAccess']?[group] ?? true;
                  return Card(
                    child: ListTile(
                      title: Text(group),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.history_rounded),
                            tooltip: L10n.s('reset_attempt'),
                            onPressed: () => _resetAttempts(group: group),
                          ),
                          Switch(
                            value: hasAccess,
                            onChanged: (v) {
                              setState(() {
                                final map = Map<String, dynamic>.from(_accessSettings['groupAccess']);
                                map[group] = v;
                                _accessSettings['groupAccess'] = map;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _resetAttempts(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(L10n.s('mass_reset')),
                  style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
