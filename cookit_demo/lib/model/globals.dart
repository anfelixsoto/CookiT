class Globals{
  int counter;
  Globals._privateConstructor(){
    counter=0;
  }

  static final Globals _instance = Globals._privateConstructor();

  static Globals get instance { return _instance;}
  void incrementCounter(){
    if(counter<1){
      counter++;
    }
    else{
      counter=0;
    }
  }
}