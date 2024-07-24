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
    return Scaffold(
      appBar: AppBar(
        title: Text('173'.tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: getPaymentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error fetching payment data'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return Center(child: Text('No payment data found'));
              } else {
                Map<String, dynamic> paymentData = snapshot.data!;
                return Container(
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
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontFamily: 'halter',
                      fontSize: 14,
                      // fontWeight: FontWeight.w100,
                      package: 'flutter_credit_card',
                    ),
                    width: MediaQuery.of(context).size.width,
                    animationDuration: Duration(milliseconds: 1000),
                  ),
                );
              }
            },
          ),
          TextButton(
            onPressed: () {
              fetchDocumentId();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.blue,
                    Colors.black,
                  ],
                  begin: Alignment(-1, -4),
                  end: Alignment(1, 4),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              alignment: Alignment.center,
              child: Text(
                '187'.tr,
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontFamily: 'halter',
                  fontSize: 14,
                  // fontWeight: FontWeight.w100,
                  package: 'flutter_credit_card',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
