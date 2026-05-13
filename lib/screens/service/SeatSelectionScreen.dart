import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Seat {

  final int id;

  RxBool isSelected;

  RxBool isBooked;

  Seat({
    required this.id,
    bool isSelected = false,
    bool isBooked = false,
  })  : isSelected = isSelected.obs,
        isBooked = isBooked.obs;
}

class SeatSelectionScreen extends StatelessWidget {

  SeatSelectionScreen({super.key});

  final RxList<Seat> seats = List.generate(
    12,
        (index) => Seat(id: index + 1),
  ).obs;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Choisir les sièges",
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: GridView.builder(

              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),

              itemCount: seats.length,

              itemBuilder: (context, index) {

                final seat = seats[index];

                return Obx(() {

                  Color color = Colors.blue;

                  if (seat.isBooked.value) {

                    color = Colors.grey;

                  } else if (seat.isSelected.value) {

                    color = Colors.green;
                  }

                  return GestureDetector(

                    onTap: () {

                      if (!seat.isBooked.value) {

                        seat.isSelected.value =
                        !seat.isSelected.value;
                      }
                    },

                    child: Container(

                      margin: const EdgeInsets.all(6),

                      decoration: BoxDecoration(

                        color: color,

                        borderRadius:
                        BorderRadius.circular(8),
                      ),

                      child: Center(

                        child: Text(
                          "${seat.id}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          Padding(

            padding: const EdgeInsets.all(16),

            child: SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  final selectedSeats = seats
                      .where(
                        (s) => s.isSelected.value,
                  )
                      .toList();

                  Get.back(
                    result: selectedSeats,
                  );
                },

                child: const Text(
                  "CONFIRMER",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}