import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/customer.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/api_profile_datasource.dart';
import '../../data/datasources/profile_datasource.dart';
import '../../data/repositories/api_profile_repository.dart';
import '../../domain/repositories/profile_repository.dart';

final currentCustomerProvider = Provider<Customer?>((ref) {
  final authState = ref.watch(authProvider);
  return authState.customer;
});

final profileDatasourceProvider = Provider<ProfileDatasource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiProfileDatasource(dioClient: dioClient);
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final datasource = ref.watch(profileDatasourceProvider);
  return ApiProfileRepository(datasource: datasource);
});

enum ProfileUpdateStatus { idle, loading, success, error }

class ProfileUpdateState {
  const ProfileUpdateState({
    this.status = ProfileUpdateStatus.idle,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  final ProfileUpdateStatus status;
  final String? errorMessage;
  final Map<String, String> fieldErrors;

  bool get isLoading => status == ProfileUpdateStatus.loading;
  bool get hasFieldErrors => fieldErrors.isNotEmpty;
}

final profileUpdateProvider =
    NotifierProvider<ProfileUpdateNotifier, ProfileUpdateState>(
      ProfileUpdateNotifier.new,
    );

class ProfileUpdateNotifier extends Notifier<ProfileUpdateState> {
  @override
  ProfileUpdateState build() => const ProfileUpdateState();

  Future<bool> updateProfile({
    required String firstname,
    required String lastname,
    required String email,
    String? phone,
  }) async {
    state = const ProfileUpdateState(status: ProfileUpdateStatus.loading);

    try {
      final repository = ref.read(profileRepositoryProvider);
      final customer = await repository.updateProfile(
        firstname: firstname,
        lastname: lastname,
        email: email,
        phone: phone,
      );

      ref.read(authProvider.notifier).updateCustomerState(customer);
      state = const ProfileUpdateState(status: ProfileUpdateStatus.success);
      return true;
    } on ApiException catch (e) {
      final fieldErrors = _extractFieldErrors(e);
      state = ProfileUpdateState(
        status: ProfileUpdateStatus.error,
        errorMessage: fieldErrors.isEmpty ? e.message : null,
        fieldErrors: fieldErrors,
      );
      return false;
    } on Exception catch (e) {
      state = ProfileUpdateState(
        status: ProfileUpdateStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  void reset() {
    state = const ProfileUpdateState();
  }

  Map<String, String> _extractFieldErrors(ApiException e) {
    final data = e.data;
    if (data is! Map<String, dynamic>) return {};

    final violations = data['violations'] as List<dynamic>?;
    if (violations == null) return {};

    final errors = <String, String>{};
    for (final violation in violations) {
      if (violation is Map<String, dynamic>) {
        final field = violation['propertyPath'] as String?;
        final message = violation['message'] as String?;
        if (field != null && message != null) {
          errors[field] = message;
        }
      }
    }
    return errors;
  }
}
