import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner:!true,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool init=false;
  bool error=false;
  String getPass;
  String getEmail;

  void initializeApp() async{
    try{
      await Firebase.initializeApp();
      setState(() {
        init=true;
      });
    }catch(e){
      setState(() {
        error=true;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    initializeApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     if(error){
       return Container(
         color:Colors.white,
         child:Center(
           child: Container(
             width:56,
             height:56,
             child: CircularProgressIndicator(
             ),
           ),
         ),
       );
     }
     if(!init){
       return Container(
         color:Colors.white,
         child:Center(
           child: Container(
             width:56,
             height:56,
             child: CircularProgressIndicator(
               backgroundColor:Colors.orange,
             ),
           ),
         ),
       );
     }

     return Scaffold(
       resizeToAvoidBottomPadding: false,
       backgroundColor:Colors.white,
       body:Center(
         child: Container(
           child:Column(
             children: <Widget>[
               SizedBox(height:70,),
               FlutterLogo(
                 size:76.0,
               ),
               SizedBox(height:12,),
               Row(
                 children: <Widget>[

                   Padding(
                       padding:EdgeInsets.only(left:12),

                       child: Text("Login",style:GoogleFonts.raleway(color:Colors.black,fontSize:24,fontWeight:FontWeight.bold),)),
                 ],
               ),
               SizedBox(height:7,),
               Column(
                 children: <Widget>[

                 ],
               ),

               Row(
                 children: <Widget>[
                   Padding(
                     padding:EdgeInsets.only(left:12),
                     child:Text("Join our community",style:GoogleFonts.raleway(color:Colors.black,fontSize:13),),

                   ),
                 ],
               ),
               SizedBox(height:9,),
               Column(
                 children: <Widget>[
                   Padding(
                       padding:EdgeInsets.all(12.5),
                       child:Flex(
                         direction:Axis.horizontal,
                         children: <Widget>[
                           Expanded(
                             child: TextField(
                               decoration:InputDecoration(
                                   hintText:"Enter your email",
                                   border:OutlineInputBorder(),
                                   icon:Icon(Icons.supervisor_account)
                               ),
                               onChanged:(String val){
                                 setState(() {
                                   getEmail =val;
                                 });
                               },

                             ),
                           ),
                         ],
                       )
                   ),
                   Padding(
                       padding:EdgeInsets.all(12.5),
                       child:Flex(
                         direction:Axis.horizontal,
                         children: <Widget>[
                           Expanded(
                             child: TextField(
                               obscureText: true,
                               decoration:InputDecoration(
                                   hintText:"Enter your password",
                                   border:OutlineInputBorder(),
                                   icon:Icon(Icons.lock)
                               ),
                               onChanged:(String val){
                                 setState(() {
                                   getPass =val;
                                 });
                                 print(getPass);
                               },
                             ),
                           ),
                         ],
                       )
                   ),

                   SizedBox(
                     height:6,
                   ),
                   SignInButton(
                       buttonType: ButtonType.mail,
                       btnText:"Login with account",
                       onPressed: () async {
                         try{
                           UserCredential _userCredential=await FirebaseAuth.instance.signInWithEmailAndPassword(
                               email:getEmail, password:getPass
                           );
                         }on FirebaseAuthException catch(e){
                           if(e.code == 'weak-password'){
                             //snackbar
                           }
                           else if(e.code == 'email-already-in-use'){
                             //snackbar
                           }
                         }
                         catch(e){
                           print(e.toString());
                         }
                       }),
                   SizedBox(
                     height:15,
                   ),
                   Padding(
                       padding:EdgeInsets.all(12.5),
                       child: GestureDetector(
                         onTap:(){
                           Navigator.push(context,MaterialPageRoute(
                             builder:(_){
                               return createAccount();
                             }
                           ));
                         },
                           child: Text("Don't have account?create one"))
                   )
                 ],
               ),


               SizedBox(height:25,),
               Expanded(
                 child: Column(
                   children: <Widget>[

                     SignInButton(
                         buttonType: ButtonType.google,
                         onPressed: () async{
                           final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

                           // Obtain the auth details from the request
                           final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

                           // Create a new credential
                           final GoogleAuthCredential credential = GoogleAuthProvider.credential(
                             accessToken: googleAuth.accessToken,
                             idToken: googleAuth.idToken,
                           );

                           // Once signed in, return the UserCredential
                           return await FirebaseAuth.instance.signInWithCredential(credential);

                         }),

                   ],
                 ),
               )

             ],
           ),
         ),
       ),
     );

  }
}
class createAccount extends StatefulWidget {
  @override
  _createAccountState createState() => _createAccountState();
}

class _createAccountState extends State<createAccount> {
  String getEmail;
  String getPass;
  bool isCreated=false;
  void snack(String str){
    SnackBar snackbar=SnackBar(
      content:Text("Hello"),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor:Colors.white,
      appBar:AppBar(
        elevation:0.0,
        backgroundColor:Colors.white,
        iconTheme:IconThemeData(
          color:Colors.grey
        ),
      ),
      body:Center(
        child: Container(
          child:Column(
            children: <Widget>[
              SizedBox(height:1,),
              FlutterLogo(
                size:76.0,
              ),
              SizedBox(height:12,),
              Row(
                children: <Widget>[

                  Padding(
                      padding:EdgeInsets.only(left:12),

                      child: Text("Registration",style:GoogleFonts.raleway(color:Colors.black,fontSize:24,fontWeight:FontWeight.bold),)),
                ],
              ),
              SizedBox(height:7,),
              Column(
                children: <Widget>[

                ],
              ),

              Row(
                children: <Widget>[
                  Padding(
                    padding:EdgeInsets.only(left:12),
                    child:Text("Create our account",style:GoogleFonts.raleway(color:Colors.black,fontSize:13),),
                  ),
                ],
              ),
              SizedBox(height:9,),
              Column(
                children: <Widget>[
                  Padding(
                      padding:EdgeInsets.all(12.5),
                      child:Flex(
                        direction:Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration:InputDecoration(
                                  hintText:"Enter your email",
                                  border:OutlineInputBorder(),
                                  icon:Icon(Icons.supervisor_account)
                              ),
                              onChanged:(String val){
                                setState(() {
                                  getEmail =val;
                                });
                              },

                            ),
                          ),
                        ],
                      )
                  ),
                  Padding(
                      padding:EdgeInsets.all(12.5),
                      child:Flex(
                        direction:Axis.horizontal,
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              obscureText: true,
                              decoration:InputDecoration(
                                  hintText:"Enter your password",
                                  border:OutlineInputBorder(),
                                  icon:Icon(Icons.lock)
                              ),
                              onChanged:(String val){
                                setState(() {
                                  getPass =val;
                                });
                                print(getPass);
                              },
                            ),
                          ),
                        ],
                      )
                  ),

                  SizedBox(
                    height:6,
                  ),
                  SignInButton(
                      buttonType: ButtonType.mail,
                      btnText:"Create our account",
                      onPressed: () async {
                        try{
                          UserCredential _userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email:getEmail, password:getPass
                          );
                          setState(() {
                            getEmail=null;
                            getPass=null;

                          });

                        }on FirebaseAuthException catch(e){
                         
                          if(e.code == 'weak-password'){
                            Flushbar(
                              backgroundColor:Colors.red,
                              message:  "Weak password",
                              duration:  Duration(seconds:2),
                            )..show(context);
                          }
                          else if(e.code == 'email-already-in-use'){Flushbar(
                            backgroundColor:Colors.red,
                            message:  "Email is already used ",
                            duration:  Duration(seconds:2),
                          )..show(context);
                          }
                          print('Leerreru est${e.message}');
                        }
                      }),

                ],
              ),



            ],
          ),
        ),
      ),
    );
  }

}
class Principal extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}




