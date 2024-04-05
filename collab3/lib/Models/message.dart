// class MessageModel{
//   String sender;
//   String text;
//   bool seen;
//   DateTime creadtedon;
//
//   MessageModel({this.sender,this.text,this.seen,this.creadtedon});
//
//   MessageModel.fromMap(Map<String,dynamic>map){
//     sender =map["sender"];
//     text = map["text"];
//     seen = map["seen"];
//     createdon = map["createdon"].toDate();
//   }
//   Map<String,dynamic>toMap(){
//     return{
//       "sender": sender,
//       "text": text,
//       "seen": seen,
//       "createdon": creadtedon,
//     };
//   }
// }