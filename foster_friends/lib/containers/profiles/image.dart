import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


Future<File> getImage() async {
  return await ImagePicker.pickImage(source: ImageSource.gallery);
}

Future<String> getNetworkUrl(String filename) async {
  if(filename == null){
    return 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Dog_silhouette.svg/1200px-Dog_silhouette.svg.png';
  } else if (filename.length >= 5 ){
    if(filename.substring(0,5) == 'image'){
      return await getUrl(filename);
      // return 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Dog_silhouette.svg/1200px-Dog_silhouette.svg.png';
    }
  }
  return filename;
  // return 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Dog_silhouette.svg/1200px-Dog_silhouette.svg.png';
}

Future<String> getUrl(String fileName) async{
  StorageReference ref = FirebaseStorage.instance.ref().child(fileName);
  String task = await ref.getDownloadURL();
  return task.toString();
  // return 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Dog_silhouette.svg/1200px-Dog_silhouette.svg.png';
}
