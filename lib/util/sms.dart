import 'package:bayad_sms_station/services/payment.dart';
import 'package:telephony/telephony.dart';

void smsSendTransaction(SmsMessage message) {
  final Telephony telephony = Telephony.instance;

  final String? senderPhoneNumber = message.address;
  final List<String?> messageResult;
  final String? receiverPhoneNumber;
  final num amount;

  if (message.body!.contains('PAY')) {
    messageResult = message.body!.split(' ').toList();
    if (messageResult.length == 3) {
      receiverPhoneNumber = messageResult[1];
      amount = num.parse(messageResult[2]!);

      PaymentService().sendMoneyViaSMS(
        senderPhoneNumber: senderPhoneNumber!,
        receiverPhoneNumber: receiverPhoneNumber,
        amount: amount,
      );

      telephony.sendSms(
        to: senderPhoneNumber,
        message: '${message.address} $receiverPhoneNumber $amount',
      );
    } else {
      telephony.sendSms(
        to: senderPhoneNumber!,
        message:
            'Error! In order to send money to another account use this syntax: PAY <space> <Receiver Number> <Amount>',
      );
    }
  } else {
    telephony.sendSms(
      to: senderPhoneNumber!,
      message:
          'Error! In order to send money to another account use this syntax: PAY <space> <Receiver Number> <Amount>',
    );
  }
}
