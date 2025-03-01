import 'package:ar_fashion_ecommerce/screens/product_upload.dart';
import 'package:ar_fashion_ecommerce/screens/virtual_product.dart';
import 'package:ar_fashion_ecommerce/screens/virtual_product_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeLandingScreen extends StatefulWidget {
  const HomeLandingScreen({super.key});

  @override
  State<HomeLandingScreen> createState() => _HomeLandingScreenState();
}

class _HomeLandingScreenState extends State<HomeLandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("V_Style : Fashion AR E-commerce", style: TextStyle(fontSize: 20, letterSpacing: 2, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (c)=> ProductUpload()));
          },
          icon: const Icon(Icons.add, color: Colors.orange,),)
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("virtualShopItems").orderBy("publishedDate", descending: true).snapshots(),
        builder: (context, AsyncSnapshot dataSnapshot) {
          if(dataSnapshot.hasData){
            return ListView.builder(
              itemCount: dataSnapshot.data.docs.length,
              itemBuilder: (context, index) {VirtualProduct eachProductInfo = VirtualProduct.fromJson(dataSnapshot.data!.docs[index].data() as Map<String, dynamic>);
                return VirtualProductUi(
                  itemsInfo: eachProductInfo, context: context,
    );
    });
          }else{
            return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const[
              Center(
                child: Text("Data is not Available.", style: TextStyle(fontSize: 30, color: Colors.grey,),),
    )
    ],
            );
          }
                // return Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Card(
                //     child: ListTile(
                //       title: Text(dataSnapshot.data.docs[index].get("itemName"))
                //     ),
            }),
    );
  }
}
