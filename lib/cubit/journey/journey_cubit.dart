import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solitaire_picker/controller/journey/journey_controller.dart';
import 'package:solitaire_picker/cubit/journey/journey_state.dart';
import 'package:solitaire_picker/utils/network_connectivity.dart';

class JourneyCubit extends Cubit<JourneyState> {
  JourneyCubit() : super(JourneyInitial());

  final JourneyController _journeyController = JourneyController();

  Future<void> startJourney(String customerId) async {
    emit(JourneyLoading());

    try {
      // check internet connection
      final isConnected = await NetworkConnectivity.instance.checkInternet();
      if (!isConnected) {
        emit(JourneyError("No internet connection"));
        return;
      }

      final journey = await _journeyController.createJourney(customerId);
      emit(JourneyLoaded(journey));
    } catch (e) {
      print(e);
      emit(JourneyError(e.toString()));
    }
  }

  Future<void> endJourney(String journeyId) async {
    emit(JourneyLoading());

    try {
      // check internet connection
      final isConnected = await NetworkConnectivity.instance.checkInternet();
      if (!isConnected) {
        emit(JourneyEndingError("No internet connection"));
        return;
      }

      final journey = await _journeyController.endJourney(journeyId);
      emit(JourneyEnded(journey));
    } catch (e) {
      print(e);
      emit(JourneyEndingError(e.toString()));
    }
  }

  Future<void> storeEntry(
      String journeyId, String storeId, String scanType) async {
    emit(JourneyLoading());

    try {
      // check internet connection
      final isConnected = await NetworkConnectivity.instance.checkInternet();
      if (!isConnected) {
        emit(StoreEntryError("No internet connection"));
        return;
      }

      final storeVisits =
          await _journeyController.storeEntry(journeyId, storeId, scanType);
      emit(StoreEntry(storeVisits));
    } catch (e) {
      print(e);
      emit(StoreEntryError(e.toString()));
    }
  }

  Future<void> storeExit(String journeyId, String storeId) async {
    emit(JourneyLoading());

    try {
      // check internet connection
      final isConnected = await NetworkConnectivity.instance.checkInternet();
      if (!isConnected) {
        emit(StoreExitError("No internet connection"));
        return;
      }

      final storeVisits =
          await _journeyController.storeExit(journeyId, storeId);
      emit(StoreExit(storeVisits));
    } catch (e) {
      print(e);
      emit(StoreExitError(e.toString()));
    }
  }
}
