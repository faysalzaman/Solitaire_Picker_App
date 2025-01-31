import 'package:solitaire_picker/model/journey_model.dart';

class JourneyState {}

class JourneyInitial extends JourneyState {}

class JourneyLoading extends JourneyState {}

class JourneyLoaded extends JourneyState {
  final JourneyModel journey;

  JourneyLoaded(this.journey);
}

class JourneyError extends JourneyState {
  final String message;

  JourneyError(this.message);
}

class JourneyEnded extends JourneyState {
  final JourneyModel journey;

  JourneyEnded(this.journey);
}

class JourneyEndingError extends JourneyState {
  final String message;

  JourneyEndingError(this.message);
}

class StoreEntry extends JourneyState {
  final StoreVisits storeVisits;

  StoreEntry(this.storeVisits);
}

class StoreEntryError extends JourneyState {
  final String message;

  StoreEntryError(this.message);
}

class StoreExit extends JourneyState {
  final StoreVisits storeVisits;

  StoreExit(this.storeVisits);
}

class StoreExitError extends JourneyState {
  final String message;

  StoreExitError(this.message);
}
