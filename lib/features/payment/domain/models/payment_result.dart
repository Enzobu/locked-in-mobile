enum PaymentStatus { success, failed, cancelled }

class PaymentResult {
  const PaymentResult({
    required this.status,
    required this.transactionId,
    this.errorMessage,
  });

  final PaymentStatus status;
  final String transactionId;
  final String? errorMessage;

  bool get isSuccess => status == PaymentStatus.success;
}
