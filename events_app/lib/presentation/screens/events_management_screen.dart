import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event_bloc/event_bloc.dart';
import '../../bloc/event_bloc/event_state.dart';
import '../../bloc/event_bloc/event_event.dart';
import '../../models/event_model.dart';
import 'create_event_screen.dart';
import 'edit_event_screen.dart';

class EventsManagementScreen extends StatefulWidget {
  @override
  _EventsManagementScreenState createState() => _EventsManagementScreenState();
}

class _EventsManagementScreenState extends State<EventsManagementScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EventBloc>(context).add(LoadEvents());
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Reload) {
            BlocProvider.of<EventBloc>(context).add(LoadEvents());
          } else if (state is EventsLoaded) {
            return ListView.builder(
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(event.eventName),
                    subtitle: Text("${event.location} - ${event.eventDate}"),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditEventDialog(context, event),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeletion(context, event.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is EventError) {
            return Center(
                child: Text('Failed to load events: ${state.message}'));
          }
          return Center(child: Text('Unknown state'));
        },
      ),
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
                context.read<EventBloc>().add(DeleteEvent(eventId));
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
