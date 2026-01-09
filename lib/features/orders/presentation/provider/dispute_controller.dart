import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/dispute_model.dart';
import '../../data/datasources/dispute_datasource.dart';

class DisputeController extends ChangeNotifier {
  final DisputeDatasource datasource;

  DisputeController({required this.datasource});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Dispute? _currentDispute;
  Dispute? get currentDispute => _currentDispute;

  List<Dispute> _disputes = [];
  List<Dispute> get disputes => _disputes;

  Future<bool> createDispute({
    required int orderId,
    required String description,
    List<XFile>? photos,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dispute = await datasource.createDispute(
        orderId: orderId,
        description: description,
        photos: photos,
      );

      _currentDispute = dispute;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchDisputeByOrderId(int orderId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dispute = await datasource.getDisputeByOrderId(orderId);
      _currentDispute = dispute;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _currentDispute = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDisputeById(int disputeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final dispute = await datasource.getDisputeById(disputeId);
      _currentDispute = dispute;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _currentDispute = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllDisputes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final disputes = await datasource.getCustomerDisputes();
      _disputes = disputes;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _disputes = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearCurrentDispute() {
    _currentDispute = null;
    notifyListeners();
  }
}
