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
import 'package:tourism_app/Models/place.dart';
import 'package:tourism_app/Screens/Map_screen.dart';
import 'package:tourism_app/Widgets/Map_preview.dart';
import 'package:tourism_app/Widgets/Show_success_toast.dart';

class EditPlaceScreen extends StatefulWidget {
  final PlaceModel place;

  EditPlaceScreen({super.key, required this.place});

  @override
  State<EditPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<EditPlaceScreen> {
  late LatLng selectedLocation;
  List<dynamic> suggestions = [];
  Timer? debounce;
  File? selectedImage;
  final ImagePicker picker = ImagePicker();
  late TextEditingController titleControler;
  late TextEditingController describtionController;
  late TextEditingController searchController;

  String placeCategory = '';
  double lat = 0.0;
  double lon = 0.0;
  String placeLocation = '';
  bool isLoading = false;
  late String image;
  bool isImageEdited = false;

  String summarizePlaceName(String text) {
    return text.split(',').first.trim();
  }

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      selectedImage = File(image.path);
    });
    isImageEdited = true;
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
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLocation = LatLng(widget.place.lat, widget.place.lon);
    titleControler = TextEditingController(text: widget.place.name);
    describtionController = TextEditingController(
      text: widget.place.description,
    );
    placeCategory = widget.place.category;
    placeLocation = widget.place.location;
    image = widget.place.image;
    searchController = TextEditingController(text: widget.place.location);
  }

  @override
  Widget build(BuildContext context) {
    print('enterd build method');

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
                'Edit  place',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Edit place user discovered',
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
            const Text(
              'Place Title',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: titleControler,
              decoration: InputDecoration(
                hintText: 'Enter place title',
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
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: describtionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write place description...',
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
            const Text(
              'Category',
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

                hint: const Text('Choose category'),
                initialValue: placeCategory,

                items: const [
                  DropdownMenuItem(value: 'Mountain', child: Text('Mountain')),
                  DropdownMenuItem(value: 'Sea', child: Text('Sea')),
                  DropdownMenuItem(value: 'Beach', child: Text('Beach')),
                  DropdownMenuItem(
                    value: 'Entertainment',
                    child: Text('Entertainment'),
                  ),
                  DropdownMenuItem(
                    value: 'Historical',
                    child: Text('Historical'),
                  ),
                  DropdownMenuItem(value: 'Desert', child: Text('Desert')),
                  DropdownMenuItem(
                    value: 'Otherwise',
                    child: Text('Otherwise'),
                  ),
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
            const Text(
              'Place Image',
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

                child:
                    // selectedImage == null
                    //     ? Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.image_outlined,
                    //             size: 55,
                    //             color: Colors.grey.shade500,
                    //           ),
                    //           const SizedBox(height: 10),
                    //           Text(
                    //             'Choose Image',
                    //             style: TextStyle(color: Colors.grey.shade700),
                    //           ),
                    //         ],
                    //       )
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: isImageEdited
                          ? Image.file(selectedImage!)
                          : Image.network(image),
                    ),
              ),
            ),

            const SizedBox(height: 25),

            /// ==========================
            /// LOCATION SECTION
            /// ==========================
            const Text(
              'Location',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: searchController,
              onChanged: (value) {
                debounce?.cancel();
                debounce = Timer(Duration(milliseconds: 500), () {
                  searchPlace(value);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search location...',
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
                  setState(() {
                    isLoading = true;
                  });
                  final storageRef = FirebaseStorage.instance
                      .ref()
                      .child('places')
                      .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

                  await storageRef.putFile(selectedImage!);

                  final imageUrl = await storageRef.getDownloadURL();
                  await FirebaseFirestore.instance
                      .collection('places')
                      .doc(widget.place.id)
                      .update({
                        'title': titleControler.text,
                        'description': describtionController.text,
                        'image': isImageEdited ? imageUrl : image,
                        'latitude': lat,
                        'longitude': lon,
                        'location': placeLocation,
                        'category': placeCategory,
                      });
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                    if (!context.mounted) return;
                    showSuccessToast(context, 'Place edited successfully');
                  } else {
                    return;
                  }
                },
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        'Submit Place',
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
