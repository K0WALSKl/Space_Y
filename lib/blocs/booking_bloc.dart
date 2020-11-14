import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:space_y/models/tickets_model.dart';
import 'package:space_y/providers/repository.dart';

class MenuItem {
  MenuItem(String title, bool isActive) {
    _title = title;
    _isActive = isActive;
  }

  String _title;
  void setTitle(String value) => _title = value;
  String get title => _title;

  bool _isActive;
  bool get isActive => _isActive;
  void setIsActive(bool value) => _isActive = value;

}

class Booking extends Validators {
  Repository repository = Repository();

  Future<String> sendBooking({bool massage, bool meal, bool pool}) async {

    String res;
    final DateTime kNowPlusTenDays = DateTime.now().add(const Duration(days: 10));

    res = await submitBooking(kNowPlusTenDays.toString(), massage, meal, pool);
    return res;
  }

  Future<String> submitBooking(String date, bool massage, bool meal, bool pool) async {
    final String kRes = await repository.booking(date, massage, meal, pool);
    if (kRes != null) {
      print('booking sent');
      return kRes;
    } else {
      print('error: booking');
    }
    return kRes;
  }

  final PublishSubject<Tickets> kTickets = PublishSubject<Tickets>();
  Stream<Tickets> get allTickets => kTickets.stream;

  Future<Tickets> getUserTickets() async {
    final Tickets res = await repository.getBookedTickets();
    return res;
  }

  final List<MenuItem> bookingMenuButtons = <MenuItem>[
    MenuItem('Get free Ticket', true),
    MenuItem('My Tickets', false)
  ];

  // final List<dynamic> bookingMenuButtons = <dynamic>[
  //   <dynamic> ['Get free Ticket', true],
  //   <dynamic> ['', false]
  // ];

  final PublishSubject<List<dynamic>> _changeBookingSection = PublishSubject<List<MenuItem>>();
  Stream<List<dynamic>> get changeBookingSection => _changeBookingSection.stream;

  void changeBookingMenuSection(int section) {
    if (section == 0) {
      bookingMenuButtons[0].setIsActive(true);
      bookingMenuButtons[1].setIsActive(false);
      _changeBookingSection.sink.add(bookingMenuButtons);
      dispose();
    }
    if (section == 1) {
      bookingMenuButtons[0].setIsActive(false);
      bookingMenuButtons[1].setIsActive(true);
      _changeBookingSection.sink.add(bookingMenuButtons);
    }
  }

  void dispose() {
  }
}

class Validators{
}