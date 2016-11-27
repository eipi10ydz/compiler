
(*
 *  execute "coolc bad.cl" to see the error messages that the coolc parser
 *  generates
 *
 *  execute "myparser bad.cl" to see the error messages that your parser
 *  generates
 *)

class a {};
B {}
class a {};

class a <- {}
class A { };
class a {};




(* error: forget class... *)
 A {
};

(* error: forget semicolon and class... *)
 A {
}

(* error: b is not a type identifier *)
Class b inherits A {
};

(* error: keyword inherits is misspelled *)
Class D inherts A {
};

(* error: a is not a type identifier *)
Class C inherits a {
};

(* error: left brace is missing *)
Class E inherits A }
;

(* error: right brace is missing *)
Class E inherits A {
;

(* error: forget semicolon *)
class A {
}

(* error: none *)
class A {
a:Int;
};

(* error: forget semicolon of feature and class  *)
class A{
    f() : Int{ }
    x : Int;
    a > f(a / b * c + d - e);
}

(* error: expr error *)
class B{
    f(a : String) : Int {
        {
            a ++ b;
            a / b;
            e <- c - d;
            c <= d;
        }
    };
};

(* error: none *)
class A{
        x : Int;
        f(y : String) : Int
        {
            1
        };
};

(* error: case *)
class A{
        x : Int;
        f(y : String) : Int
        {
            let a : Int <- 1 in 1;
            case a of x : String => "string";
                      y : Int => 12;
        };
};
