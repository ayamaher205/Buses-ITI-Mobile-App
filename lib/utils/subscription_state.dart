import 'package:flutter/foundation.dart';
import 'package:bus_iti/services/bus.dart';

class SubscriptionState extends ChangeNotifier {
  final Map<String, String?> _userSubscriptions = {};

  String? getCurrentSubscribedBusId(String userId) {
    return _userSubscriptions[userId];
  }

  bool isSubscribed(String userId, String busId) {
    return _userSubscriptions[userId] == busId;
  }

  Future<void> subscribe(String userId, String busId) async {
    if (_userSubscriptions[userId] != busId) {
      await BusLines().subscribeToBus(busId);
      _userSubscriptions[userId] = busId;
      notifyListeners();
    }
  }

  Future<void> unsubscribe(String userId, String busId) async {
    if (_userSubscriptions[userId] == busId) {
      await BusLines().unsubscribeFromBus(busId);
      _userSubscriptions[userId] = null;
      notifyListeners();
    }
  }
}
