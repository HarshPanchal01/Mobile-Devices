class Student {
  String sid;
  String name;

  Student({required this.sid, required this.name});

  @override
  String toString() {
    return 'Student(Student ID: $sid, Name: $name)';
  }
}

class Character {
  String name;
  int hp;
  int defense;
  Character(this.name, this.hp, this.defense);

  String toString() {
    return name;
  }
}

mixin Magic {
  int magicDamage = 0;
  int mana = 0;

  int castSpell(Character character) {
    int damage = (magicDamage - character.defense);
    mana = mana - 10;
    character.hp = character.hp - damage;
    return damage;
  }
}

mixin Melee {
  int attackPower = 0;
  int stamina = 0;

  int attack(Character character) {
    stamina = stamina - 10;
    int damage = (attackPower - character.defense);
    character.hp = character.hp - damage;
    return damage;
  }
}

class Player extends Character with Magic {
  Player(name, hp, magicDamage, mana, defense) : super(name, hp, defense) {
    this.mana = mana;
    this.magicDamage = magicDamage;
  }
}

class Enemy extends Character with Melee {
  Enemy(name, hp, attackPower, stamina, defense) : super(name, hp, defense) {
    this.stamina = stamina;
    this.attackPower = attackPower;
  }
}

void main() {
  //Problem 1
  List<double> grades = [70, 80, 90, 60, 85, 75];
  List<double> newGrades = grades.map((g) => (g / 100) * 30 + 2).toList();
  print(newGrades);

  //Problem 2
  Student student = Student(sid: '123456789', name: 'John');
  print(student);

  //Problem 3 & 4
  List<int> numbers = [1, 2, 3, 4, 5];
  List<Student> students = numbers.map((number) {
    return Student(
      name: 'Student #$number', 
      sid: (100000000 + number).toString()
    );
  }).toList();
  for (student in students) {
    print(student);
  }

  //Problem 5 & 6
  Player player = Player('John', 100, 35, 45, 10);
  Enemy enemy = Enemy('Smith', 100, 40, 60, 20);
  int damage;
  damage = player.castSpell(enemy);
  print('Player: $player did $damage points of damage!');
  damage = enemy.attack(player);
  print('Enemy: $enemy did $damage points of damage!');
}