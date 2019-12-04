class UserModel {
//atributos
  String _name;
  String _lastName;
  String _nue;
  String _email;
  String _password;

//setters
  set setName(String value) {
    _name = value;
  }

  set setLastName(String value) {
    _lastName = value;
  }

  set setNue(String value) {
    _nue = value;
  }

  set setEmail(String value) {
    _email = value;
  }

  set setPass(String value) {
    _password = value;
  }

//getters

  get name => _name;
  get lastName => _lastName;
  get nue => _nue;
  get email => _email;
  get password => _password;

  void showUserData() {
    print(
        'nombre: $_name\napellido: $_lastName\nnue: $_nue\nemail: $_email\npass: $_password');
  }
}
