abstract class PaymentRepository {
  Future<String?> getPaymentToken();
  Future<String?> createPaymentLink(String token, int amount);
}
