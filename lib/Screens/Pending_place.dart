import 'package:flutter/material.dart';

class PendingPlacesScreen extends StatelessWidget {
  const PendingPlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Pending Places',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        backgroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: 10,

        itemBuilder: (context, index) {
          return pendingPlaceCard();
        },
      ),
    );
  }

  /// =========================
  /// PLACE CARD
  /// =========================
  Widget pendingPlaceCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 14,

            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          /// =========================
          /// IMAGE
          /// =========================
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),

            child: Image.network(
              'https://picsum.photos/500/300',

              height: 210,

              width: double.infinity,

              fit: BoxFit.cover,
            ),
          ),

          /// =========================
          /// CONTENT
          /// =========================
          Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                /// TITLE
                const Text(
                  'Beautiful Place',

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                /// DESCRIPTION
                Text(
                  'A wonderful place with amazing views and relaxing atmosphere.',

                  style: TextStyle(color: Colors.grey[700], height: 1.5),
                ),

                const SizedBox(height: 16),

                /// LOCATION
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.grey[600],
                      size: 20,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      'Location here later',

                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// ACTIONS
                Row(
                  children: [
                    /// ACCEPT
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,

                          padding: const EdgeInsets.symmetric(vertical: 14),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {
                          /// ACCEPT PLACE
                        },

                        child: const Text(
                          'Accept',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// REJECT
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,

                          padding: const EdgeInsets.symmetric(vertical: 14),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: () {
                          /// REJECT PLACE
                        },

                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
