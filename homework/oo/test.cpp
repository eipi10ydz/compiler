#include <iostream>

using std::cout;
using std::endl;

struct Base
{
    int b;
    void t() {}
    virtual void test() { cout << "Base" << endl; }
};

struct Inherit1 : Base
{
    int i1;
    void test() { cout << "Inherit1" << endl; }
};

struct Inherit2 : Base
{
    int i2;
    void test() { cout << "Inherit2" << endl; }
};

struct Inherit3 : virtual Base
{
    int i3;
    void test() { cout << "Inherit3" << endl; }
};

struct Inherit4 : virtual Base
{
    int i4;
    void test() { cout << "Inherit4" << endl; }
};

struct Inherit : Inherit1, Inherit2
{
    int i;
    void test() { cout << "Inherit" << endl; }
};

struct InheritWithVirtual : Inherit3, Inherit4
{
    int iwv;
    void test() { cout << "Inherit with virtual" << endl; }
};

int main()
{
    Base b;
    Inherit inherit;
    InheritWithVirtual inheritwithvirtual;

    cout << "虚继承" << endl;
    cout << "InheritWithVirtual: " << &inheritwithvirtual << endl;
    cout << "t: " << (void*)(&InheritWithVirtual::t) << endl;
    cout << "test: " << (void*)(&InheritWithVirtual::test) << endl;
    cout << "b: " << &inheritwithvirtual.b << endl;
    cout << "i3: " << &inheritwithvirtual.i3 << endl;
    cout << "i4: " << &inheritwithvirtual.i4 << endl;
    cout << "iwv: " << &inheritwithvirtual.iwv << endl;

    cout << endl;
    cout << "多继承" << endl;
    cout << "Inherit: " << &inherit << endl;
    cout << "Inherit1::t: " << (void*)(&Inherit::Inherit1::t) << endl;
    cout << "Inherit2::t: " << (void*)(&Inherit::Inherit2::t) << endl;
    cout << "test: " << (void*)(&Inherit::test) << endl;
    cout << "Inherit1::b: " << &inherit.Inherit1::b << endl;
    cout << "Inherit2::b: " << &inherit.Inherit2::b << endl;
    cout << "i1: " << &inherit.i1 << endl;
    cout << "i2: " << &inherit.i2 << endl;
    cout << "i: " << &inherit.i << endl;

    inherit.test();
    inherit.Inherit2::test();
}
