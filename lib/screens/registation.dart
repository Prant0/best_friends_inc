import 'package:flutter/material.dart';

class Registation_Page extends StatefulWidget {
  @override
  _Registation_PageState createState() => _Registation_PageState();
}

class _Registation_PageState extends State<Registation_Page> {

  final _formKey = GlobalKey<FormState>();
  String _username, _password,_number;
  bool _obscureText = true;

  void _submit(){
    //if (_formKey.currentState.validate()){
    final form=_formKey.currentState;
    if(form.validate()){
      form.save();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
           children: <Widget>[
             SizedBox(
               height: 20.0,
             ),
             Container(
                   height: 150,width: 200,
                   child: Image(
                     image: AssetImage('images/bf.png')
                   ),
                 ),
             Text('Register',style: TextStyle(fontSize: 42.0,fontWeight: FontWeight.w900,letterSpacing: 2),),
             Form(
               key: _formKey,
               child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 20.0),
               
                    child: TextFormField(
                      onSaved: (val)=>_username=val,
                      validator: (val)=>val.length<6 ? 'Username Too Short':null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        //  labelText: "Username",
                        hintText: 'Enter Full Name',
                        prefixIcon: Icon(Icons.face,color: Colors.teal),
                      ),
                    ),
                ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0,vertical: 10.0),
                    
                      child: TextFormField(
                        onSaved: (val)=>_number=val,
                        validator: (val)=>val.length<11 ? 'Mobile number Too Short':null,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          //  labelText: "Username",
                          hintText: 'Enter 11 Digits Mobile Number',
                          prefixIcon: Icon(Icons.phone,color: Colors.teal),
                        ),
                      ),

                    
                  ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                        child: TextFormField(
                          onSaved: (val)=>_password=val,
                          obscureText: _obscureText,
                          validator: (val)=> val.length < 6 ? "Password is too short":null,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText=!_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText?Icons.visibility:Icons.visibility_off,color: Colors.teal,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // labelText: "Password",
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock,color: Colors.teal,),
                            // icon: Icon(Icons.lock,color: Colors.teal,)

                          ),
                        ),
                      
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0),
                        child: TextFormField(
                          onSaved: (val)=>_password=val,
                          obscureText: _obscureText,
                          validator: (val)=> val.length < 6 ? "Password is too short":null,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText=!_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText?Icons.visibility:Icons.visibility_off,color: Colors.teal,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            // labelText: "Password",
                            hintText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock,color: Colors.teal,),
                            // icon: Icon(Icons.lock,color: Colors.teal,)

                          ),
                        ),
                      
                    ),

               ]
             ),
          ),
        Padding(
          padding: EdgeInsets.only(top:20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: 150.0,
                child: RaisedButton(
                  child: Text(
                    'Submit',style: TextStyle(color: Colors.white,fontSize: 20.0,),
                  ),color: Theme.of(context).primaryColor,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  onPressed: _submit,
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: RichText(
                  text: TextSpan(
                      text: " Existing User ?  ",
                      style: TextStyle(fontSize:16.0,color: Colors.black87,fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Login',style: TextStyle(fontSize:15.0,color: Colors.red,))
                      ]
                  ),
                )
              )
            ],
          ),
        ),
           ],
        ),
      ),
    );
  }
}
