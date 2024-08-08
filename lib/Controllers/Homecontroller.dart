import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:quantum_task/State/getstate.dart';
class Homecontroller{
getstate getController = Get.put(getstate());
Box box=Hive.box("MyData");
getdata(){
  if(box.containsKey("Todolist")){
     getController.data=box.get("Todolist");
  }
}
search(String title){
int i=0;
List list=[];
  if(box.containsKey("Todolist")){
    list=box.get("Todolist");
  for(var dt in list){
    if(dt["title"]==title){
    getController.data=[dt];
    i++;
    }
  
  }
  if(title.isEmpty){
    getController.data=list;
  }
  else if(i==0){
    getController.data=[];
  }
  }  
}
create(List data, bool edit){
 List list=[];
  if(box.containsKey("Todolist")){
    list=box.get("Todolist");
  if(edit){
for(int i=0;i<list.length;i++)
if(list[i]["title"]==data[0].text){
  //list.remove(dt);
list[i]={"title":data[0].text, "description":data[1].text, "priority":int.parse(data[2].text),"due_date":DateTime.parse(data[3].text)};
}
}
else{
list.add({"title":data[0].text, "description":data[1].text, "priority":int.parse(data[2].text),"due_date":DateTime.parse(data[3].text)});
box.put("Todolist",list);
}
  }
else{
list.add({"title":data[0].text, "description":data[1].text, "priority":int.parse(data[2].text),"due_date":DateTime.parse(data[3].text)});
box.put("Todolist",list);
getController.data=list;
}}
delete(String title){
List list=[];
  if(box.containsKey("Todolist")){
    list=box.get("Todolist");
    for(int i=0;i<list.length;i++){
      if(list[i]["title"]==title){
        list.removeAt(i);
      }
    getController.data=list;
    box.put("Todolist",list);
 
    }

  }
}
srt(String val){
  List list=[]; 
  if(box.containsKey("Todolist")){
  list=box.get("Todolist");
  if(val=="Priority"){
  for(int i=0;i<list.length-1;i++){
    for(int j=i+1;j<list.length;j++)
    if(list[i]['priority']>list[j]["priority"]){
      var a=list[i];
      list[i]=list[j];
      list[j]=a;
    }
  }
  }
  else{
  for(int i=0;i<list.length-1;i++){
    for(int j=i+1;j<list.length;j++)
    if(list[i]['due_date'].compareTo(list[j]["due_date"])>0){
      var a=list[i];
      list[i]=list[j];
      list[j]=a;
    }
  }  
  }
   getController.data=list;}
}
}