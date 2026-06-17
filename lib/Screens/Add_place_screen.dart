import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:tourism_app/Global_variables.dart';
import 'package:tourism_app/Screens/Map_screen.dart';
import 'package:tourism_app/Widgets/Map_preview.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';
import 'package:tourism_app/l10n/app_localizations.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  LatLng selectedLocation = LatLng(24.7136, 46.6753);
  List<dynamic> suggestions = [];
  Timer? debounce;
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  TextEditingController titleControler = TextEditingController();
  TextEditingController describtionController = TextEditingController();
  String placeCategory = '';
  double lat = 0.0;
  double lon = 0.0;
  String placeLocation = '';
  bool isLoading = false;

  String summarizePlaceName(String text) {
    return text.split(',').first.trim();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
  }

  Future<void> searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        suggestions = [];
      });

      return;
    }

    final url =
        'https://nominatim.openstreetmap.org/search'
        '?q=$query'
        '&countrycodes=sa'
        '&format=jsonv2'
        '&limit=5';
    final response = await http.get(
      Uri.parse(url),

      headers: {'User-Agent': 'tourism-app', 'Accept-Language': 'ar,en'},
    );

    if (response.statusCode != 200) {
      return;
    }

    if (response.statusCode == 200) {
      setState(() {
        suggestions = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

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
                loc.addPlace,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                loc.addPlaceYouHaveDiscovered,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ==========================
            /// TITLE
            /// ==========================
            Text(
              loc.placeTitle,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleControler,
              decoration: InputDecoration(
                hintText: loc.enterPlaceTitle,
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// DESCRIPTION
            /// ==========================
            Text(
              loc.description,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: describtionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: loc.writePlaceDescription,
                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// CATEGORY
            /// ==========================
            Text(
              loc.category,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: InputBorder.none),

                hint: Text(loc.chooseCategory),

                items: [
                  DropdownMenuItem(
                    value: 'Mountain',
                    child: Text(loc.mountain),
                  ),
                  DropdownMenuItem(value: 'Sea', child: Text(loc.sea)),
                  DropdownMenuItem(value: 'Beach', child: Text(loc.beach)),
                  DropdownMenuItem(
                    value: 'Entertainment',
                    child: Text(loc.entertainment),
                  ),
                  DropdownMenuItem(
                    value: 'Historical',
                    child: Text(loc.historical),
                  ),
                  DropdownMenuItem(value: 'Desert', child: Text(loc.desert)),
                  DropdownMenuItem(value: 'Otherwise', child: Text(loc.other)),
                ],

                onChanged: (value) {
                  placeCategory = value!;
                },
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// IMAGE
            /// ==========================
            Text(
              loc.placeImage,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),

                child: selectedImage == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 55,
                            color: Colors.grey.shade500,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            loc.chooseImage,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(selectedImage!, fit: BoxFit.cover),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            /// ==========================
            /// LOCATION SECTION
            /// ==========================
            Text(
              loc.location,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              onChanged: (value) {
                debounce?.cancel();
                debounce = Timer(Duration(milliseconds: 500), () {
                  searchPlace(value);
                });
              },
              decoration: InputDecoration(
                hintText: loc.searchLocation,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Suggestions Placeholder
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),

              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: suggestions.length,

                separatorBuilder: (_, _) => const Divider(height: 1),

                itemBuilder: (context, index) {
                  final placeData = suggestions[index];
                  return ListTile(
                    leading: Icon(Icons.location_on),
                    title: Text(placeData['display_name']),
                    onTap: () {
                      lat = double.parse(placeData['lat']);
                      lon = double.parse(placeData['lon']);
                      placeLocation = summarizePlaceName(
                        placeData['display_name'],
                      );
                      setState(() {
                        selectedLocation = LatLng(lat, lon);
                        suggestions = [];
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// MAP PREVIEW
            Container(
              height: 250,
              width: double.infinity,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Container(
                color: Colors.grey.shade200,
                child: MapPreview(location: selectedLocation),
              ),
            ),

            const SizedBox(height: 30),

            /// ==========================
            /// SUBMIT BUTTON
            /// ==========================
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () async {
                  if (titleControler.text.isEmpty ||
                      describtionController.text.isEmpty ||
                      placeCategory.isEmpty ||
                      selectedImage == null ||
                      placeLocation.isEmpty) {
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });

                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('places')
                      .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

                  await storageRef.putFile(selectedImage!);

                  final imageUrl = await storageRef.getDownloadURL();
                  await FirebaseFirestore.instance.collection('places').add({
                    'title': titleControler.text,
                    'description': describtionController.text,
                    'createdAt': DateTime.now(),
                    'commentsCount': 0,
                    'likesCount': 0,
                    'rate': 0,
                    'ratersCount': 0,
                    'userName':
                        '${currentUser.firsrName} ${currentUser.lastName}',
                    'image': imageUrl,
                    'isApproved': 'False',
                    'latitude': lat,
                    'longitude': lon,
                    'location': placeLocation,
                    'category': placeCategory,
                  });
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                    showSuccessToast(context, loc.placeAddedSuccessfully);
                  } else {
                    return;
                  }
                },
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        loc.submitPlace,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    debounce?.cancel();
  }
}
