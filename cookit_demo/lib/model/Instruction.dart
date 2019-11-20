class Instruction{
  String step;

  Instruction({this.step});

  factory Instruction.fromJson(Map<String, dynamic> json) {
    return new Instruction(
      step: json['step'],
    );
  }
}