// This file is part of Bayad Matthew.

// Bayad Matthew is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// any later version.
// Bayad Matthew is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// You should have received a copy of the GNU General Public License
// along with Bayad Matthew.  If not, see <https://www.gnu.org/licenses/>.

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //This service collects the other user's info given by the user's phone number or email address
  Future<List<QueryDocumentSnapshot>?> collectAnotherUserInfo({
    required String field,
    required dynamic value,
  }) {
    return _db
        .collection('users')
        .where(field, isEqualTo: value)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return null;
      }
    });
  }

  Future<Map<String, dynamic>?>? collectAnotherUserInfoViaUID(String? uid) {
    if (uid == null) {
      return null;
    }

    return _db
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data()! as Map<String, dynamic>;
      } else {
        return null;
      }
    });
  }
}
