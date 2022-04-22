import 'package:bayad_sms_station/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

class PaymentService {
  final _db = FirebaseFirestore.instance;
  final telephony = Telephony.instance;

  Future<void> sendMoneyViaSMS({
    required String senderPhoneNumber,
    required String? receiverPhoneNumber,
    required num amount,
    //Information required when sending money via email or phone number
  }) async {
    //Getting the wallet data of user and receiver
    final DocumentReference<Map<String, dynamic>> _receiverWallet;
    final DocumentReference<Map<String, dynamic>> _userWallet;

    final _receiver = await DatabaseService().collectAnotherUserInfo(
      field: 'phoneNumber',
      value: receiverPhoneNumber,
    ) as List<QueryDocumentSnapshot<Map<String, dynamic>>>?;

    final _sender = await DatabaseService().collectAnotherUserInfo(
      field: 'phoneNumber',
      value: senderPhoneNumber,
    ) as List<QueryDocumentSnapshot<Map<String, dynamic>>>?;

    if (_sender == null) {
      sendMessageError(
        senderPhoneNumber,
        'Error! You are not a registered user',
      );
      return;
    }
    if (_receiver == null) {
      sendMessageError(
        senderPhoneNumber,
        'Error! The user you are sending cannot be found',
      );
      return;
    }

    _userWallet = _db
        .collection('users')
        .doc(_sender[0].id)
        .collection('wallets')
        .doc(_sender[0].id);

    _receiverWallet = _db
        .collection('users')
        .doc(_receiver[0].id)
        .collection('wallets')
        .doc(_receiver[0].id);

    try {
      _db.runTransaction((transaction) async {
        final DocumentSnapshot<Map<String, dynamic>> userWallet =
            await transaction.get(_userWallet);
        final DocumentSnapshot<Map<String, dynamic>> receiverWallet =
            await transaction.get(_receiverWallet);

        final num walletBalance = userWallet.data()?['walletBalance'] as num;

        //Checking if user wallet balance is insufficient
        if (walletBalance < amount) {
          sendMessageError(
            senderPhoneNumber,
            'Sorry, Your Balance is insufficient. Currently it is P$walletBalance',
          );
          return;
        }
        //Initiating the transaction
        final num userNewBalance = walletBalance - amount;
        final num receiverAddedBalance =
            (receiverWallet.data()?['walletBalance'] as num) + amount;

        transaction.update(_userWallet, {'walletBalance': userNewBalance});
        transaction
            .update(_receiverWallet, {'walletBalance': receiverAddedBalance});
        telephony.sendSms(
          to: senderPhoneNumber,
          message: 'Successfully sent $amount',
        );
      });
    } on FirebaseException catch (error) {
      sendMessageError(senderPhoneNumber, error.toString());
    } catch (e) {
      debugPrint(e.toString());
      sendMessageError(senderPhoneNumber, e.toString());
    }
  }

  void sendMessageError(String senderPhoneNumber, String error) {
    telephony.sendSms(
      to: senderPhoneNumber,
      message: error,
    );
  }
}
