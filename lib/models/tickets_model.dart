import 'package:space_y/models/ticket_model.dart';

class Tickets {
  Tickets.fromJson(List<dynamic> jsonTickets) {
    for (int i = 0; i < jsonTickets.length; i++) {
      tickets.add(Ticket.fromJson(jsonTickets[i] as Map<String, dynamic>));
    }
  }
  final List<Ticket> _tickets = <Ticket>[];
  List<Ticket> get tickets => _tickets;
}