import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Models/place.dart';

Future<void> showRatingDialog(BuildContext context, PlaceModel place) async {
  double selectedRating = 0;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ⭐ ICON
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.amber.withOpacity(0.15),
                    child: const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 32,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// 🏷️ TITLE
                  const Text(
                    "Rate this place",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  /// 📝 SUBTITLE
                  Text(
                    "Your feedback helps other travelers",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),

                  const SizedBox(height: 24),

                  /// ⭐ STARS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedRating = index + 1.0;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            index < selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 36,
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 10),

                  /// 🔢 RATING TEXT
                  Text(
                    selectedRating == 0
                        ? "Tap to rate"
                        : "${selectedRating.toInt()}/5",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// 🔘 BUTTONS
                  Row(
                    children: [
                      ///  CANCEL
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      ///  SUBMIT
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedRating == 0
                              ? null
                              : () async {
                                  /// 🔥 SAVE RATING HERE
                                  print(selectedRating);
                                  final total =
                                      (place.rating * place.retersNO) +
                                      selectedRating;

                                  final newRatersNo = place.retersNO + 1;

                                  final updatedRating = total / newRatersNo;
                                  await FirebaseFirestore.instance
                                      .collection('places')
                                      .doc(place.id)
                                      .update({
                                        'ratersCount': newRatersNo,
                                        'rate': updatedRating,
                                      });

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Thanks for your rating ⭐"),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
