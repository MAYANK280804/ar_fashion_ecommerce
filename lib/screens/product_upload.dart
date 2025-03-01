import 'dart:typed_data';
import 'package:ar_fashion_ecommerce/api_working.dart';
import 'package:ar_fashion_ecommerce/screens/home_landing_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:ar_fashion_ecommerce/api_working.dart';

class ProductUpload extends StatefulWidget {

  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  Uint8List? imageFileUint8List;

  TextEditingController sellerNameTextEditingController = TextEditingController();
  TextEditingController sellerPhoneTextEditingController = TextEditingController();
  TextEditingController itemNameTextEditingController =  TextEditingController();
  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController = TextEditingController();

  bool isUploading = false;
  String? downloadUrlOfUploadedImage = "";


  // upload product form screen
  Widget uploadProductFormScreen() {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("New Product Details", style: TextStyle(color: Colors.black,),),
        centerTitle: true,
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_circle_left_outlined, color: Colors.black,)),
        actions: [Padding(
          padding: const EdgeInsets.all(4.0),
          child: IconButton(onPressed: () {if(isUploading != true) //false
              {
            validateUploadFormAndUploadItemInfo();
          }}, icon: Icon(Icons.cloud_upload_sharp, color: Colors.black,),),
        )],
      ),
      body: ListView(children: [
        isUploading == true ? const LinearProgressIndicator(color: Colors.blueAccent,) : Container(),

        // image upload

        SizedBox(height: 230, width: MediaQuery.of(context).size.width*0.8,
        child: Center(child: imageFileUint8List!= null?
        Image.memory(imageFileUint8List!) : const Icon(
          Icons.image_not_supported_outlined, color: Colors.blueGrey, size: 40,),),
        ),

        const Divider(color: Colors.brown, thickness: 2,),

        // Product Seller Name
        ListTile(
          leading: const Icon(Icons.person_pin, color: Colors.black38,),
          title: SizedBox(width: 250, child: TextField(style: const TextStyle(color: Colors.black),
          controller: sellerNameTextEditingController,
            decoration: const InputDecoration(
              hintText: "Seller Name",
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,),
          ),),),
        const Divider(
          color: Colors.brown, thickness: 1,),


        // Product Phone Number
        ListTile(
          leading: const Icon(Icons.phone_android_sharp, color: Colors.black38,),
          title: SizedBox(width: 250, child: TextField(style: const TextStyle(color: Colors.black),
            controller: sellerPhoneTextEditingController,
            decoration: const InputDecoration(
              hintText: "Seller Phone Number",
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,),
          ),),),
        const Divider(
          color: Colors.brown, thickness: 1,),


        // Item Name
        ListTile(
          leading: const Icon(Icons.menu_sharp, color: Colors.black38,),
          title: SizedBox(width: 250, child: TextField(style: const TextStyle(color: Colors.black),
            controller: itemNameTextEditingController,
            decoration: const InputDecoration(
              hintText: "Item Name",
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,),
          ),),),
        const Divider(
          color: Colors.brown, thickness: 1,),

        // Item Description Name
        ListTile(
          leading: const Icon(Icons.description, color: Colors.black38,),
          title: SizedBox(width: 250, child: TextField(style: const TextStyle(color: Colors.black),
            controller: itemDescriptionTextEditingController,
            decoration: const InputDecoration(
              hintText: "Item Description",
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,),
          ),),),
        const Divider(
          color: Colors.brown, thickness: 1,),

        // Item Price
        ListTile(
          leading: const Icon(Icons.currency_pound, color: Colors.black38,),
          title: SizedBox(width: 250, child: TextField(style: const TextStyle(color: Colors.black),
            controller: itemPriceTextEditingController,
            decoration: const InputDecoration(
              hintText: "Product Price",
              hintStyle: TextStyle(color: Colors.black38),
              border: InputBorder.none,),
          ),),),
        const Divider(
          color: Colors.brown, thickness: 1,),







      ],
      ),
    );
  }

  validateUploadFormAndUploadItemInfo() async
  {
    if(imageFileUint8List != null)
    {
      if(sellerNameTextEditingController.text.isNotEmpty
          && sellerPhoneTextEditingController.text.isNotEmpty
          && itemNameTextEditingController.text.isNotEmpty
          && itemDescriptionTextEditingController.text.isNotEmpty
          && itemPriceTextEditingController.text.isNotEmpty)
      {
        setState(() {
          isUploading = true;
        });

        //1.upload image to firebase storage
        String imageUniqueName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference firebaseStorageRef = fStorage.FirebaseStorage.instance.ref()
            .child("Product Pictures")
            .child(imageUniqueName);

        fStorage.UploadTask uploadTaskImageFile = firebaseStorageRef.putData(imageFileUint8List!);

        fStorage.TaskSnapshot taskSnapshot = await uploadTaskImageFile.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((imageDownloadUrl)
        {
          downloadUrlOfUploadedImage = imageDownloadUrl;
        });

        //2.save item info to firestore database
        saveItemInfoToFirestore();
      }
      else
      {
        Fluttertoast.showToast(msg: "Please complete upload form. Every field is mandatory.");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Please select image file.");
    }
  }


  saveItemInfoToFirestore()
  {
    String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseFirestore.instance
        .collection("virtualShopItems")
        .doc(itemUniqueId)
        .set(
        {
          "itemID": itemUniqueId,
          "itemName": itemNameTextEditingController.text,
          "itemDescription": itemDescriptionTextEditingController.text,
          "itemImage": downloadUrlOfUploadedImage,
          "sellerName": sellerNameTextEditingController.text,
          "sellerPhone": sellerPhoneTextEditingController.text,
          "itemPrice": itemPriceTextEditingController.text,
          "publishedDate": DateTime.now(),
          "status": "available",
        });

    Fluttertoast.showToast(msg: "your new Item uploaded successfully.");

    setState(() {
      isUploading = false;
      imageFileUint8List = null;
    });

    Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeLandingScreen()));
  }


  // Default Screen
  Widget defaultScreen() {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Upload New Item", style: TextStyle(color: Colors.black),),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate_sharp, color: Colors.blueGrey, size: 200,),
            ElevatedButton(onPressed: (){showDialogBox();},style: ElevatedButton.styleFrom(backgroundColor: Colors.black38), child: Text("New Item", style: TextStyle(color: Colors.black),),)
          ],
        ),
      ),
    );
  }


  showDialogBox() {
    return showDialog(
      context: context,
      builder: (c){
        return SimpleDialog(
          backgroundColor: Colors.black38,
          title: const Text("Item Image", style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
            onPressed: (){captureImageUsingCamera();},
            child: const Text("Using Camera", style: TextStyle(color: Colors.grey),),
          ),

            SimpleDialogOption(
                onPressed: (){chooseImageFromGallery();},
                child: const Text("Using Gallery", style: TextStyle(color: Colors.grey),),
            ),

            SimpleDialogOption(
                onPressed: (){Navigator.pop(context);},
                child: const Text("Cancel", style: TextStyle(color: Colors.grey),)
            ),


          ],
        );
      }
    );
  }



  captureImageUsingCamera() async {
    Navigator.pop(context);
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedImage!=null){
        String imagePath = pickedImage.path; imageFileUint8List = await pickedImage.readAsBytes();

        // Remove background from image
        // Image Transparency
        imageFileUint8List = await ApiWorking().removeImageBackgroundApi(imagePath);

        setState(() {
          imageFileUint8List;
        });

      }
    }
    catch(errorMsg){
      print(errorMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }


  chooseImageFromGallery() async {
    Navigator.pop(context);
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage!=null){
        String imagePath = pickedImage.path; imageFileUint8List = await pickedImage.readAsBytes();

        // Remove background from image
        // Image Transparency
        imageFileUint8List = await ApiWorking().removeImageBackgroundApi(imagePath);

        setState(() {
          imageFileUint8List;
        });

      }
    }
    catch(errorMsg){
      print(errorMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageFileUint8List == null ? defaultScreen() : uploadProductFormScreen();
  }
}
