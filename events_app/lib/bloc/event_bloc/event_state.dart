import '../../models/event_model.dart';

// Event States
abstract class EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventError extends EventState {
  final String message; // Include error message
  EventError(this.message);
}

class Reload extends EventState {}
