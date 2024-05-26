import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/event_bloc/event_bloc.dart';
import '../../bloc/event_bloc/event_event.dart';
import '../../bloc/event_bloc/event_state.dart';
import '../widgets/event_card.dart';
import '../screens/my_account_screen.dart';
import '../screens/my_bookings_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _selectedIndex = 0; // Default index for the first tab

  // Dynamic switching of screens
  Widget _currentScreen() {
    switch (_selectedIndex) {
      case 0: // Events
        return BlocProvider(
          create: (_) => EventBloc()..add(LoadEvents()),
          child: BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              if (state is EventLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EventsLoaded) {
                return ListView.builder(
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    return EventCard(event: state.events[index]);
                  },
                );
              } else {
                return const Center(child: Text('Failed to load events'));
              }
            },
          ),
        );
      case 1: // My Account
        return MyAccountScreen();
      case 2: // My Bookings
        return MyBookingsScreen();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upcoming Events')),
      body: _currentScreen(), // Update the body to display the current screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_online),
            label: 'My Bookings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
