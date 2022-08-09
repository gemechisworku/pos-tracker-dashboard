// ignore_for_file: no_logic_in_create_state, avoid_print, unnecessary_const, prefer_const_constructors, prefer_final_fields
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pos_tracker/model/user.dart';
import 'package:pos_tracker/views/merchant_terminals.dart';

class Merchant extends StatefulWidget {
  final String merchant;
  final MyUser myUser;
  const Merchant({Key? key, required this.merchant, required this.myUser}) : super(key: key);

  @override
  State<Merchant> createState() => _MerchantState(merchant, myUser);
}

class _MerchantState extends State<Merchant> {
  final String districtName;
  final MyUser myUser;
  List<String> merchantsList = [];

  _MerchantState(this.districtName, this.myUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$districtName | Merchants'),
      ),
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('location')
              .where("district", isEqualTo: districtName)
              .get()
              .asStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsValue: 'Loading please wait...',
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                print(
                    'name: ${snapshot.data?.docs[index]['merch-name'].toString()}');
                String? merchName =
                    snapshot.data?.docs[index]['merch-name'].toString();
                if (!merchantsList.contains(merchName)) {
                  merchantsList.add(merchName!);
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                    child: _merchantsList(merchName),
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _merchantsList(merchName) {
    return Card(
      child: ListTile(
        trailing: const Icon(Icons.arrow_right),
        title: Text(merchName),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MerchantTerminal(myUser: myUser,
                  merchantName: merchName, distName: districtName)));
        },
      ),
    );
  }
}
