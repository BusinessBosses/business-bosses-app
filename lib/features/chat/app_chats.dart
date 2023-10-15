import 'package:flutter/foundation.dart';

import 'models/last_message.dart';

// ignore: public_member_api_docs
class AppChats with ChangeNotifier {
  List<LastMessage> _myChats = <LastMessage>[];

  List<LastMessage> get myChats {
    _myChats.sort((LastMessage a, LastMessage b) {
      return b.timestamp!.compareTo(a.timestamp as num);
    });
    return <LastMessage>[..._myChats];
  }

  read(String uid) {
    _myChats = _myChats.map((LastMessage element) {
      if (element.user?.uid == uid) {
        element.isRead = false;
        // ignore: always_specify_types
        Map mapData = {
          'isRead': true,
          'text': element.text,
          'deleted': element.deleted,
          'uid': element.uid,
          'deletedBy': element.deletedBy,
          'deletedBySingles': element.deletedBySingles,
          'timestamp': element.timestamp
        };
        final LastMessage updData = LastMessage.toObject(mapData);

        return updData;
      } else {
        return element;
      }
    }).toList();
    notifyListeners();
  }

  // ignore: public_member_api_docs
  void initMyChats(List<LastMessage> mChats) {
    _myChats = mChats;
    notifyListeners();
  }

  // ignore: public_member_api_docs
  void clear() {
    // ignore: always_specify_types
    _myChats = [];
    notifyListeners();
  }
}
