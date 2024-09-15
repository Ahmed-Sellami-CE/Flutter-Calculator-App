import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key:key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true
      ),
      home: const HomePage(title: "Calculator"),
      debugShowCheckedModeBanner: false,

    );
  }
}
class HomePage extends StatefulWidget{
  const HomePage({Key? key, required String title}):super(key:key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  String text="Enter a number : ";
  int result=0,prev=0;
  STATES operation=STATES.NOTHING;
  bool equalMode=false;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Calculator")),
        body: Center(
      child: Container(
        color: Colors.blue[100],
        child: Column(
        children: [Container(
            margin: EdgeInsets.only(left:10,right:10,top:20,bottom:14),
            padding: EdgeInsets.only(left:0,bottom:0,right:10,top:0),
            alignment: Alignment.topRight,
            decoration: BoxDecoration(color: Colors.redAccent,borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(text,style: TextStyle(fontFamily: "arial",fontSize:25,color:Colors.white),textAlign: TextAlign.right,)
        ),
          Container(
           child: StaggeredGrid.count(crossAxisCount: 3,crossAxisSpacing: 70.0,mainAxisSpacing: 10.0,
                children: List.generate(values.length,(index)=>
                  StaggeredGridTile.count(
                      crossAxisCellCount: values[index].text=="="?3:1,
                  mainAxisCellCount: 0.57,
                  child: SelectCard(value:values[index],state:this))))
             ),
          ]
      ))
    ));
  }
}

class Value {
  final int val;
  final bool isInt;
  final String? text;
  const Value({required this.val,required this.isInt,required this.text});
}

List<Value> values = [
  const Value(val:1,isInt:true,text:null),
  const Value(val:2,isInt:true,text:null),
  const Value(val:3,isInt:true,text:null),
  const Value(val:4,isInt:true,text:null),
  const Value(val:5,isInt:true,text:null),
  const Value(val:6,isInt:true,text:null),
  const Value(val:7,isInt:true,text:null),
  const Value(val:8,isInt:true,text:null),
  const Value(val:9,isInt:true,text:null),
  const Value(val:0,isInt:true,text:null),
  const Value(val:0,isInt:false,text:"C"),
  const Value(val:0,isInt:false,text:"+"),
  const Value(val:0,isInt:false,text:"-"),
  const Value(val:0,isInt:false,text:"*"),
  const Value(val:0,isInt:false,text:"/"),
  const Value(val:0,isInt:false,text:"="),

];

enum STATES {
  NOTHING,
  ADD,
  SUB,
  MULT,
  DIV
}

class SelectCard extends StatelessWidget {

  const SelectCard({Key? key,required this.value, required this.state}):super(key:key);
  final Value value;
  final _HomePageState state;

  @override
  Widget build(BuildContext context){
    return GestureDetector(
        child: Card(child:Container(child: Center(child:Text(value.isInt?"${value.val}":value.text!,textAlign: TextAlign.center,style: TextStyle(fontSize:30),)),width: 60,height:60)
          ,color: value.isInt?Colors.white:value.text=="C"?Colors.yellow:value.text=="+"?Colors.blue:value.text=="="?Colors.green:value.text=="-"?Colors.cyan:value.text=="*"?Colors.redAccent:Colors.limeAccent,),
        onTap: ()=> state.setState(() {
          if(value.text=="+" && RegExp(r'[0-9]+').hasMatch(state.text)) {
            state.operation = STATES.ADD;
            state.prev=int.parse(state.text);
            state.result+=state.result==0?state.prev:0;
            state.text="Enter a number : ";
            state.equalMode=false;
          }else if(value.text=="-" && RegExp(r'[0-9]+').hasMatch(state.text)){
            state.operation = STATES.SUB;
            state.prev=int.parse(state.text);
            state.result+=state.result==0?state.prev:0;
            state.text="Enter a number : ";
            state.equalMode=false;
        }else if(value.text=="*" && RegExp(r'[0-9]+').hasMatch(state.text)) {
            state.operation = STATES.MULT;
            state.prev = int.parse(state.text);
            state.result += state.result == 0 ? state.prev : 0;
            state.text = "Enter a number : ";
            state.equalMode = false;
          }else if(value.text=="/" && RegExp(r'[0-9]+').hasMatch(state.text)) {
            state.operation = STATES.DIV;
            state.prev = int.parse(state.text);
            state.result += state.result == 0 ? state.prev : 0;
            state.text = "Enter a number : ";
            state.equalMode = false;
          } else if(value.text=="="){
            if(!state.equalMode) state.prev=int.parse(state.text);
            switch(state.operation){
              case STATES.ADD: state.result+=state.prev;break;
              case STATES.SUB: state.result-=state.prev;break;
              case STATES.MULT: state.result*=state.prev;break;
              case STATES.DIV: state.result=(state.prev!=0?state.result/state.prev:0).toInt();break;
              case STATES.NOTHING:
                // TODO: Handle this case.
            }
            state.text="${state.result}";
            state.equalMode=true;
          } else if(value.text=="C"){
            state.operation==STATES.NOTHING;
            state.result=0;
            state.prev=0;
            state.equalMode=false;
            state.text="Enter a number : ";
          }else {
            state.text = !RegExp(r'^[0-9]+$').hasMatch(state.text) || state.text == "0" ? "${value.val}" : state.text + "${value.val}";
            state.equalMode=false;
          }
        }));
  }

}

