// ignore_for_file: unused_local_variable, unnecessary_import, unused_element, deprecated_member_use, duplicate_ignore, unused_import, unused_field
import 'package:carousel_slider/carousel_slider.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/HouseEditor/myHouses.dart';
import 'package:derot/HouseRent/InProgress/CompletedCust.dart';
import 'package:derot/HouseRent/InProgress/showContract.dart';
// import 'package:derot/login1.dart';
import 'package:derot/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class _Amenity {
  final String icon;
  final String label;
  final bool active;
  _Amenity(this.icon, this.label, this.active);
}

class CustInProgress extends StatefulWidget {
  @override
  _CustInProgress createState() => _CustInProgress();
}

class _CustInProgress extends State<CustInProgress> {
  static const Color _accent = Color(0xFF0D47A1);

  User? user = FirebaseAuth.instance.currentUser;
  late String document;
  late String document1;
  int k = 0;
  DateTime currentDate = DateTime.now();
  String ali = '';
  TextEditingController password = TextEditingController();
  bool isPasswordCorrect = false;
  bool _obscureText = true;

  void _showEnlargedImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  void checkPassword() async {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    final savedEmail = FirebaseAuth.instance.currentUser!.email.toString();

    if (user != null) {
      // Create the AuthCredential for reauthentication

      AuthCredential credential = EmailAuthProvider.credential(
          password: password.text, email: savedEmail);

      // Reauthenticate the user with the provided credentials
      await user.reauthenticateWithCredential(credential);
      isPasswordCorrect = true;
    }
  }

