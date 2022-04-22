// ignore_for_file: use_build_context_synchronously

import 'package:bayad_sms_station/services/payment.dart';
import 'package:bayad_sms_station/util/sms.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

void backgroundMessageHandler(SmsMessage message) {
  final Telephony telephony = Telephony.backgroundInstance;

  final String? senderPhoneNumber = message.address;
  final List<String?> messageResult;
  final String? receiverPhoneNumber;
  final num amount;
  const messageError =
      'Error! In order to send money to another account use this syntax: SEND <space> <AMOUNT> <space> <Receiver Number with Country Code> (Ex. SEND 100 +639123456789)';

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
    } else {
      telephony.sendSms(
        to: senderPhoneNumber!,
        message: messageError,
      );
    }
  } else {
    telephony.sendSms(
      to: senderPhoneNumber!,
      message: messageError,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        smsSendTransaction(message);
      },
      onBackgroundMessage: backgroundMessageHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bayad SMS Station')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Listening to SMS...',
              style: Theme.of(context).textTheme.headline2,
            ),
            ElevatedButton(
              onPressed: () async {
                final bool? permission =
                    await telephony.requestPhoneAndSmsPermissions;

                if (permission!) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permission Accepted')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Permission Denied')),
                  );
                }
              },
              child: Text(
                'Request SMS Permission',
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
