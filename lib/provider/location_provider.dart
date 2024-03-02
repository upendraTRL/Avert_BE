import 'package:flutter/widgets.dart';

class LocationProvider extends ChangeNotifier {
  String value;
  LocationProvider({
    this.value = 'Loading...',
  });

  void updatedPrevPrec(String prev) {
    value = prev;
    notifyListeners();
  }

  void changeToMumbai() {
    value = 'Mumbai';

    notifyListeners();
  }
}
