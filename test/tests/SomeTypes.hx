package tests;

typedef Person = {
    name : String,
    age : Int
}

typedef Boss = {
    title : String,
    person : Person
}

// `to Boss` is important! FIXME
@:forward
abstract ABoss(Boss) to Boss {
}

class CBoss {
    public var title : String;
    public var person : Person;
}

interface IBoss {
    var title : String;
    var person : Person;
}

class CEBoss extends CBoss {
}

typedef Team = {
    name : String,
    boss : CBoss,
    people : Array<Person>
}

