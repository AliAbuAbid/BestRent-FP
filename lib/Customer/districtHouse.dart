// ignore_for_file: unused_local_variable, unused_field, unused_element, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Customer/Cities/edit_choices.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Home.dart';
import 'package:derot/HouseRent/ApartmentIcons.dart';
import 'package:derot/HouseRent/HouseEditor/ShowInfo.dart';
// import 'package:derot/main.dart';
// import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DistrictApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DistrictApp();
  }
}

late DocumentSnapshot selectedPost;

String selectedDistrict = '';
String distLang = '';

class _DistrictApp extends State<DistrictApp> {
  static const Color _accent = Color(0xFF0D47A1);

  double _ratings = 2.1;
  double avg = 0.1;
  Map<String, dynamic> ratersDict = {};
  bool isLogged = isLoggedIn;
  Kind _selectedhouse = Kind.partners;
  DateTime currentDate = DateTime.now();

  Set<String> favoritePosts = Set();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final favoritesRef =
        FirebaseFirestore.instance.collection('favourites').doc(user.email);
    DocumentSnapshot doc = await favoritesRef.get();
    if (doc.exists && mounted) {
      setState(() {
        favoritePosts = (doc.data() as Map<String, dynamic>).keys.toSet();
      });
    }
  }

  Future<void> toggleFavorite(String postId) async {
    User? user = FirebaseAuth.instance.currentUser;
    final postId = selectedPost.id;
    if (user != null) {
      final favoritesRef =
          FirebaseFirestore.instance.collection('favourites').doc(user.email);

      // Check if the document exists in the apartments collection
      DocumentSnapshot apartmentSnapshot = await FirebaseFirestore.instance
          .collection('apartments')
          .doc(postId)
          .get();

      if (apartmentSnapshot.exists) {
        // Check if the document already exists in the favourites collection
        DocumentSnapshot favouritesSnapshot = await favoritesRef.get();
        if (favouritesSnapshot.exists &&
            (favouritesSnapshot.data() as Map<String, dynamic>)
                .containsKey(postId)) {
          // Document already exists in favourites, show a message
          final snackBar = SnackBar(
            content: Text(
              '114'.tr,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          // Add to favourites
          await favoritesRef
              .set({postId: "documentId"}, SetOptions(merge: true));
          setState(() {
            favoritePosts.add(postId);

            love = true;
          });
          final snackBar = SnackBar(
            content: Text(
              '124'.tr,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 49, 48, 48),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        // Apartment document does not exist
        final snackBar = SnackBar(
          content: Text(
            '208'.tr,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  void showContent(String docid) {
    contentId = docid;
    Navigator.of(context).push(CustomPageRoute(
      pageBuilder: (context) => ShowInfo(),
    ));
  }

  User? user = FirebaseAuth.instance.currentUser;
  Future<List<String>> _getImages(String documentId) async {
    List<String> imageUrls = [];
    Reference imagesRef =
        FirebaseStorage.instance.ref().child('images/$documentId');
    try {
      ListResult result = await imagesRef.listAll();
      for (Reference ref in result.items) {
        String downloadUrl = await ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error loading images: $e');
    }
    return imageUrls;
  }

  late String documentId;
  Future<void> update_Rating(
      double _rating, String documentId, getUserUid) async {
    try {
      CollectionReference apartmentsRef =
          FirebaseFirestore.instance.collection('apartments');

      DocumentReference documentRef = apartmentsRef.doc(documentId);

      ratersDict[getUserUid] = _rating;
      if (!ratersDict.isEmpty) {
        ratersDict.update(getUserUid, (value) => _rating);
        //ratersDict.update(key, (value) => null)
      }
      double sum = 0;
      int counter = 0;
      ratersDict.remove('a');
      for (var dict in ratersDict.values) {
        sum += dict;
      }
      //sum = sum - 0.1;
      counter = ratersDict.length;
      avg = sum / (counter.toDouble());
      Map<String, dynamic> updatedData = {'rating': avg, 'raters': ratersDict};

      // Update the document with the new data
      await documentRef.update(updatedData);

      print('Document updated successfully');
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  String translateDist() {
    if (selectedDistrict == 'North') {
      return '117'.tr;
    } else if (selectedDistrict == 'Haifa') {
      return '118'.tr;
    } else if (selectedDistrict == 'Center') {
      return '119'.tr;
    } else if (selectedDistrict == 'TelAviv-Java') {
      return '120'.tr;
    } else if (selectedDistrict == 'South') {
      return '122'.tr;
    } else if (selectedDistrict == 'Jerusalem') {
      return '121'.tr;
    }
    return '';
  }

  void _editChoice() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const EditChoices(),
    );
  }

  // Filters
  String filterPrice = '';
  String filterCity = '';
  String filterHouse = '';
  String filterStreet = '';
  String filterNeighborhood = '';
  String filterRooms = '';

  void _showFilterDialog() {
    setState(() {});
  }

  void _addNotification() async {
    String userPhone = '';
    String userFullname = '';
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshott =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshott.docs.isNotEmpty) {
        userPhone = querySnapshott.docs[0].data()['phone'];
        userFullname = querySnapshott.docs[0].data()['username'];
        //print('User profile photo: $userProfilePhoto');
      } else {
        print('No user found with the email: $userEmail');
      }
      // document = querySnapshott.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshottt =
          await FirebaseFirestore.instance.collection('notifications').get();

      String message = "124";

      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msgKey': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
        'read': false,
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .where('email', isEqualTo: userEmail)
          .where('phone', isEqualTo: userPhone)
          .get();

      //documents = snapshot.docs[0].id.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('81'.tr)),
        );
        print('81'.tr);
      }
    } catch (e) {
      print(e);
    }
  }

  void _openFilterSheet() {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '30'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    filterPrice = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: '34'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    filterCity = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: '35'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    filterStreet = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
                    labelText: '104'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    filterNeighborhood = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '31'.tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (value) {
                    filterRooms = value;
                  },
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isDark ? Colors.white24 : Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Kind>(
                      isExpanded: true,
                      value: _selectedhouse,
                      items: Kind.values
                          .map(
                            (lang) => DropdownMenuItem(
                              value: lang,
                              child: Text(lang.kindValue.toString()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        _selectedhouse = value;
                        filterHouse = value.toString();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: _accent),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          filterPrice = '';
                          filterCity = '';
                          filterHouse = '';
                          filterStreet = '';
                          filterNeighborhood = '';
                          filterRooms = '';
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        child: Text('37'.tr,
                            style: const TextStyle(color: _accent)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 46,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Center(
                                child: Text(
                                  '36'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
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
  }

  Widget _rentedStatusBadge(String documentId) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('inProgress')
          .doc(documentId)
          .snapshots(),
      builder: (context, inProgressSnap) {
        final bool isInProgress = inProgressSnap.data?.exists ?? false;
        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('completed')
              .doc(documentId)
              .snapshots(),
          builder: (context, completedSnap) {
            final bool isCompleted = completedSnap.data?.exists ?? false;
            if (!isInProgress && !isCompleted) {
              return const SizedBox.shrink();
            }
            return Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green.shade600
                    : Colors.deepOrange.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isCompleted ? '152'.tr : '151'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHouseCard(BuildContext context, QueryDocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final String originalHouseString = (data['house'] ?? '') as String;
    final List<String> houseParts = originalHouseString.split('.');
    final String houseKind =
        houseParts.length > 1 ? houseParts[1] : originalHouseString;

    final String originalDistrictString = (data['district'] ?? '') as String;
    final List<String> distParts = originalDistrictString.split('.');
    final String districts =
        distParts.length > 1 ? distParts[1] : originalDistrictString;

    ratersDict.addAll((data['raters'] as Map?)?.cast<String, dynamic>() ?? {});

    final bool isFav = favoritePosts.contains(doc.id);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color placeholderColor =
        isDark ? Colors.white10 : Colors.grey.shade200;
    final Color primaryText = isDark ? Colors.white : Colors.black;
    final Color mutedText = isDark ? Colors.white60 : Colors.grey.shade600;
    final Color mutedText2 = isDark ? Colors.white38 : Colors.grey.shade500;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4)),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: FutureBuilder<List<String>>(
                  future: _getImages(doc.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 180,
                        color: placeholderColor,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: placeholderColor,
                        child: Image.asset('assets/images/NIA.jpg',
                            fit: BoxFit.contain),
                      );
                    } else {
                      return CarouselSlider.builder(
                        itemCount: snapshot.data!.length,
                        options: CarouselOptions(
                          height: 180,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                        ),
                        itemBuilder: (BuildContext context, int index, _) {
                          return Image.network(
                            snapshot.data![index],
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        houseKind,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _rentedStatusBadge(doc.id),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    if (isLogged) {
                      selectedPost = doc;
                      toggleFavorite(doc.id);
                      _addNotification();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('63'.tr,
                              style: const TextStyle(color: Colors.white)),
                          backgroundColor:
                              const Color.fromARGB(255, 49, 48, 48),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFav
                          ? Colors.redAccent
                          : (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(.55),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Text(
                    '${data['price'] ?? ''} ₪ / ${'197'.tr}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.redAccent),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${data['street'] ?? ''} ${data['streetNumber'] ?? ''} - ${data['city'] ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: primaryText),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${'41'.tr}: $districts',
                  style: TextStyle(color: mutedText, fontSize: 12.5),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: (data['rating'] as num?)?.toDouble() ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 16,
                      itemBuilder: (context, _) =>
                          const Icon(Icons.star, color: Colors.amber),
                      onRatingUpdate: (rating) {
                        setState(() {
                          if (isLoggedIn) {
                            _ratings = rating;
                            update_Rating(rating, doc.id, user!.email);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('63'.tr,
                                    style:
                                        const TextStyle(color: Colors.white)),
                                backgroundColor:
                                    const Color.fromARGB(255, 49, 48, 48),
                              ),
                            );
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${data['rating'] ?? ''}',
                      style: TextStyle(color: mutedText, fontSize: 12.5),
                    ),
                    const Spacer(),
                    Text(
                      '${data['postedDate'] ?? ''}',
                      style: TextStyle(color: mutedText2, fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D47A1), Color(0xFF26C6DA)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          if (isLogged == true) {
                            showContent(doc.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('63'.tr)),
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            '129'.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text(translateDist()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('apartments')
            .where('district', isEqualTo: 'States.$distLang')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            if (filterPrice.isNotEmpty && data['price'] != filterPrice) {
              return false;
            }
            if (filterCity.isNotEmpty && data['city'] != filterCity) {
              return false;
            }
            if (filterHouse.isNotEmpty && data['house'] != filterHouse) {
              return false;
            }
            if (filterStreet.isNotEmpty && data['street'] != filterStreet) {
              return false;
            }
            if (filterNeighborhood.isNotEmpty &&
                data['building'] != filterNeighborhood) {
              return false;
            }
            if (filterRooms.isNotEmpty && data['rooms'] != filterRooms) {
              return false;
            }
            return true;
          }).toList();

          if (docs.isEmpty) {
            return Center(child: Text('205'.tr));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
            itemCount: docs.length,
            itemBuilder: (context, index) =>
                _buildHouseCard(context, docs[index]),
          );
        },
      ),
    );
  }
}
