import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event_bloc/event_bloc.dart';
import '../../bloc/event_bloc/event_event.dart';
import '../../models/event_model.dart';
import '../../utils/notification_utils.dart';
import 'events_management_screen.dart';

class EditEventScreen extends StatefulWidget {
  final Event event;

  const EditEventScreen({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _eventNameController;
  late TextEditingController _eventDateController;
  late TextEditingController _maxBookingController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _eventDateController =
        TextEditingController(text: widget.event.eventDate.toString());
    _maxBookingController =
        TextEditingController(text: widget.event.maxBooking.toString());
    _locationController = TextEditingController(text: widget.event.location);
    _descriptionController =
        TextEditingController(text: widget.event.description);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    _maxBookingController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _eventDateController,
                decoration: const InputDecoration(labelText: 'Event Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maxBookingController,
                decoration: const InputDecoration(labelText: 'Max Booking'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Event Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Event Description'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Update Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(_eventDateController.text);
      } catch (e) {
        // Handle the error if the date format is incorrect
        NotificationUtils.showSnackBar(
            context, 'Invalid date format. Please use YYYY-MM-DD format.',
            isError: true);
        return; // Stop the submission if the date is not valid
      }

      // Using EventBloc to submit the updated data
      BlocProvider.of<EventBloc>(context).add(UpdateEvent(Event(
          id: widget.event.id,
          eventName: _eventNameController.text,
          eventDate: parsedDate,
          location: _locationController.text,
          description: _descriptionController.text,
          maxBooking: int.parse(_maxBookingController.text))));
      Navigator.of(context).pop();
      // Close the modal on success
      NotificationUtils.showSnackBar(context, 'Event updated successfully!',
          isError: false);
    }
  }
}
