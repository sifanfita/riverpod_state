import 'package:flutter/material.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          'Add a New Event',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            const SizedBox(height: 16.0),
            const Text(
              'Add a New Event',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Name',
                hintText: 'Event Title Here',
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Event Date',
                      hintText: 'mm/dd/yyyy',
                      hintFadeDuration: Duration(seconds: 1),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max Booking',
                      hintText: '100',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Location',
                // hintText: 'Event Location Here',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Description',
                // hintText: 'Event Description',
              ),
              maxLines: 4,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Perform some action when the form is submitted
                  print("Form Submited");
                  Navigator.pop(context);
                  // message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Event Added'),
                    ),
                  );
                },
                child: const Text('Add Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
