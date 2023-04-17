import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:web_date_picker/web_date_picker.dart';
import 'package:intl/intl.dart';

import 'controllers/auth_Controller.dart';
import 'mydrawer.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('students');

class DashBoard extends StatefulWidget {

   DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int percent = 50;
  var _location,_dob , _gender;
  var _locationLast,_dobLast , _genderLast;
  var data;

  @override
  late final controller;
  void initState() {
  controller = Get.put(AuthController());
  data = controller.getDataofStudent(FirebaseAuth.instance.currentUser!.email);
print(">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<");
print(data);
setState(() {
// _location = data[0];
// _dob = data[1];
// _gender = data[2];
  
});
  //  Get.snackbar(data.toString(), data.toString(),duration: const Duration(seconds: 5));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Web App Demo "),
        actions: <Widget>[
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: CircleAvatar(
          radius: 20,
          child: ClipOval(child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!)),
        ),
      )
    ),
    Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.center,
          child: Text(FirebaseAuth.instance.currentUser!.displayName!,style: TextStyle(fontSize:16,),)
          )
      )
    ),
  ],

      ),
      body: StreamBuilderContainer(_size,context),
      // mybody(_size, context),
      drawer: _size.width >600? null: MyDrawer(
        imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
        accountName: FirebaseAuth.instance.currentUser!.displayName!,
        accountEmail: FirebaseAuth.instance.currentUser!.email!,
        
        ),

    );
  }

  Row mybody(Size _size, BuildContext context) {
    return Row(
      children: [
         Padding(
          padding: const EdgeInsets.all(0.0),
          child: _size.width >600?  Material(
            elevation: 0.0,
            child: MyDrawer(
               imageUrl: FirebaseAuth.instance.currentUser!.photoURL!,
                  accountName: FirebaseAuth.instance.currentUser!.displayName!,
                  accountEmail: FirebaseAuth.instance.currentUser!.email!,
              ),
          ) : null,
        ),
        Expanded(
          child: Column(
            children: [
              firstContainer(_size),
             
              secondContainer2(context)
            ],
          ),
        ),
       
      ],
    );
  }

  Widget StreamBuilderContainer(_size,context) {
    return StreamBuilder(
      stream: _mainCollection.doc(FirebaseAuth.instance.currentUser!.email).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                else if(snapshot.hasData){
                  Future.delayed(Duration(seconds: 3));
                  _locationLast = _location;
                  _genderLast = _gender;
                  _dobLast = _dob;
                  _location = snapshot.data!.get("location");
                  _gender = snapshot.data!.get("gender");
                  _dob = snapshot.data!.get("dob");
                  print("----> Location =$_location#");
                  print("---->Gender =$_gender#");
                  print("---->Dob =$_dob#");
                  if(( _location == "") && _locationLast!=_location && controller.per.value >=34){
                    print("not location------->");
                    controller.per.value = controller.per.value -33;
                  }
                  else if((_location != "")&& _locationLast!=_location && controller.per.value <= 67) {
                    print("is location------->");
                    controller.per.value = controller.per.value +33;
                  }
                  if(_gender == "" && controller.per.value >=34){
                    print("not gender------->");
                    controller.per.value = controller.per.value -33;
                  }
                  else if(_gender != "" && controller.per.value <= 67) {
                    print("is gender------->");
                    percent = percent + 33;
                  }
                  if(_dob == null && controller.per.value >=34){
                    print("not dob------->");
                    controller.per.value = controller.per.value -33;
                  }
                  else if(_dob != null && controller.per.value <= 67) {
                    print("is dob------->");
                    controller.per.value = controller.per.value + 33;
                  }
                  
                   return mybody(_size,context);
                }
                return CircularProgressIndicator();
                  
      }
    );
  }

  Padding secondContainer2(BuildContext context) {
    return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 5.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Colors.deepPurple[100],
                      borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top:15.0,right: 8,left: 8,bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text("Your Personal Detailed",style: TextStyle(fontWeight: FontWeight.bold),),
                          GestureDetector(
                            onTap: () {
                             showDialog(context: context, builder: (_){
                              TextEditingController locationEditigController = TextEditingController();
                              TextEditingController genderEditigController = TextEditingController() ;
                              var dob;
                              locationEditigController.text = _location;
                              genderEditigController.text = _gender;
                      return AlertDialog(
                        content: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Location"),
                            SizedBox(height: 20,),
                            TextField(controller: locationEditigController,),
                            SizedBox(height: 40,),
                            Text("Gender"),
                            SizedBox(height: 20,),
                            TextField(controller: genderEditigController,),
                            SizedBox(height: 40,),
                            // WebDatePicker(onChange:(value) {
                            //   dob = "${value!.year}/${value.month}/${value.day}";
                            //   _dob =dob;
                            //   print(">>>>>>>>>>$_dob");
                            //   Get.back();
                            //   Get.back();
                            // },)
                            // SfDateRangePicker(onSelectionChanged: (agr){
                            //     if(agr.value is DateTime){
                            //       dob = "${agr.value!.year}/${agr.value.month}/${agr.value.day}";
                            //   _dob =dob;
                            //   print(">>>>>>>>>>$_dob");

                            //     }
                            // },)
                            // getDateRangePicker()
                            ElevatedButton(onPressed: (){
                          setState(() {
                          _location = locationEditigController.text;
                          _gender = genderEditigController.text;
                          _dob = dob.toString();
                            
                          });
                          controller.updateDb(FirebaseAuth.instance.currentUser!.email,_location,_dob,_gender);
                          Get.back();
                        _showDatePicker();
  
                        }, child: Text("Next"))
                          ],
                        ),
                        
                      );
                    }); 
                            },
                            child: Icon(Icons.edit,color: Colors.black,))
                        ],),
                      ),
                      Divider(color: Colors.deepPurple[50],),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          Row(
                            children: [
                              Icon(Icons.location_pin),
                              Text("Location"),
                            ],
                          ),
                          Text(_location ?? "Input Location"),
                          Row(
                            children: [
                              Icon(Icons.group_remove_rounded),
                              Text("Gender"),
                            ],
                          ),
                          Text(_gender ?? "Input Gender")
                
                        ],),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_month),
                              Text("DOB"),
                            ],
                          ),
                          Text(_dob ?? "Input DOB")
                        ],),
                      ],)
                    ]),
                  ),
                  ),
                );
  }
  _showDatePicker()async{
    final DateTime? picked=await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900, 1), lastDate: DateTime(2101));
    if(picked != null)
    {
    print(DateFormat("yyyy-MM-dd").format(picked));
    _dob = DateFormat("yyyy-MM-dd").format(picked);
    controller.updateDb(FirebaseAuth.instance.currentUser!.email,_location,_dob,_gender);
    }
  }
  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
  _dob = DateFormat('yyyy-MM-dd').format(args.value);
 
  SchedulerBinding.instance.addPostFrameCallback((duration) {
    setState(() {});
  });
}
Widget getDateRangePicker() {
  return Container(
      height: 250,
      child: Card(
          child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.single,
        onSelectionChanged: selectionChanged,
      )));
}
  Widget linearPercentIndicator() {
    return Obx(
      ()=> LinearPercentIndicator( 
                                  // animation: true,
                                  // animationDuration: 1000,
                                  lineHeight: 20.0,
                                  percent:controller.per.value/100,
                                  barRadius: Radius.circular(25),
                                  center: Text(
                                    "${controller.per.value}%",
                                    style:const TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  // linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.blue[400],
                                  backgroundColor: Colors.grey[300],
                                ),
    );
  }

  Widget firstContainer(Size _size) {
    return Padding(padding: EdgeInsets.all(8.0),
    
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(8.0) ,
                  decoration: BoxDecoration(
                  color: Colors.deepPurple[100],
                    borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    CircleAvatar(
                      radius: 40,
                      child: ClipOval(child: Image.network(FirebaseAuth.instance.currentUser!.photoURL!)),
                    ),
                    
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(FirebaseAuth.instance.currentUser!.displayName!.split(" ")[0],style: TextStyle(fontSize:16,color: Colors.black),),
                        Container(
                    width: _size.width*0.5,
                    child: linearPercentIndicator()),
                     Text(FirebaseAuth.instance.currentUser!.email!,style: TextStyle(fontSize:16,color: Colors.black),),
                    ],
                    )
                  ],),
                ),
              ),
              );
  }
}