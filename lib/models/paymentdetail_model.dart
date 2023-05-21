class PaymentDetailsModel {
  String name;
  int cardNumber;
  int expiryDate;
  int cvv;

  PaymentDetailsModel({
    required this.name,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });
}
