import 'package:flutter/material.dart';
import 'package:med_bot/app/design/app_colors.dart';
import 'package:med_bot/app/localization/l10n_ext.dart';
import 'package:med_bot/app/widgets/primary_button.dart';
import 'package:med_bot/app/widgets/text_input.dart';
import 'package:med_bot/features/medical/medical_card_models.dart';

class MedicalCardEditScreen extends StatefulWidget {
  final MedicalCard initial;
  const MedicalCardEditScreen({super.key, required this.initial});

  @override
  State<MedicalCardEditScreen> createState() => _MedicalCardEditScreenState();
}

class _MedicalCardEditScreenState extends State<MedicalCardEditScreen> {
  late final TextEditingController _name;
  late final TextEditingController _dob;
  late final TextEditingController _blood;
  late final TextEditingController _height;
  late final TextEditingController _weight;

  late List<String> _conditions;
  late List<Allergy> _allergies;
  late List<Medication> _medications;
  late List<MedicalDocument> _documents;

  @override
  void initState() {
    super.initState();
    final p = widget.initial.personalInfo;
    _name = TextEditingController(text: p.name);
    _dob = TextEditingController(text: p.dateOfBirth);
    _blood = TextEditingController(text: p.bloodType);
    _height = TextEditingController(text: p.height);
    _weight = TextEditingController(text: p.weight);
    _conditions = [...widget.initial.chronicConditions];
    _allergies = [...widget.initial.allergies];
    _medications = [...widget.initial.currentMedications];
    _documents = [...widget.initial.documents];
  }

  @override
  void dispose() {
    _name.dispose();
    _dob.dispose();
    _blood.dispose();
    _height.dispose();
    _weight.dispose();
    super.dispose();
  }

  MedicalCard _buildCard() {
    return MedicalCard(
      personalInfo: PersonalInfo(
        name: _name.text.trim(),
        dateOfBirth: _dob.text.trim(),
        bloodType: _blood.text.trim(),
        height: _height.text.trim(),
        weight: _weight.text.trim(),
      ),
      chronicConditions: _conditions.where((e) => e.trim().isNotEmpty).toList(),
      allergies: _allergies.where((e) => e.name.trim().isNotEmpty).toList(),
      currentMedications: _medications
          .where((e) => e.name.trim().isNotEmpty)
          .toList(),
      documents: _documents.where((e) => e.name.trim().isNotEmpty).toList(),
    );
  }

  Future<void> _addCondition() async {
    final controller = TextEditingController();
    final value = await _prompt(
      context,
      title: context.l10n.addCondition,
      controller: controller,
    );
    if (value == null) return;
    setState(() => _conditions.add(value));
  }

  Future<void> _addAllergy() async {
    final name = TextEditingController();
    final severity = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addAllergy),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: context.l10n.nameLabel,
              controller: name,
              hintText: 'Penicillin',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.severityLabel,
              controller: severity,
              hintText: 'High',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(
      () => _allergies.add(
        Allergy(name: name.text.trim(), severity: severity.text.trim()),
      ),
    );
  }

  Future<void> _addMedication() async {
    final name = TextEditingController();
    final dosage = TextEditingController();
    final frequency = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addMedication),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: context.l10n.nameLabel,
              controller: name,
              hintText: 'Metformin',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.dosageLabel,
              controller: dosage,
              hintText: '500mg',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.frequencyLabel,
              controller: frequency,
              hintText: 'Twice daily',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(
      () => _medications.add(
        Medication(
          name: name.text.trim(),
          dosage: dosage.text.trim(),
          frequency: frequency.text.trim(),
        ),
      ),
    );
  }

  Future<void> _addDocument() async {
    final name = TextEditingController();
    final date = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.addDocument),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextInput(
              label: context.l10n.nameLabel,
              controller: name,
              hintText: 'Blood Test Results',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.dateLabel,
              controller: date,
              hintText: 'Dec 10, 2025',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(
      () => _documents.add(
        MedicalDocument(name: name.text.trim(), date: date.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(context.l10n.editMedicalCard),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextInput(
              label: context.l10n.nameLabel,
              controller: _name,
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.dobLabel,
              controller: _dob,
              hintText: 'January 15, 1985',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.bloodTypeLabel,
              controller: _blood,
              hintText: 'A+',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.heightLabel,
              controller: _height,
              hintText: '175 cm',
            ),
            const SizedBox(height: 12),
            TextInput(
              label: context.l10n.weightLabel,
              controller: _weight,
              hintText: '70 kg',
            ),
            const SizedBox(height: 20),
            _listSection(
              context,
              title: context.l10n.chronicConditions,
              addLabel: context.l10n.addCondition,
              onAdd: _addCondition,
              children: List.generate(
                _conditions.length,
                (i) => _pill(
                  _conditions[i],
                  () => setState(() => _conditions.removeAt(i)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _listSection(
              context,
              title: context.l10n.allergiesCritical,
              addLabel: context.l10n.addAllergy,
              onAdd: _addAllergy,
              children: List.generate(
                _allergies.length,
                (i) => _pill(
                  '${_allergies[i].name}${_allergies[i].severity.isEmpty ? '' : ' (${_allergies[i].severity})'}',
                  () => setState(() => _allergies.removeAt(i)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _listSection(
              context,
              title: context.l10n.currentMedications,
              addLabel: context.l10n.addMedication,
              onAdd: _addMedication,
              children: List.generate(
                _medications.length,
                (i) => _pill(
                  '${_medications[i].name}${_medications[i].dosage.isEmpty ? '' : ' ${_medications[i].dosage}'}${_medications[i].frequency.isEmpty ? '' : ' • ${_medications[i].frequency}'}',
                  () => setState(() => _medications.removeAt(i)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _listSection(
              context,
              title: context.l10n.medicalDocuments,
              addLabel: context.l10n.addDocument,
              onAdd: _addDocument,
              children: List.generate(
                _documents.length,
                (i) => _pill(
                  '${_documents[i].name}${_documents[i].date.isEmpty ? '' : ' • ${_documents[i].date}'}',
                  () => setState(() => _documents.removeAt(i)),
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              fullWidth: true,
              onPressed: () => Navigator.pop(context, _buildCard()),
              child: Text(context.l10n.save),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.medicalCardEditHint,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.grayLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _listSection(
    BuildContext context, {
    required String title,
    required String addLabel,
    required VoidCallback onAdd,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              TextButton(onPressed: onAdd, child: Text(addLabel)),
            ],
          ),
          if (children.isEmpty)
            Text(
              context.l10n.none,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.grayLight),
            )
          else
            Wrap(spacing: 8, runSpacing: 8, children: children),
        ],
      ),
    );
  }

  Widget _pill(String text, VoidCallback onRemove) {
    return InkWell(
      onTap: onRemove,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            const SizedBox(width: 6),
            const Icon(Icons.close, size: 16, color: AppColors.grayLight),
          ],
        ),
      ),
    );
  }
}

Future<String?> _prompt(
  BuildContext context, {
  required String title,
  required TextEditingController controller,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.save),
        ),
      ],
    ),
  );
  if (ok != true) return null;
  final value = controller.text.trim();
  return value.isEmpty ? null : value;
}
