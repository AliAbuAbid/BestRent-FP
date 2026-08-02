// ignore_for_file: unused_local_variable, unnecessary_import, unused_element, deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/HouseRent/HouseEditor/houseEdit.dart';
import 'package:derot/HouseRent/InProgress/completed.dart';
import 'package:derot/HouseRent/InProgress/inProgress.dart';
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

class MyHouse extends StatefulWidget {
  @override
  _MyHouse createState() => _MyHouse();
}

class _MyHouse extends State<MyHouse> {
  User? user = FirebaseAuth.instance.currentUser;
  late String document;
  late String document1;
  int k = 0;
  DateTime currentDate = DateTime.now();
  String ali = '';
  TextEditingController _nameController1 = TextEditingController();
  TextEditingController _nameController2 = TextEditingController();
  TextEditingController _nameController3 = TextEditingController();
  TextEditingController _nameController4 = TextEditingController();
  TextEditingController _nameController5 = TextEditingController();
  TextEditingController _phoneController1 = TextEditingController();
  TextEditingController _phoneController2 = TextEditingController();
  TextEditingController _phoneController3 = TextEditingController();
  TextEditingController _phoneController4 = TextEditingController();
  TextEditingController _phoneController5 = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _lookupUserByPhone(
      String phone, TextEditingController nameController) async {
    final String trimmed = phone.trim();
    if (trimmed.length < 7) return;
    try {
      final QuerySnapshot<Map<String, dynamic>> snap = await _firestore
          .collection('users')
          .where('phone', isEqualTo: trimmed)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        final String? fullname = snap.docs.first.data()['username'];
        if (fullname != null && fullname.isNotEmpty) {
          nameController.text = fullname;
        }
      }
    } catch (e) {
      print('Error looking up user by phone: $e');
    }
  }

  Widget textField(TextEditingController name, String label,
      {bool isDark = false,
      TextInputType keyboardType = TextInputType.text,
      IconData icon = Icons.person_outline,
      VoidCallback? onEditingComplete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: isDark ? Colors.white12 : Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: name,
        keyboardType: keyboardType,
        onEditingComplete: onEditingComplete,
        textAlign: TextAlign.left,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          labelText: label,
          labelStyle:
              TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600),
          prefixIcon: Icon(icon, color: const Color(0xFF0D47A1)),
        ),
      ),
    );
  }

  Future<void> moveDocument(String apartmentId) async {
    try {
      DocumentSnapshot apartmentDoc =
          await _firestore.collection('apartments').doc(apartmentId).get();

      if (apartmentDoc.exists) {
        final bool isDark = Theme.of(context).brightness == Brightness.dark;
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color:
                                isDark ? Colors.white24 : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      Text(
                        '153'.tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          textField(_nameController1, '154'.tr, isDark: isDark),
                          textField(_phoneController1, '73'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_outlined,
                              onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _lookupUserByPhone(
                                _phoneController1.text, _nameController1);
                          }),
                          textField(_nameController2, '155'.tr, isDark: isDark),
                          textField(_phoneController2, '73'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_outlined,
                              onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _lookupUserByPhone(
                                _phoneController2.text, _nameController2);
                          }),
                          textField(_nameController3, '156'.tr, isDark: isDark),
                          textField(_phoneController3, '73'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_outlined,
                              onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _lookupUserByPhone(
                                _phoneController3.text, _nameController3);
                          }),
                          textField(_nameController4, '157'.tr, isDark: isDark),
                          textField(_phoneController4, '73'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_outlined,
                              onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _lookupUserByPhone(
                                _phoneController4.text, _nameController4);
                          }),
                          textField(_nameController5, '158'.tr, isDark: isDark),
                          textField(_phoneController5, '73'.tr,
                              isDark: isDark,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone_outlined,
                              onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            _lookupUserByPhone(
                                _phoneController5.text, _nameController5);
                          }),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF0D47A1),
                                    Color(0xFF26C6DA)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () async {
                                    if (_nameController1.text.isEmpty &&
                                        _nameController2.text.isEmpty &&
                                        _nameController3.text.isEmpty &&
                                        _nameController4.text.isEmpty &&
                                        _nameController5.text.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text('159'.tr)),
                                      );
                                      return;
                                    } else {
                                      try {
                                        DocumentSnapshot apartmentDoc =
                                            await _firestore
                                                .collection('apartments')
                                                .doc(apartmentId)
                                                .get();
                                        String usernameA =
                                            apartmentDoc['username'];
                                        if (apartmentDoc.exists) {
                                          Map<String, dynamic> apartmentData =
                                              apartmentDoc.data()
                                                  as Map<String, dynamic>;

                                          apartmentData['name1'] =
                                              _nameController1.text;
                                          apartmentData['name2'] =
                                              _nameController2.text;
                                          apartmentData['name3'] =
                                              _nameController3.text;
                                          apartmentData['name4'] =
                                              _nameController4.text;
                                          apartmentData['name5'] =
                                              _nameController5.text;
                                          apartmentData['phone1'] =
                                              _phoneController1.text;
                                          apartmentData['phone2'] =
                                              _phoneController2.text;
                                          apartmentData['phone3'] =
                                              _phoneController3.text;
                                          apartmentData['phone4'] =
                                              _phoneController4.text;
                                          apartmentData['phone5'] =
                                              _phoneController5.text;
                                          apartmentData['$usernameA'] = false;
                                          apartmentData[
                                              _nameController1.text.isNotEmpty
                                                  ? '${_nameController1.text}'
                                                  : 'name11'] = false;
                                          apartmentData[
                                              _nameController2.text.isNotEmpty
                                                  ? '${_nameController2.text}'
                                                  : 'name22'] = false;
                                          apartmentData[
                                              _nameController3.text.isNotEmpty
                                                  ? '${_nameController3.text}'
                                                  : 'name33'] = false;
                                          apartmentData[
                                              _nameController4.text.isNotEmpty
                                                  ? '${_nameController4.text}'
                                                  : 'name44'] = false;
                                          apartmentData[
                                              _nameController5.text.isNotEmpty
                                                  ? '${_nameController5.text}'
                                                  : 'name55'] = false;
                                          apartmentData['hhhhhhh'] = true;

                                          await _firestore
                                              .collection('inProgress')
                                              .doc(apartmentId)
                                              .set(apartmentData);
                                        } else {
                                          print(
                                              'Document does not exist in the "apartments" collection.');
                                        }
                                      } catch (e) {
                                        print('Error moving document: $e');
                                      }
                                      Navigator.of(context).pushReplacement(
                                          CustomPageRoute(
                                              pageBuilder: (context) =>
                                                  InProgress()));
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      '153'.tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
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
            });
      } else {
        print('Document does not exist in the "apartments" collection.');
      }
    } catch (e) {
      print('Error moving document: $e');
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

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('150'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('apartments')
                    .where('email', isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return Center(child: Text('206'.tr));
                  }

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
              color: selected ? const Color(0xFF0D47A1) : unselectedBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? const Color(0xFF0D47A1) : unselectedBorder,
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
          tab('150'.tr, true, null),
          tab('151'.tr, false, () {
            Navigator.of(context).pushReplacement(
                CustomPageRoute(pageBuilder: (context) => InProgress()));
          }),
          tab('152'.tr, false, () {
            Navigator.of(context).pushReplacement(
                CustomPageRoute(pageBuilder: (context) => Completed()));
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
                    onPressed: () =>
                        _showActionsSheet(context, documentId, doc),
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
                        onTap: () => moveDocument(documentId),
                        child: Center(
                          child: Text(
                            '153'.tr,
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
              ],
            ),
          ),
        ],
      ),
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

  void _showActionsSheet(
      BuildContext context, String documentId, QueryDocumentSnapshot doc) {
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
                leading: const Icon(Icons.move_up, color: Color(0xFF0D47A1)),
                title: Text('153'.tr),
                onTap: () {
                  Navigator.pop(context);
                  moveDocument(documentId);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.edit_outlined, color: Color(0xFF0D47A1)),
                title: Text('103'.tr),
                onTap: () {
                  Navigator.pop(context);
                  ali = documentId;
                  editHouse();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text('105'.tr),
                onTap: () async {
                  Navigator.pop(context);
                  deleteFolder('images/$documentId');
                  await doc.reference.delete();
                  _addNotification();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
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

  Future<void> deleteFolder(String folderPath) async {
    Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);

    try {
      ListResult listResult = await folderRef.listAll();

      for (Reference ref in listResult.items) {
        if (ref.fullPath.endsWith('/')) {
          await deleteFolder(ref.fullPath);
        } else {
          await ref.delete();
        }
      }

      await folderRef.delete();
      print('Folder deleted successfully: $folderPath');
    } catch (e) {
      print('Error deleting folder: $e');
    }
  }

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

  void editHouse() {
    Navigator.of(context).pushReplacement(CustomPageRoute(
      pageBuilder: (context) => EditHouse(
        documentId: ali,
      ),
    ));
  }
}
