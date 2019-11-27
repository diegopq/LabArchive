import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double _screenWidth;
  static double _screenHeigth;
  static double _blockWidth = 0;
  static double _blockHeight = 0;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heigthMultiplier;
  static double widthMultiplier;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(
      {@required BoxConstraints constraints,
      @required Orientation orientation}) {
    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeigth = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        //si es celular, mayores a 450 son tabletas
        isMobilePortrait = true;
      }
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeigth = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;
    }

//La pantalla la divide imaginariamente en bloques, y el numero de bloques esta dado
//por la division, si la pantalla mide 600 horizontalmente, habria 6 bloques
//esto nos da el valor proporcional en el que se van a escalar los widgets,
    _blockWidth = _screenWidth / 100;
    _blockHeight = _screenHeigth / 100;

//se usan a lo largo del programa
    textMultiplier = _blockWidth;
    imageSizeMultiplier = _blockHeight;
    heigthMultiplier = _blockHeight;
    widthMultiplier = _blockWidth;

    print('width: $widthMultiplier');
    print('height: $heigthMultiplier');
    print('image: $imageSizeMultiplier');
    print('text: $textMultiplier');
  }
}