  void _addNotification() async {
    String userPhone = '';
    String userFullname = '';

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      final userEmail = FirebaseAuth.instance.currentUser?.email;
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: userEmail)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        userPhone = querySnapshot.docs[0].data()['phone'];
        userFullname = querySnapshot.docs[0].data()['username'];
      } else {
        print('No user found with the email: $userEmail');
      }
      document = querySnapshot.docs[0].id.toString();

      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('notifications').get();

      String message = "125";

      print('\nNumber of documents: $k');
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

      documents = snapshot.docs[0].id.toString();
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

  Future<String?> fetchUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot.get('username');
      } else {
        print('No user found with the given UID');
      }
    }
    return null;
  }

  Stream<QuerySnapshot> getData() async* {
    String? username = await fetchUsername();
    if (username != null) {
      yield* FirebaseFirestore.instance
          .collection('inProgress')
          .where(Filter.or(
              Filter('name1', isEqualTo: username),
              Filter('name2', isEqualTo: username),
              Filter('name3', isEqualTo: username),
              Filter('name4', isEqualTo: username)))
          .snapshots();
    } else {
      yield* Stream.empty();
    }
  }

  String? usernamee;

  Future<void> getUsername() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        setState(() {
          usernamee = documentSnapshot['username'];
        });
      } else {
        print('No user found with the given UID');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  void _promptPasswordThenViewContract(String documentId) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          title: Text(
            '69'.tr,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          content: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: password,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                hintText: '*********',
                hintStyle: TextStyle(
                    color: isDark ? Colors.white38 : Colors.grey.shade500),
                prefixIcon: const Icon(Icons.lock_open, color: _accent),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              obscureText: _obscureText,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('36'.tr),
            ),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                final savedEmail = user?.email;

                if (user != null && savedEmail != null) {
                  try {
                    AuthCredential credential = EmailAuthProvider.credential(
                      email: savedEmail,
                      password: password.text,
                    );

                    await user.reauthenticateWithCredential(credential);

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => PDFViewer(
                          docId: documentId,
                          signName: usernamee!,
                        ),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('174'.tr)),
                    );
                  }
                }

                password.clear();
              },
              child: Text('162'.tr,
                  style: const TextStyle(
                      color: _accent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _leaveRental(String documentId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('inProgress')
          .where(Filter.or(
              Filter('name1', isEqualTo: usernamee),
              Filter('name2', isEqualTo: usernamee),
              Filter('name3', isEqualTo: usernamee),
              Filter('name4', isEqualTo: usernamee)))
          .get();

      querySnapshot.docs.forEach((document) async {
        if (document.get('name1') == usernamee) {
          await document.reference.update({'name1': FieldValue.delete()});
        } else if (document.get('name2') == usernamee) {
          await document.reference.update({'name2': FieldValue.delete()});
        } else if (document.get('name3') == usernamee) {
          await document.reference.update({'name3': FieldValue.delete()});
        } else if (document.get('name4') == usernamee) {
          await document.reference.update({'name4': FieldValue.delete()});
        }
      });
    } catch (e) {
      print('Error deleting field: $e');
    }
  }

  void _showActionsSheet(BuildContext context, String documentId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.description_outlined, color: _accent),
                title: Text('162'.tr),
                onTap: () {
                  Navigator.pop(context);
                  _promptPasswordThenViewContract(documentId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: Text('105'.tr),
                onTap: () {
                  Navigator.pop(context);
                  _leaveRental(documentId);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color unselectedBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color unselectedBorder =
        isDark ? Colors.white24 : Colors.grey.shade300;
    final Color unselectedText = isDark ? Colors.white : Colors.black87;

    Widget tab(String label, bool selected, VoidCallback? onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? _accent : unselectedBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? _accent : unselectedBorder,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : unselectedText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          tab('151'.tr, true, null),
          tab('152'.tr, false, () {
            Navigator.of(context).pushReplacement(
                CustomPageRoute(pageBuilder: (context) => CompletedCust()));
          }),
        ],
      ),
    );
  }

  Widget _buildHouseCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final String documentId = doc.id;

    final String houseRaw = (data['house'] ?? '').toString();
    final String houseKind =
        houseRaw.contains('.') ? houseRaw.split('.')[1] : houseRaw;

    final String districtRaw = (data['district'] ?? '').toString();
    final String districts =
        districtRaw.contains('.') ? districtRaw.split('.')[1] : districtRaw;

    final amenities = <_Amenity>[
      _Amenity('assets/icons/pet.svg', '96'.tr, data['Pets'] == true),
      _Amenity(
          'assets/icons/revonated.svg', '93'.tr, data['Renovated'] == true),
      _Amenity('assets/icons/shelter.svg', '94'.tr, data['Shelter'] == true),
      _Amenity('assets/icons/storage.svg', '95'.tr, data['Storage'] == true),
      _Amenity('assets/icons/flexible.svg', '98'.tr, data['flexible'] == true),
      _Amenity('assets/icons/access.svg', '92'.tr,
          data['AccessForDisabled'] == true),
      _Amenity('assets/icons/snow.svg', '102'.tr, data['AirCondition'] == true),
      _Amenity('assets/icons/bars.svg', '90'.tr, data['Bars'] == true),
      _Amenity('assets/icons/exclusive.svg', '88'.tr,
          data['ExclusiveProperty'] == true),
      _Amenity(
          'assets/icons/furniture.svg', '97'.tr, data['Furniture'] == true),
      _Amenity('assets/icons/heater.svg', '91'.tr, data['Heater'] == true),
      _Amenity('assets/icons/longTerm.svg', '99'.tr, data['LongTerm'] == true),
    ].where((a) => a.active).toList();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color placeholderColor =
        isDark ? Colors.white10 : Colors.grey.shade200;
    final Color primaryText = isDark ? Colors.white : Colors.black;
    final Color mutedText = isDark ? Colors.white60 : Colors.grey.shade600;
    final Color descText = isDark ? Colors.white54 : Colors.grey.shade700;

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
                  future: _getImages(documentId),
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
                          return GestureDetector(
                            onTap: () => _showEnlargedImage(
                                context, snapshot.data![index]),
                            child: Image.network(
                              snapshot.data![index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
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
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.15), blurRadius: 6),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.more_vert,
                        size: 20, color: isDark ? Colors.white : Colors.black),
                    onPressed: () => _showActionsSheet(context, documentId),
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
                    '${data['price'] ?? ''} ₪ ${'197'.tr}',
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
                Text(
                  '${'17'.tr}: ${data['username'] ?? ''}',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: primaryText),
                ),
                const SizedBox(height: 2),
                Text(
                  '${'73'.tr}: ${data['phone'] ?? ''}',
                  style: TextStyle(color: mutedText, fontSize: 12.5),
                ),
                const SizedBox(height: 8),
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
                    _statChip(Icons.meeting_room_outlined, '31'.tr,
                        '${data['rooms'] ?? ''}'),
                    const SizedBox(width: 8),
                    _statChip(Icons.layers_outlined, '109'.tr,
                        '${data['floar'] ?? ''}'),
                  ],
                ),
                if ((data['explain'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    data['explain'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: descText, fontSize: 13),
                  ),
                ],
                if (amenities.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: amenities.map((a) => _amenityChip(a)).toList(),
                  ),
                ],
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFF0D47A1)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _showRenters(context, data),
                        child: Text(
                          '225'.tr,
                          style: const TextStyle(
                              color: Color(0xFF0D47A1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
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
                              onTap: () =>
                                  _promptPasswordThenViewContract(documentId),
                              child: Center(
                                child: Text(
                                  '162'.tr,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
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
        ],
      ),
    );
  }

  void _showRenters(BuildContext context, Map<String, dynamic> data) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Map<String, String>> renters = [];
    for (int i = 1; i <= 5; i++) {
      final String name = (data['name$i'] ?? '').toString().trim();
      if (name.isEmpty) continue;
      renters.add({
        'name': name,
        'phone': (data['phone$i'] ?? '').toString().trim(),
      });
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
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
              Text(
                '225'.tr,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              if (renters.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      '226'.tr,
                      style: TextStyle(
                          color:
                              isDark ? Colors.white54 : Colors.grey.shade600),
                    ),
                  ),
                )
              else
                ...renters.map((r) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Color(0xFF0D47A1)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              r['name']!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                          ),
                          if (r['phone']!.isNotEmpty) ...[
                            const Icon(Icons.phone_outlined,
                                size: 16, color: Color(0xFF0D47A1)),
                            const SizedBox(width: 4),
                            Text(
                              r['phone']!,
                              style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade700),
                            ),
                          ],
                        ],
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  Widget _statChip(IconData icon, String label, String value) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              size: 15, color: isDark ? Colors.white70 : Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            '$label $value',
            style: TextStyle(
              fontSize: 12.5,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _amenityChip(_Amenity a) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withOpacity(isDark ? .22 : .08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(a.icon,
              width: 15, height: 15, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 5),
          Text(
            a.label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF0D47A1),
              fontWeight: FontWeight.w600,
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
        title: Text('161'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('106'.tr));
                  }

                  final docs = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                    itemCount: docs.length,
                    itemBuilder: (context, index) =>
                        _buildHouseCard(context, docs[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

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
}
