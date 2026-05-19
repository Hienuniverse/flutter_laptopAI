import '../services/ai_service.dart';

class AiRepository {
  AiRepository(this._service);
  final AiService _service;

  Future<dynamic> sendMessage(String message) => _service.sendMessage(message);
  Future<dynamic> getBenchmark(String laptopId) =>
      _service.getBenchmark(laptopId);
}
