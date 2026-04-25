import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Seat {
  final int id;
  bool isSelected;
  bool isBooked;

  Seat({
    required this.id,
    this.isSelected = false,
    this.isBooked = false,
  });
}

class SeatSelectionScreen extends StatefulWidget {
  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<Seat> seats = List.generate(
    12,
        (index) => Seat(id: index + 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choisir les sièges")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: seats.length,
              itemBuilder: (context, index) {
                final seat = seats[index];

                Color color = Colors.blue;

                if (seat.isBooked) {
                  color = Colors.grey;
                } else if (seat.isSelected) {
                  color = Colors.green;
                }

                return GestureDetector(
                  onTap: () {
                    if (!seat.isBooked) {
                      setState(() {
                        seat.isSelected = !seat.isSelected;
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text("${seat.id}")),
                  ),
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: () {
              final selectedSeats =
              seats.where((s) => s.isSelected).toList();

              Navigator.pop(context, selectedSeats);
            },
            child: Text("CONFIRMER"),
          ),
        ],
      ),
    );
  }
}