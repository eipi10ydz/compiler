(* error: while and feature error *)
class A{
--    b : Int <- if a = 2333 then 6666 else 1234 fi;
    while a = 1 lop a pool;
    x  Int;
};

(* error: if then else error *)
class B {
    a() : Int {
        if i = 0 then 123 ele 234 fi
    };
}

(* error: case error and semicolon missing *)
class C {
    a() : Int {case x() of a : Int > 4;
                b : String > "2333";
    easc}
    foo : Int {
        case A@yy() of 
            x : Int => 1234;
            y : Int = 123;
        esac;
    }
}