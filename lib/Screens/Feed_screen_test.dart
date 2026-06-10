import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Place_detail_screen.dart';
import 'package:tourism_app/Widgets/Place_card.dart';
import 'package:tourism_app/cubits/Feed_screen_cubit/Feed_screen_states.dart';
import 'package:tourism_app/cubits/Feed_screen_cubit/Feed_screen_cubit.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class FeedScreenTest extends StatefulWidget {
  const FeedScreenTest({super.key});

  @override
  State<FeedScreenTest> createState() => _FeedScreenTestState();
}

class _FeedScreenTestState extends State<FeedScreenTest> {
  final categories = [
    'All',
    'Mountain',
    'Sea',
    'Beach',
    'Entertainment',
    'Historical',
    'Desert',
    'Otherwise',
  ];

  String selectedCategory = 'All';
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocProvider(
      create: (context) => FeedScreenCubit(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.home,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  loc.placesDiscover,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        body: BlocBuilder<FeedScreenCubit, FeddScreenStates>(
          builder: (context, state) {
            if (state is PlacesLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PlacesLoaded) {
              return Column(
                children: [
                  SizedBox(
                    height: 55,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      scrollDirection: Axis.horizontal,

                      itemCount: categories.length,

                      separatorBuilder: (_, __) => const SizedBox(width: 10),

                      itemBuilder: (context, index) {
                        final category = categories[index];

                        final isSelected = selectedCategory == category;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                            context.read<FeedScreenCubit>().changCategory(
                              category,
                            );
                          },

                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),

                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),

                            decoration: BoxDecoration(
                              color: isSelected ? Colors.green : Colors.white,

                              borderRadius: BorderRadius.circular(25),

                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                              ),

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 6,
                                ),
                              ],
                            ),

                            child: Center(
                              child: Text(
                                category,

                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,

                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.places.length,
                      itemBuilder: (context, index) {
                        PlaceModel place = state.places[index];
                        place.isLiked = state.placesIds.contains(place.id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PlaceDetailsScreen(
                                    place: place,
                                    placeIDs: state.placesIds,
                                  );
                                },
                              ),
                            );
                          },
                          child: PlaceCard(
                            place: place,
                            onLike: () {
                              context.read<FeedScreenCubit>().toggleLike(place);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return Text('There is an error');
            }
          },
        ),
      ),
    );
  }
}
