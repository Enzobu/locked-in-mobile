enum PaymentSheetStatus { success, failed, cancelled }

class PaymentSheetResult {
  const PaymentSheetResult({required this.status, this.errorMessage});

  final PaymentSheetStatus status;
  final String? errorMessage;

  bool get isSuccess => status == PaymentSheetStatus.success;
}
