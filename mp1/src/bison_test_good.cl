class A {
};

Class BB__ inherits A {
};

class Foo {
	bar():Int{let a:Int in a + let b:String in b};
};

class Aa {
f():Int{{
a+b-c;
a-b+c;

a+b*c;
a*b+c;

a+b/c;
a/b+c;

a-b*c;
a*b-c;

a-b/c;
a/b-c;

a*b/c;
a/b*c;
}};
};

class Test {
  foo:Int;
  bar():Object{foo <- 3 };
};

class Mainn {
  x:Int;
  y:Int;
  m():Object { {x <- y <- ~(5);}};
};

class H {
   foo: Int;
   
   moo2(a:String, b:Int, c:Int, d:Int) : H {
      a + b + c + d
   };

};

class He {
   foo: Int;
   
   moo2(a:String, b:Int, c:Int, d:Int) : He {
      a - b - c - d
   };

};

class Hel {
   foo: Int;
   
   moo2(a:String, b:Int, c:Int, d:Int) : Hel {
      a * b * c * d
   };

};

class Helo {
   foo: Int;
   
   moo2(a:String, b:Int, c:Int, d:Int) : Helo {
      a / b / c / d
   };

};

(*
   The class A2I provides integer-to-string and string-to-integer
conversion routines.  To use these routines, either inherit them
in the class where needed, have a dummy variable bound to
something of type A2I, or simpl write (new A2I).method(argument).
*)


(*
   c2i   Converts a 1-character string to an integer.  Aborts
         if the string is not "0" through "9"
*)
class A2I {

     c2i(char : String) : Int {
	if char = "0" then 0 else
	if char = "1" then 1 else
	if char = "2" then 2 else
        if char = "3" then 3 else
        if char = "4" then 4 else
        if char = "5" then 5 else
        if char = "6" then 6 else
        if char = "7" then 7 else
        if char = "8" then 8 else
        if char = "9" then 9 else
        { abort(); 0; }  -- the 0 is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   i2c is the inverse of c2i.
*)
     i2c(i : Int) : String {
	if i = 0 then "0" else
	if i = 1 then "1" else
	if i = 2 then "2" else
	if i = 3 then "3" else
	if i = 4 then "4" else
	if i = 5 then "5" else
	if i = 6 then "6" else
	if i = 7 then "7" else
	if i = 8 then "8" else
	if i = 9 then "9" else
	{ abort(); ""; }  -- the "" is needed to satisfy the typchecker
        fi fi fi fi fi fi fi fi fi fi
     };

(*
   a2i converts an ASCII string into an integer.  The empty string
is converted to 0.  Signed and unsigned strings are handled.  The
method aborts if the string does not represent an integer.  Very
long strings of digits produce strange answers because of arithmetic 
overflow.

*)
     a2i(s : String) : Int {
        if s.length() = 0 then 0 else
	if s.substr(0,1) = "-" then ~a2i_aux(s.substr(1,s.length()-1)) else
        if s.substr(0,1) = "+" then a2i_aux(s.substr(1,s.length()-1)) else
           a2i_aux(s)
        fi fi fi
     };

(*
  a2i_aux converts the usigned portion of the string.  As a programming
example, this method is written iteratively.
*)
     a2i_aux(s : String) : Int {
	(let int : Int <- 0 in	
           {	
               (let j : Int <- s.length() in
	          (let i : Int <- 0 in
		    while i < j loop
			{
			    int <- int * 10 + c2i(s.substr(i,1));
			    i <- i + 1;
			}
		    pool
		  )
	       );
              int;
	    }
        )
     };

(*
    i2a converts an integer to a string.  Positive and negative 
numbers are handled correctly.  
*)
    i2a(i : Int) : String {
	if i = 0 then "0" else 
        if 0 < i then i2a_aux(i) else
          "-".concat(i2a_aux(i * ~1)) 
        fi fi
    };
	
(*
    i2a_aux is an example using recursion.
*)		
    i2a_aux(i : Int) : String {
        if i = 0 then "" else 
	    (let next : Int <- i / 10 in
		i2a_aux(next).concat(i2c(i - next * 10))
	    )
        fi
    };

};

class Tes {
  foo:Tes;
  bar():Int { case foo.bar() of y:Int => 3;
                                z:String => 4;
                                x:Tes => 5; esac };
};

class Hello {

   cow(a:Int) : SELF_TYPE {
      self
   };

};

class Helloo {
   foo: Int;
};

class Hellooo {
   foo: Int;
   bar: String;
};

class Test {
  foo:Test;
  bar():Int { {x = (3 < 4) ;}};
};

class Main inherits IO {
    main() : SELF_TYPE {
	(let c : Complex <- (new Complex).init(1, 1) in
	    if c.reflect_X().reflect_Y() = c.reflect_0()
	    then out_string("=)\n")
	    else out_string("=(\n")
	    fi
	)
    };
};

class Complex inherits IO {
    x : Int;
    y : Int;

    init(a : Int, b : Int) : Complex {
	{
	    x = a;
	    y = b;
	    self;
	}
    };

    print() : Object {
	if y = 0
	then out_int(x)
	else out_int(x).out_string("+").out_int(y).out_string("I")
	fi
    };

    reflect_0() : Complex {
	{
	    x = ~x;
	    y = ~y;
	    self;
	}
    };

    reflect_X() : Complex {
	{
	    y = ~y;
	    self;
	}
    };

    reflect_Y() : Complex {
	{
	    x = ~x;
	    self;
	}
    };
};

class Testtt {
  foo:Testtt;
  bar(x:Int,y:Int,z:Int):Object{foo.bar(x,y,z)};
};

class Testttt {
  foo:Testttt;
  bar():Object{foo.bar()};
};

class Test {
  foo:Test;
  bar(x:Baz):Object{foo.bar(x)};
};

class Test {
  foo:Test;
  bar():Int { if x = 3 then {1; 2; true;} else false fi};
};

class Test {
  foo:Test;
  bar():Int { if x = 3 then {if x < 2 then new Foo else isvoid baz fi;} else false fi};
};

class Test {
  foo:Test;
  baz():String { let x:Int <- 5 in x};
};

class Test {
  foo:Test;
  baz():String { let x:Int in x};
};

class Foo {
	bar():Int{{let a:Int in (a + b);
		(let a:Int in a) + b;
		let a:Int in (a) + (b);}};
};

class A {
  f() : Object { {
    e@A.f();
    e1@B.g(1);
    e2@C.h(1, 2);
    e3@D.f(1, 2, 3);
    x.f();
    y.g(true, false);
    z.h(1, 2, 3, 4);
  } };
};

class A {
  x : Int;
  y : Bool;
  z : Object;
  f() : Bool {
    true
  };
  a : String;
  a : IO;
};

class A {
  f() : Int { {
    g();
    h(x);
    f(2, 3);
    f(3, 4, 5);
    z(1, 2, 3, 4, 5);
  } };
};

class A {

f():Int{
	{
		{1;{2;3;};};
		{{{4;};};};
	}
};

};

class A {
  f(x : Int) : Object {
    let x : Int <- 3 in
      let y : Bool, z : Object in
        let a : Object, b : Object, c : Object in
          let d : Int <- 6 in
            d + 5
  };
};

class Test {
  foo:Int;
  bar():Object{self@Test.bar()};
};

class Foo {
	bar():Int{{isvoid a + b * c;
		not a < b;
		~a + b;
		}};
};

class Test {
  foo:Test;
  bar():Int { while (not false) loop {1;2;3;4;5;} pool};
};

class Test {
  foo:Test;
  bar():Int { while (not false) loop ("Ooga booga") pool};
};
