import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:space_y/models/tickets_model.dart';

import 'package:space_y/ui/widgets/sectionHeader.dart';
import 'package:space_y/blocs/booking_bloc.dart';
import 'package:space_y/ui/booking/booked_screen.dart';

class BookScreen extends StatefulWidget {
  const BookScreen();
  @override
  _BookScreenState createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  Booking bloc = Booking();
  bool checkMassage = false;
  bool checkMeal = false;
  bool checkPool = false;

  String result;

  DateTime now = DateTime.now();

  String getDat () {
    final DateTime tmp = now.add(const Duration(days: 10));
    final String kDate = DateFormat('dd/MM/yyyy').format(tmp);
    return kDate;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  StreamBuilder<dynamic> toBook(BuildContext context) {
    return StreamBuilder<dynamic>(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Column(
          children: <Widget>[
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Massage           ',
                      style: TextStyle(
                          color: Colors.grey),
                      textAlign: TextAlign.center
                    ),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Checkbox(
                              key: const Key('MassageCheckBox'),
                              value: checkMassage,
                              activeColor: Colors.red,
                              onChanged:(bool newValue){
                                setState(() {
                                  checkMassage = newValue;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('No gravity meal', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Checkbox(
                              key: const Key('NoGravityMealCheckbox'),
                              value: checkMeal,
                              activeColor: Colors.red,
                              onChanged:(bool newValue) {
                                setState(() {
                                  checkMeal = newValue;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text('No gravity pool', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Checkbox(value: checkPool,
                              activeColor: Colors.red,
                              onChanged:(bool newValue){
                                setState(() {
                                  checkPool = newValue;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            const SizedBox(height: 50,),
            StreamBuilder<bool>(
              builder: (BuildContext context, AsyncSnapshot<bool> snap){
                return Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      child: ClipOval(
                        child: Material(
                          color: Colors.red,
                          child: InkWell(
                            key: const Key('BookTicketButton'),
                            splashColor: Colors.grey, // inkwell color
                            child: const SizedBox(width: 50, height: 50, child:  Icon(Icons.flight_takeoff, size: 100)),
                            onTap: () async {
                              await bloc.getUserTickets();
                              result = await bloc.sendBooking(massage: checkMassage, meal: checkMeal, pool: checkPool);
                              if (result != null)
                                Navigator.push<dynamic>(
                                  context,
                                  CupertinoPageRoute<dynamic>(
                                    builder: (_) => const BookedScreen(),
                                  ),
                                );
                            },
                          ),
                        ),
                      ),
                    )
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<Tickets> getContent() async {
    final Tickets tickets = await bloc.getUserTickets();
    return tickets;
  }

  Widget booked(BuildContext context, Booking bloc){
    return Container(
      child: FutureBuilder<Tickets>(
        future: getContent(),
        builder: (BuildContext context, AsyncSnapshot<Tickets> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Text(
                'loading...',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              );
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
                return ListView.builder(
                  shrinkWrap: true,
                    itemCount: snapshot.data.tickets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child:
                          Column(
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              Text(
                                  DateFormat.yMMMd().format(snapshot.data.tickets[index].dateTakeoff)
                                  .toString(),
                                key: const Key('DateTakeOffTextField'),
                              ),
                              const SizedBox(height: 5,),
                              const Text('Options :'),
                              const SizedBox(height: 5,),
                              if (snapshot.data.tickets[index].massage == true)
                                const Text(
                                  'Massage',
                                  key: Key('MassageOptionTextField'),
                                ),
                              if (snapshot.data.tickets[index].gravityMeal == true)
                                const Text('No gravity meal',
                                  key: Key('NoGravityMealTextField'),
                                ),
                              if (snapshot.data.tickets[index].gravityPool == true)
                                const Text('No gravity pool'),
                              const SizedBox(height: 10,),
                            ],
                          )
                      );
                    }
                );
          }
        }
      )
    );
  }

  ButtonTheme bookingSectionMenuButton(
      MenuItem menuItem, int section) {
    return ButtonTheme(
      child: FlatButton(
        onPressed: () {
          bloc.changeBookingMenuSection(section);
        },
        child: Text(
          menuItem.title,
          style: TextStyle(
              fontSize: 16,
              fontWeight:
              menuItem.isActive == true ? FontWeight.w500 : FontWeight.w400,
              color: Colors.black),
        ),
      ),
    );
  }

  Row bookingSectionMenu(List<MenuItem> menuItemList) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //SizedBox(,),
                    bookingSectionMenuButton(menuItemList[0], 0),
                    Container(
                      height: 2,
                      width: 124,
                      color: menuItemList[0].isActive == true
                          ? Theme.of(context).accentColor
                          : Colors.transparent,
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    bookingSectionMenuButton(menuItemList[1], 1),
                    Container(
                      height: 2,
                      width: 150,
                      color: menuItemList[1].isActive == true
                          ? Theme.of(context).accentColor
                          : Colors.transparent,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  StreamBuilder<dynamic> sectionSelector(BuildContext context) {
    return StreamBuilder<dynamic>(
      initialData: bloc.bookingMenuButtons,
      stream: bloc.changeBookingSection,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        final List<MenuItem> menu = snapshot.data as List<MenuItem>;
        return Container(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20,),
              bookingSectionMenu(menu),
              if (menu[0].isActive == true) toBook(context) else booked(context, bloc),
            ],
          ),
        );
      },
    );
  }

  Container buildBookingView(BuildContext context) {
    return Container(
      // padding: EdgeInsets.only(left: 10, right: 10),
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.02, right: MediaQuery.of(context).size.width * 0.01),
      child: Column(
        children: <Widget>[
          sectionSelector(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: ListView(
        children: <Widget>[
          header(context, 'Space Tickets'),
          buildBookingView(context),
        ],
      ),
    );
  }
}
