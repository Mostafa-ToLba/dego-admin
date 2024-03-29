import 'package:dego_admin/business_logic/http_api.dart';
import 'package:dego_admin/business_logic/setup/provider_setup.dart';
import 'package:flutter/material.dart';

enum NotifierState { busy, idle, error }

class BaseNotifier extends ChangeNotifier {
  NotifierState _state = NotifierState.idle;
  bool _mounted = true;
  final HttpApi api = locator<HttpApi>();


  bool get mounted => _mounted;
  NotifierState get state => _state;
  bool get idle => _state == NotifierState.idle;
  bool get busy => _state == NotifierState.busy;
  bool get hasError => _state == NotifierState.error;

  setBusy() => setState(state: NotifierState.busy);
  setIdle() => setState(state: NotifierState.idle);
  setError() => setState(state: NotifierState.error);

  setState(
      {NotifierState state = NotifierState.idle, bool notifyListener = true}) {
    _state = state;
    if (mounted && notifyListener) notifyListeners();
  }

  @override
  dispose() {
    _mounted = false;
    debugPrint(
        '*************** \n\n -- ${this.runtimeType} Provider Has Disposed -- \n\n***************');
    super.dispose();
  }
}
