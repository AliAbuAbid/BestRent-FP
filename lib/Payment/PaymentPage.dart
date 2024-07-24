// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:derot/Home.dart';
import 'package:derot/Payment/showPayment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:derot/DataBase/Transition.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Payment extends StatefulWidget {
  final String documentId;
  const Payment({super.key, required this.documentId});

  @override
  State<StatefulWidget> createState() => _Payment();
}

class _Payment extends State<Payment> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;
  DateTime currentDate = DateTime.now();
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void _addNotification() async {
    setState(() {
      newnot = true;
    });
    String userPhone = '';
    String userFullname = '';
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      //User? user = FirebaseAuth.instance.currentUser;
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
        print('');
      }

      QuerySnapshot<Map<String, dynamic>> snapshott =
          await FirebaseFirestore.instance.collection('notifications').get();

      QuerySnapshot<Map<String, dynamic>> fav =
          await FirebaseFirestore.instance.collection('payments').get();

      String message = "190".tr;

      await firestore.collection('notifications').add({
        'email': userEmail,
        'phone': userPhone,
        'msg': message,
        'time': DateFormat('HH:mm dd/MM/yyyy').format(currentDate),
      });

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('notifications')
          .where('email', isEqualTo: userEmail)
          .where('phone', isEqualTo: userPhone)
          .get();
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

  void addPayment(CreditCardModel creditCardModel) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot documentSnapshot =
          await firestore.collection('inProgress').doc(widget.documentId).get();

      Map<String, dynamic> paymentData = {
        'documentId': widget.documentId,
        'cardNumber': creditCardModel.cardNumber,
        'expiryDate': creditCardModel.expiryDate,
        'cardHolderName': creditCardModel.cardHolderName,
        'cvvCode': creditCardModel.cvvCode,
        'userId': user.uid,
        'postId': widget.documentId,
        'ownerUid': documentSnapshot['uid'],
        'timestamp': FieldValue.serverTimestamp(),
      };

      try {
        await firestore.collection('payments').add(paymentData);
        print('Payment added successfully.');
        _addNotification();
      } catch (e) {
        print('Error adding payment: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('166'.tr),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            color: Colors.white10,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  CreditCardWidget(
                    enableFloatingCard: useFloatingAnimation,
                    glassmorphismConfig: _getGlassmorphismConfig(),
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    // bankName: 'Leumi Bank',
                    frontCardBorder:
                        Border.all(color: Color.fromARGB(255, 0, 0, 0)),
                    backCardBorder:
                        Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                    showBackView: isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    cardBgColor: Colors.black,
                    backgroundImage: 'assets/images/apartments.jpg',
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                    customCardTypeIcons: <CustomCardTypeIcon>[
                      CustomCardTypeIcon(
                        cardType: CardType.mastercard,
                        cardImage: Image.asset(
                          'assets/images/apartments.jpg',
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          CreditCardForm(
                            formKey: formKey,
                            obscureCvv: true,
                            obscureNumber: true,
                            cardNumber: cardNumber,
                            cvvCode: cvvCode,
                            isHolderNameVisible: true,
                            isCardNumberVisible: true,
                            isExpiryDateVisible: true,
                            cardHolderName: cardHolderName,
                            expiryDate: expiryDate,
                            inputConfiguration: InputConfiguration(
                              cardNumberDecoration: InputDecoration(
                                labelText: '167'.tr,
                                hintText: 'XXXX XXXX XXXX XXXX',
                              ),
                              expiryDateDecoration: InputDecoration(
                                labelText: '168'.tr,
                                hintText: 'XX/XX',
                              ),
                              cvvCodeDecoration: InputDecoration(
                                labelText: 'CVV',
                                hintText: 'XXX',
                              ),
                              cardHolderDecoration: InputDecoration(
                                labelText: '169'.tr,
                              ),
                            ),
                            onCreditCardModelChange: onCreditCardModelChange,
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: () {
                              _onValidate();
                              if (formKey.currentState?.validate() ?? false) {
                                addPayment(CreditCardModel(
                                    cardNumber,
                                    expiryDate,
                                    cardHolderName,
                                    cvvCode,
                                    isCvvFocused));
                                Navigator.of(context)
                                    .pushReplacement(CustomPageRoute(
                                  pageBuilder: (context) => PaymentDetails(
                                    documentId: widget.documentId,
                                  ),
                                ));
                              } else {
                                print('invalid');
                              }
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
                                '170'.tr,
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
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '171'.tr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontFamily: 'halter',
                                fontSize: 10,
                                // fontWeight: FontWeight.w100,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
