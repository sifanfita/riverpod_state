// Event Events
import '../../models/event_model.dart';

abstract class EventEvent {}

class LoadEvents extends EventEvent {}

class UpdateEvent extends EventEvent {
  final Event event;
  UpdateEvent(this.event);
}

class DeleteEvent extends EventEvent {
  final int eventId;
  DeleteEvent(this.eventId);
}
