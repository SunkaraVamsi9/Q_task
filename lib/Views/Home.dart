import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quantum_task/Controllers/Homecontroller.dart';
import 'package:quantum_task/State/getstate.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
TextEditingController search_controller=TextEditingController();
List sort_list=["Priority","Due_date"];
List data=[];
var form_key=GlobalKey<FormState>();
List text_list=["Title","Description","Priority","Due_date"];
List controllers=[TextEditingController(),TextEditingController(),TextEditingController(),
TextEditingController()];
int ind=0;
bool edit=false;
@override
  void initState() {
   Homecontroller().getdata();
    // TODO: implement initState
    super.initState();
  }
 getstate getController = Get.put(getstate());
   
  @override
  Widget build(BuildContext context) {
  data=getController.data;
    return Scaffold(
      appBar:AppBar(
        elevation:2,title:ind==1?Text("Create"):ind==2?Text("Delete"):TextField(
          onSubmitted:(val){
            setState(() {
          Homecontroller().search(val);  
            });
          },
        controller:search_controller
        ,decoration:InputDecoration(hintText:"Search by Title",
          border:OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      )),),
      actions: [if(ind==0)DropdownMenu(textStyle:TextStyle(fontSize:13),
        width:MediaQuery.of(context).size.width/3.1,hintText:"Sort",
        onSelected:(val){

       setState(() {
         Homecontroller().srt(val);
       }); 
      },
           //   textStyle:TextStyle(fontSize:14),hintText:"Sort",width:MediaQuery.of(context).size.width/3
      dropdownMenuEntries:[
        for(var i in sort_list)DropdownMenuEntry(value:i,label:i)
      ])],
      bottom:PreferredSize(preferredSize:Size.fromHeight(18), child:Container()),
    ),body:ind==1?create():ind==2?delete():data.length!=0?ListView.builder(itemCount:data.length,
    itemBuilder:(build,index){
      return Card(child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Title:"),Text("Priority:"),
              Text("Due_date")],
            ),
            Column(children: [Text(":"),Text(":"),Text(":"),
            
                   ],),
            Column(crossAxisAlignment: CrossAxisAlignment.start
            ,children: [Text(data[index]['title']),
            Text(data[index]['priority'].toString()),Text(data[index]['due_date'].toString().substring(0,10))],)],
            ),
            Text("Description:"),Container(width:MediaQuery.of(context).size.width/1.06,
              decoration: BoxDecoration(
              border: Border.all()
            ),
              child: Text(data[index]['description'])),
            SizedBox(height:10,),
          Center(
            child: ElevatedButton(onPressed:(){
            setState(() {
             controllers[0].text=data[index]['title'];
             controllers[1].text=data[index]['description'];
            controllers[2].text=data[index]['priority'].toString();
             controllers[3].text=data[index]['due_date'].toString().substring(0,10);
             edit=true;
             ind=1;
            });
                    
                    }, child:Text("Edit")),
          ) ],
        ),
      ));
    }):Center(child:Text("No Data Found")),
    drawer: Drawer(width:MediaQuery.of(context).size.width/3.8,child:Padding(
      padding: const EdgeInsets.only(top:45),
      child: Column(
        children: [Text("Services",style:TextStyle(fontSize:18,color:Colors.red)),Divider(),
        SizedBox(height: 15,),
          for(var i in ["Home","Create","Delete"])
          GestureDetector(child:Column(
            children: [
              Text(i,style:TextStyle(fontSize:18,color:Colors.blue)),
              SizedBox(height:15,)
            ],
          ),
          onTap:(){
setState(() {
  if(i=="Create"){
    ind=1;
    edit=false;
    for(var c in controllers)
    c.text="";
  }
  else if(i=="Home"){
    ind=0;
  }
  else{
    ind=2;
    setState(() {
      controllers[0].text="";
    });
  }
Navigator.pop(context);
});
},),
        ],
      ),
    )));
  }
create(){
dt() async{
var date=await showDatePicker(context: context, firstDate:DateTime.now(),
 lastDate:DateTime(2025));
 setState(() {
  if(date!=null)
   controllers[3].text=date.toString();
 });} 
return Padding(
  padding: const EdgeInsets.all(8.0),
  child: SingleChildScrollView(
    child: Center(child:Form(key:form_key,child:Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [for(int i=0;i<3;i++)Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [Text(text_list[i],style:TextStyle(fontSize:18),),
          TextFormField(
            decoration:InputDecoration(border:OutlineInputBorder()),
            controller:controllers[i],
            enabled:i==0?edit?false:true:true,
            validator:(val){
              if(val!.isEmpty){
                return "Enter the value";
              }
            },
          ),
      SizedBox(height:10,)  ],
      ),
TextButton(
onPressed: () =>dt(),
child:controllers[3].text!=""?Text(controllers[3].text.substring(0,10),style:TextStyle(fontSize:18))
:
Text("Select_Due_date",style:TextStyle(fontSize:18))),
      Center(
        child: ElevatedButton(onPressed:(){
            if(form_key.currentState!.validate()){
            if(controllers[3].text==""){
showDialog(context: context, builder:(build){
return AlertDialog(content:Text("Select Date"));
});
            }
           else{
             Homecontroller().create(controllers,edit);
            setState(() {
        ind=0;
            });
           }
            }
        }, child:Text("Save")),
      )],
    )) ,),
  ),
);
  }
  delete(){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child:Form(
      key: form_key,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(text_list[0],style:TextStyle(fontSize:18),),
              TextFormField(
                validator:(val){
                  if(val!.isEmpty){
                    return "Enter the value";
                  }
                },
                decoration:InputDecoration(border:OutlineInputBorder()),
                controller:controllers[0],
              ),
          SizedBox(height:10,) ,
            Center(
              child: ElevatedButton(onPressed:(){
                    if(form_key.currentState!.validate()){
              Homecontroller().delete(controllers[0].text);
                      setState(() {
              ind=0;
                      });
                    }
                      }, child:Text("Delete")),
            ) ],
          ),
    )),
  );
  }
}