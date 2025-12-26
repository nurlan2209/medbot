import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/network/api_client.dart';
import 'package:med_bot/features/profile/saved_items_models.dart';
import 'package:share_plus/share_plus.dart';

class SavedItemsScreen extends StatefulWidget {
  const SavedItemsScreen({super.key});

  @override
  State<SavedItemsScreen> createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  bool _loading = true;
  List<SavedItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await ApiClient.getJson('/api/saved');
      final list = (data as List).whereType<Map<String, dynamic>>().toList();
      setState(() {
        _items = list.map(SavedItem.fromJson).toList();
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _delete(String id) async {
    await ApiClient.deleteJson('/api/saved/$id');
    setState(() => _items = _items.where((i) => i.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, y • HH:mm');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(context.l10n.savedItemsTitle),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? Center(
                    child: Text(
                      context.l10n.noSavedItems,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: ValueKey(item.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            final ok = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(context.l10n.deleteSavedItem),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text(context.l10n.cancel)),
                                  TextButton(onPressed: () => Navigator.pop(context, true), child: Text(context.l10n.delete)),
                                ],
                              ),
                            );
                            return ok ?? false;
                          },
                          onDismissed: (_) async {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              await _delete(item.id);
                            } catch (e) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
                              );
                              _load();
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: AppColors.danger,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => _SavedItemDetailScreen(item: item),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title, style: Theme.of(context).textTheme.bodyMedium),
                                  const SizedBox(height: 6),
                                  Text(
                                    item.content,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayLight),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          df.format(item.createdAt.toLocal()),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.grayLight),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => Share.share(item.content, subject: item.title),
                                        icon: const Icon(Icons.share_outlined, size: 18, color: AppColors.grayLight),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class _SavedItemDetailScreen extends StatelessWidget {
  final SavedItem item;
  const _SavedItemDetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('MMM d, y • HH:mm');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        title: Text(context.l10n.savedItem),
        actions: [
          IconButton(
            onPressed: () => Share.share(item.content, subject: item.title),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(item.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Text(df.format(item.createdAt.toLocal()), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(item.content, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.grayDark)),
            ),
          ],
        ),
      ),
    );
  }
}
