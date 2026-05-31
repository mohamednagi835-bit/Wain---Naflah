import 'package:flutter/material.dart';
import 'package:tourism_app/Widgets/Show_delete_place_dialogue.dart';

class AdminPlacesScreen extends StatelessWidget {
  const AdminPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Places',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10,

        itemBuilder: (context, index) {
          return placeCard(context);
        },
      ),
    );
  }

  /// =========================
  /// PLACE CARD
  /// =========================
  Widget placeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),

            child: Image.network(
              'https://picsum.photos/600/300',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TITLE
                const Text(
                  'Place Title',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                /// DESCRIPTION
                Text(
                  'This is a short description about the place.',
                  style: TextStyle(color: Colors.grey[700]),
                ),

                const SizedBox(height: 10),

                /// LOCATION
                Row(
                  children: const [
                    Icon(Icons.location_on, size: 18, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Location here'),
                  ],
                ),

                const SizedBox(height: 10),

                /// STATS ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: const [
                    /// RATING
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        SizedBox(width: 4),
                        Text('4.5'),
                      ],
                    ),

                    /// LIKES
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.red, size: 18),
                        SizedBox(width: 4),
                        Text('120'),
                      ],
                    ),

                    /// COMMENTS
                    Row(
                      children: [
                        Icon(Icons.comment, color: Colors.blue, size: 18),
                        SizedBox(width: 4),
                        Text('30'),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// ACTIONS (EDIT / DELETE)
                Row(
                  children: [
                    /// EDIT
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          /// EDIT PLACE
                        },

                        icon: const Icon(Icons.edit, color: Colors.white),
                        label: const Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// DELETE
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          /// DELETE PLACE

                          showDeletePlaceDialog(
                            context: context,
                            onConfirm: () {},
                          );
                        },

                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
