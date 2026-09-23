import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/saved_session_manager.dart';
import '../models/session.dart';
import '../models/saved_step.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../components/scale_button.dart';

class CheckoutPage extends StatefulWidget {
  final SavedSessionManager sessionManager;
  final VoidCallback didUpdate;
  final Function(Session) onSubmit;

  const CheckoutPage({
    super.key,
    required this.sessionManager,
    required this.didUpdate,
    required this.onSubmit,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Set<int> selectedSegment = {0};
  TimeOfDay? selectedTime;
  DateTime? selectedDate;
  final DateTime _firstDate = DateTime(DateTime.now().year - 2);
  final DateTime _lastDate = DateTime(DateTime.now().year + 1);
  final TextEditingController _nameController = TextEditingController();

  void onSegmentSelected(Set<int> segmentIndex) {
    setState(() {
      selectedSegment = segmentIndex;
    });
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'Select Date';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  void _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: _firstDate,
      lastDate: _lastDate,
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  String formatTimeOfDay(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) return 'Select Time';
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: selectedTime ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Widget _buildOrderSegmentedType() {
    return SegmentedButton<int>(
      segments: const [
        ButtonSegment(value: 0, label: Text('Reminder'), icon: Icon(Icons.notifications)),
        ButtonSegment(value: 1, label: Text('No Reminder'), icon: Icon(Icons.notifications_off)),
      ],
      selected: selectedSegment,
      onSelectionChanged: onSegmentSelected,
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Your Name',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

    if (widget.sessionManager.totalSteps == 0) {
      return const Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text('No steps added yet', style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Text(
                'Tap on any step in the tip page to add it',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: ClipRect(
        child: ListView.builder(
          itemCount: widget.sessionManager.totalSteps,
          itemBuilder: (context, index) {
            final step = widget.sessionManager.stepAt(index);
            return Dismissible(
              key: Key(step.id),
              direction: DismissDirection.endToStart,
              background: Container(),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (_) {
                setState(() {
                  widget.sessionManager.removeStep(step.id);
                });
                widget.didUpdate();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${step.title} removed')),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorTheme.primary, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('x${step.quantity}'),
                  ),
                  title: Text(step.title),
                  subtitle: Text('${step.totalMinutes.toInt()} min total'),
                  trailing: const Icon(Icons.delete_outline, color: Colors.grey),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final isEmpty = widget.sessionManager.totalSteps == 0;
    final isReminder = selectedSegment.contains(0);
    final hasDateTime = selectedDate != null && selectedTime != null;
    final canSubmit = !isEmpty && (!isReminder || hasDateTime);
    final totalMinutes = widget.sessionManager.totalFocusTime;

    // Если нельзя отправить, показываем обычную кнопку (без ScaleButton)
    if (!canSubmit) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          isEmpty
              ? 'Add steps to save session'
              : (isReminder && !hasDateTime
              ? 'Select date and time'
              : 'Save Session - ${totalMinutes.toInt()} min'),
        ),
      );
    }

    // Если можно отправить, оборачиваем в ScaleButton
    return ScaleButton(
      onPressed: () {
        const uuid = Uuid();
        final session = Session(
          id: uuid.v4(),
          name: _nameController.text.isEmpty ? 'Anonymous' : _nameController.text,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
          reminderType: selectedSegment.contains(0) ? 0 : 1,
          steps: List.from(widget.sessionManager.savedSteps),
        );
        widget.sessionManager.resetSession();
        widget.onSubmit(session);
        context.go('/${PomoTab.sessions.value}');
        _nameController.clear();
        setState(() {
          selectedDate = null;
          selectedTime = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Session saved!')),
        );
        Navigator.of(context).pop();
      },
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          isEmpty
              ? 'Add steps to save session'
              : (isReminder && !hasDateTime
              ? 'Select date and time'
              : 'Save Session - ${totalMinutes.toInt()} min'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.apply(
      displayColor: Theme.of(context).colorScheme.onSurface,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Order Details', style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildOrderSegmentedType(),
            const SizedBox(height: 16),
            _buildTextField(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(formatDate(selectedDate)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _selectTime(context),
                    child: Text(formatTimeOfDay(selectedTime)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Session Steps', style: TextStyle(fontWeight: FontWeight.bold)),
            _buildOrderSummary(context),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }
}