import 'package:bayad_sms_station/services/payment.dart';
import 'package:telephony/telephony.dart';

void smsSendTransaction(SmsMessage message) {
  final Telephony telephony = Telephony.instance;
  const messageError =
      'Error! In order to send money to another account use this syntax: SEND <space> <AMOUNT> <space> <Receiver Number with Country Code> (Ex. SEND 100 +639123456789)';
  final String? senderPhoneNumber = message.address;
  final List<String?> messageResult;
  final String? receiverPhoneNumber;
  final num amount;

  if (message.body!.contains('SEND')) {
    messageResult = message.body!.split(' ').toList();
    if (messageResult.length == 3) {
      receiverPhoneNumber = messageResult[2];
      amount = num.parse(messageResult[1]!);

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
      telephony.sendSms(to: senderPhoneNumber!, message: messageError);
    }
  } else {
    telephony.sendSms(
      to: senderPhoneNumber!,
      message: messageError,
    );
  }
}
