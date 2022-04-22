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
