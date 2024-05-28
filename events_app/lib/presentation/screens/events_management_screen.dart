import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event_provider.dart';
import '../../models/event_model.dart';
import 'create_event_screen.dart';
import 'edit_event_screen.dart';

class EventsManagementScreen extends ConsumerStatefulWidget {
  @override
  _EventsManagementScreenState createState() => _EventsManagementScreenState();
}

class _EventsManagementScreenState
    extends ConsumerState<EventsManagementScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(eventProvider.notifier).loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Events"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showCreateEventDialog(context),
          ),
        ],
      ),
      body: eventState is EventLoading
          ? Center(child: CircularProgressIndicator())
          : eventState is EventsLoaded
              ? ListView.builder(
                  itemCount: eventState.events.length,
                  itemBuilder: (context, index) {
                    final event = eventState.events[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(event.eventName),
                        subtitle:
                            Text("${event.location} - ${event.eventDate}"),
                        trailing: Wrap(
                          spacing: 12, // space between two icons
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showEditEventDialog(context, event),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _confirmDeletion(context, event.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : eventState is EventError
                  ? Center(
                      child:
                          Text('Failed to load events: ${eventState.message}'))
                  : Center(child: Text('Unknown state')),
    );
  }

  void _showCreateEventDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CreateEventScreen(),
        );
      },
    );
  }

  void _showEditEventDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: EditEventScreen(event: event),
        );
      },
    );
  }

  void _confirmDeletion(BuildContext context, int eventId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref.read(eventProvider.notifier).deleteEvent(eventId);
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
