import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

Future<void> showRatingDialog(BuildContext context, PlaceModel place) async {
  double selectedRating = 0;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final query = await FirebaseFirestore.instance
      .collection('Rates')
      .where('placeId', isEqualTo: place.id)
      .where('userId', isEqualTo: uid)
      .limit(1)
      .get();
  if (query.docs.isNotEmpty) {
    selectedRating = (query.docs.first['rate'] as num).toDouble();
  }
  int ratersNo = place.retersNO;
  //  print('No: $ratersNo');
  bool isLoading = false;
  final previousRating = selectedRating;
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      final loc = AppLocalizations.of(context)!;

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
                  ///  ICON
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

                  ///  TITLE
                  Text(
                    loc.rateThisPlace,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  ///  SUBTITLE
                  Text(
                    loc.yourFeedbackHelpsOtherTravelers,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),

                  const SizedBox(height: 24),

                  ///  STARS
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

                  ///  RATING TEXT
                  Text(
                    selectedRating == 0
                        ? loc.tapToRate
                        : "${selectedRating.toInt()}/5",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ///  BUTTONS
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
                          child: Text(
                            loc.cancel,
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
                                  ///  SAVE RATING HERE
                                  setState(() {
                                    isLoading = true;
                                  });
                                  if (query.docs.isEmpty) {
                                    await FirebaseFirestore.instance
                                        .collection('Rates')
                                        .add({
                                          'placeId': place.id,
                                          'userId': uid,
                                          'rate': selectedRating,
                                        });
                                  } else {
                                    if (previousRating != selectedRating) {
                                      await query.docs.first.reference.update({
                                        'rate': selectedRating,
                                      });
                                    }
                                  }
                                  final ratesQuery = await FirebaseFirestore
                                      .instance
                                      .collection('Rates')
                                      .where('placeId', isEqualTo: place.id)
                                      .get();
                                  List<double> usersRates = [];
                                  for (
                                    int i = 0;
                                    i < ratesQuery.docs.length;
                                    i++
                                  ) {
                                    double temp =
                                        (ratesQuery.docs[i]['rate'] as num)
                                            .toDouble();
                                    usersRates.add(temp);
                                  }
                                  double sum = 0;
                                  for (int i = 0; i < usersRates.length; i++) {
                                    sum += usersRates[i];
                                  }
                                  final totalRate = sum / usersRates.length;
                                  ratersNo = usersRates.length;
                                  // final total =
                                  //     (place.rating * place.retersNO) +
                                  //     selectedRating;

                                  // final updatedRating = total / newRatersNo;
                                  await FirebaseFirestore.instance
                                      .collection('places')
                                      .doc(place.id)
                                      .update({
                                        'ratersCount': ratersNo,
                                        'rate': totalRate,
                                      });
                                  setState(() {
                                    isLoading = false;
                                  });

                                  Navigator.pop(context);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(loc.thanksForYourRating),
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
                          child: isLoading
                              ? SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Text(loc.ok),
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
