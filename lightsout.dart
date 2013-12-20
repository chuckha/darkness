import 'dart:html';

class Game {
  Board _board;
  List<Cell> _cells = [];
  int _width, _height;
  bool win = false;
  
  Game ({int width, height}) {
    if (height == null) {
      _height = 5;
    } else {
      _height = height;
    }
    if (width == null) {
      _width = 5;
    } else {
      _width = width;
    } 

    _board = new Board(_width, _height);
    
    for (int i=0;i<_height;i++) {
      for (int j=0;j<_width;j++) {
        Element div = new Element.div();
        int pos = i * _height + j;
        div.onClick.listen((e) {
          click(pos);
        });
        var cell = new Cell(div, pos);
        _cells.insert(pos, cell);
        _board.addCell(cell);
      }
    }
  }
  
  void click(int pos) {
    if (win) {return;}
    if (pos < 0) {return;}
    
    // light the cell above
    if (pos >= _height && pos <= _height * _width - 1) {
      _cells[pos - _width].light();
    }
    
    // light the cell below
    if (pos < (_height-1) * _width) {
      _cells[pos + _width ].light();
    }
    
    // light the cell to the left
    if (pos % _width != 0) {
      _cells[pos - 1].light();
    }

    // light the cell to the right
    if (pos % _width != (_width-1)) {
      _cells[pos + 1].light();
    }
    // light this cell
    _cells[pos].light();
    checkWin();
  }
  
  void setWinCells() {
    _cells.forEach((c) => c.addClass('winner'));
  }
  
  void checkWin() {
    if (_cells.every((c)=>c.on)) {
      win = true;
      setWinCells();
      querySelector('.lose').classes.toggle('lose');
    }
  }
}

class Board {
  int _height, _width;
  Element _game;
  
  Board(int width, height) {
    _width = width;
    _height = height;
    _game = querySelector('#game');
    _game.style.width = '${_width * 101}px';
  }
  
  addCell(Cell cell) {
    _game.children.add(cell.cell);
  }
}

class Cell {
  Element _cell;
  bool on = false;
  int _pos;
  
  Cell(Element cell, int pos) {
    _pos = pos;
    _cell = cell;
    _cell.className = 'cell';
    _cell.classes.add('off');
  }
  
  void light() {
    on = !on;
    _cell.classes.toggle('off');
  }

  void addClass(String cls) {
    _cell.classes.add(cls);
  }
  
  Element get cell => _cell;
}

void main() {
  Game g = new Game();
}