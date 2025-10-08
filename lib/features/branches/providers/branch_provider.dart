import 'package:flutter/material.dart';
import '../data/models/laundrette_branch.dart';
import '../../../data/datasources/tenant_branch_remote_data_source.dart';

/// Branch provider for managing laundrette branches
class BranchProvider extends ChangeNotifier {
  final TenantBranchRemoteDataSource _dataSource;
  List<LaundretteBranch> _branches = [];
  bool _isLoading = false;
  String? _error;

  BranchProvider({TenantBranchRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? TenantBranchRemoteDataSource();

  List<LaundretteBranch> get branches => _branches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load branches for a laundrette
  Future<void> loadBranches(String laundretteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _branches = await _dataSource.getBranches();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load branches for a laundrette (old mock implementation)
  Future<void> loadBranchesMock(String laundretteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with real API call
      if (laundretteId == 'laundrette_business_1') {
        _branches = [];
      } else if (laundretteId == 'laundrette_private_1') {
        _branches = [];
      } else {
        _branches = [];
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new branch
  Future<bool> addBranch(LaundretteBranch branch) async {
    try {
      final branchData = {
        'name': branch.name,
        'description': branch.description,
        'address': {
          'address': branch.address,
          'city': branch.city,
          'postcode': branch.postcode,
          'latitude': branch.latitude,
          'longitude': branch.longitude,
        },
        'phone': branch.phone,
        'email': branch.email,
        'services': branch.services,
        'images': branch.images,
      };

      final newBranch = await _dataSource.createBranch(branchData);
      _branches.add(newBranch);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Update branch
  Future<bool> updateBranch(LaundretteBranch updatedBranch) async {
    try {
      final branchData = {
        'name': updatedBranch.name,
        'description': updatedBranch.description,
        'address': {
          'address': updatedBranch.address,
          'city': updatedBranch.city,
          'postcode': updatedBranch.postcode,
          'latitude': updatedBranch.latitude,
          'longitude': updatedBranch.longitude,
        },
        'phone': updatedBranch.phone,
        'email': updatedBranch.email,
        'services': updatedBranch.services,
        'images': updatedBranch.images,
      };

      final updated = await _dataSource.updateBranch(
        updatedBranch.id,
        branchData,
      );
      final index = _branches.indexWhere((b) => b.id == updatedBranch.id);
      if (index != -1) {
        _branches[index] = updated;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Delete branch
  Future<bool> deleteBranch(String branchId) async {
    try {
      final success = await _dataSource.deleteBranch(branchId);
      if (success) {
        _branches.removeWhere((b) => b.id == branchId);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Get branch by ID
  LaundretteBranch? getBranchById(String branchId) {
    try {
      return _branches.firstWhere((b) => b.id == branchId);
    } catch (e) {
      return null;
    }
  }
}
