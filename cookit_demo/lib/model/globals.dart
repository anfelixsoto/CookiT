class Globals{

  final List<String> apiKeys=['1e3d8937a2294ffd9e5730315989629f'];

  static String getKey(){
    Globals g=Globals.instance;
    int c=g.counter;
    g.incrementCounter();
    return g.apiKeys[c];
  }

  int counter;
  Globals._privateConstructor(){
    counter=0;
  }

  static final Globals _instance = Globals._privateConstructor();

  static Globals get instance { return _instance;}

  void incrementCounter(){
    if(counter<(_instance.apiKeys.length-1)){
      counter++;
    }
    else{
      counter=0;
    }
  }
}