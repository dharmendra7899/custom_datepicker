import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayImp {
  late final Function(PaymentFailureResponse response) onPaymentFailed;
  late final Function(PaymentSuccessResponse response) onPaymentSuccess;

  RazorPayImp();

  final Razorpay _razorpay = Razorpay();

  initialize({
    required Function(PaymentFailureResponse response) onPaymentFailed,
    required Function(PaymentSuccessResponse response) onPaymentSuccess,
  }) {
    this.onPaymentFailed = onPaymentFailed;
    this.onPaymentSuccess = onPaymentSuccess;
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      onPaymentFailed(response);
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      onPaymentSuccess(response);
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  void startPayment(
    String orderId,
    String? userMobile,
    String? userEmail,
    String razorPayId,
    BuildContext context,
  ) {
    var options = {
      'key': razorPayId,
      'order_id': orderId,
      'name': 'GIGSAM',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'email': userEmail, 'contact': userMobile},
      'method': {'wallet': '0'},
      'config': {
        'display': {
          'hide': [
            {'method': 'wallet'},
          ],
        },
      },
    };

    if (context.mounted) {
      _razorpay.open(options);
    }
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {}
}
