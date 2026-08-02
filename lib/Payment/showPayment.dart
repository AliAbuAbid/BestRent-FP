// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:derot/Payment/PaymentPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';

class PaymentDetails extends StatefulWidget {
  final String documentId;
  const PaymentDetails({super.key, required this.documentId});

  @override
  State<StatefulWidget> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  String documentIdd = '12';
  Future<void> fetchDocumentId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('payments')
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          setState(() async {
            documentIdd = querySnapshot.docs.first.id;
            await FirebaseFirestore.instance
                .collection('payments')
                .doc(documentIdd)
                .delete();
            Navigator.of(context).pushReplacement(
              CustomPageRoute(
                pageBuilder: (context) => Payment(
                  documentId: widget.documentId,
                ),
              ),
            );
          });
        } else {
          print('No document found for the current user.');
        }
      } catch (e) {
        print('Error fetching document ID: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<Map<String, dynamic>?> getPaymentData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      try {
        QuerySnapshot querySnapshot = await firestore
            .collection('payments')
            .where(Filter.or(Filter('userId', isEqualTo: user.uid),
                Filter('ownerUid', isEqualTo: user.uid)))
            .where('documentId', isEqualTo: widget.documentId)
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return querySnapshot.docs.first.data() as Map<String, dynamic>?;
        } else {
          return null;
        }
      } catch (e) {
        print('Error fetching payment data: $e');
        return null;
      }
    } else {
      print('No user is currently signed in.');
      return null;
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
        title: Text('173'.tr),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>?>(
                future: getPaymentData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '221'.tr,
                        style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(
                      child: Text(
                        '222'.tr,
                        style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                    );
                  } else {
                    Map<String, dynamic> paymentData = snapshot.data!;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: CreditCardWidget(
                          backgroundImage: 'assets/images/apartments.jpg',
                          cardNumber: paymentData['cardNumber'],
                          expiryDate: paymentData['expiryDate'],
                          cardHolderName: paymentData['cardHolderName'],
                          cvvCode: paymentData['cvvCode'],
                          showBackView: false,
                          onCreditCardWidgetChange: (CreditCardBrand brand) {},
                          obscureCardNumber: false,
                          obscureCardCvv: false,
                          isHolderNameVisible: true,
                          isSwipeGestureEnabled: true,
                          height: 200,
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                          width: MediaQuery.of(context).size.width,
                          animationDuration: const Duration(milliseconds: 1000),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 48,
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
                        fetchDocumentId();
                      },
                      child: Center(
                        child: Text(
                          '187'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
