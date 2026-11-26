import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/habits_provider.dart';
import '../../../habits/domain/entities/habit_entity.dart';

// Same icon map as AddHabitScreen — shared visuals
const _kEditColors = [
  0xFF22C55E, 0xFF6366F1, 0xFF06B6D4, 0xFFF59E0B,
  0xFFEF4444, 0xFFF97316, 0xFFEC4899, 0xFF8B5CF6,
];

const _kEditIcons = <String, IconData>{
  'check_circle': Icons.check_circle_outline_rounded,
  'fitness': Icons.fitness_center_rounded,
  'book': Icons.menu_book_rounded,
  'water': Icons.water_drop_outlined,
  'bed': Icons.bedtime_outlined,
  'run': Icons.directions_run_rounded,
  'meditate': Icons.self_improvement_rounded,
  'food': Icons.restaurant_outlined,
  'code': Icons.code_rounded,
  'music': Icons.music_note_rounded,
};

/// Screen for editing an existing habit.
class EditHabitScreen extends StatefulWidget {
  const EditHabitScreen({super.key, required this.habit});
  final HabitEntity habit;

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  late int _selectedColor;
  late String _selectedIcon;
  late String _selectedFrequency;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _descController =
        TextEditingController(text: widget.habit.description ?? '');
    _selectedColor = widget.habit.color;
    _selectedIcon = widget.habit.icon;
    _selectedFrequency = widget.habit.frequency;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final updated = widget.habit.copyWith(
        name: _nameController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        color: _selectedColor,
        icon: _selectedIcon,
        frequency: _selectedFrequency,
        updatedAt: DateTime.now(),
      );
      await context.read<HabitsProvider>().updateHabit(updated);
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: Text('Delete Habit',
            style: GoogleFonts.plusJakartaSans(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: Text(
          'Are you sure you want to delete "${widget.habit.name}"? This cannot be undone.',
          style:
              GoogleFonts.plusJakartaSans(color: const Color(0xFF94A3B8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF94A3B8))),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text('Delete',
                style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFFEF4444),
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<HabitsProvider>().deleteHabit(widget.habit.id);
      if (mounted) Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F17),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Habit',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFFEF4444)),
            onPressed: _confirmDelete,
            tooltip: 'Delete Habit',
          ),
          // Save button
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF6366F1)),
                  )
                : Text(
                    'Save',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF6366F1),
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview chip
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(_selectedColor).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Color(_selectedColor).withValues(alpha: 0.5),
                        width: 2),
                  ),
                  child: Icon(
                    _kEditIcons[_selectedIcon] ??
                        Icons.check_circle_outline_rounded,
                    color: Color(_selectedColor),
                    size: 36,
                  ),
                ).animate().scale(duration: 200.ms),
              ),

              const SizedBox(height: 32),

              _sectionLabel('Habit Name'),
              const SizedBox(height: 8),
              _glassField(
                controller: _nameController,
                hint: 'e.g. Morning Run',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),

              const SizedBox(height: 20),

              _sectionLabel('Description (optional)'),
              const SizedBox(height: 8),
              _glassField(
                  controller: _descController,
                  hint: 'What is this habit about?',
                  maxLines: 3),

              const SizedBox(height: 24),

              _sectionLabel('Frequency'),
              const SizedBox(height: 10),
              Row(
                children: ['daily', 'weekly'].map((f) {
                  final selected = _selectedFrequency == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFrequency = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFF6366F1).withValues(alpha: 0.2)
                              : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF6366F1)
                                : const Color(0xFF334155),
                          ),
                        ),
                        child: Text(
                          f[0].toUpperCase() + f.substring(1),
                          style: GoogleFonts.plusJakartaSans(
                            color: selected
                                ? const Color(0xFF818CF8)
                                : const Color(0xFF94A3B8),
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _sectionLabel('Color'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _kEditColors.map((c) {
                  final selected = _selectedColor == c;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: Color(c).withValues(alpha: 0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: selected
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              _sectionLabel('Icon'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _kEditIcons.entries.map((e) {
                  final selected = _selectedIcon == e.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = e.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: selected
                            ? Color(_selectedColor).withValues(alpha: 0.2)
                            : const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? Color(_selectedColor)
                              : const Color(0xFF334155),
                        ),
                      ),
                      child: Icon(
                        e.value,
                        color: selected
                            ? Color(_selectedColor)
                            : const Color(0xFF64748B),
                        size: 24,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF94A3B8),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      );

  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF475569), fontSize: 15),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF334155)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF6366F1), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
}
