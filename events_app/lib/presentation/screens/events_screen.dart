import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../screens/my_account_screen.dart';
import '../screens/my_bookings_screen.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  int _selectedIndex = 0; // Default index for the first tab

  @override
  void initState() {
    super.initState();
    // Load events when the screen is first loaded
    ref.read(eventProvider.notifier).loadEvents();
  }

  // Dynamic switching of screens
  Widget _currentScreen() {
    switch (_selectedIndex) {
      case 0: // Events
        final eventState = ref.watch(eventProvider);
        return eventState is EventLoading
            ? const Center(child: CircularProgressIndicator())
            : eventState is EventsLoaded
                ? ListView.builder(
                    itemCount: eventState.events.length,
                    itemBuilder: (context, index) {
                      return EventCard(event: eventState.events[index]);
                    },
                  )
                : const Center(child: Text('Failed to load events'));
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
