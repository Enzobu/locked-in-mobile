class PaymentIntentResult {
  const PaymentIntentResult({
    required this.clientSecret,
    required this.reservationId,
    required this.amountCents,
    required this.currency,
    required this.status,
  });

  final String clientSecret;
  final int reservationId;
  final int amountCents;
  final String currency;
  final String status;
}
