(* error: let, feature, expr error *)
class LetErr
{
    err() : Int {
        {
            let a  Int <- 123 i
                let b : String <- 2333 in
                    b <= a;
            let b : Int <- in 6666;
        }
    }
    x : Feature <- neew fFeature;
    isvoid F2333;
    y <- False;
    let a :Bool <- True in a;
};

(* error: class not completed and in-class error *)
class
class;
class A{
    {123}
    {x : 661}
};

(* error: feature, formal error *)
class Feature
{
    a <-;
    testF(x : Isl <- ) : Int {;
    testF(x Isl,) :;
    s() : {}
    Int;
    s String;
    s :
}