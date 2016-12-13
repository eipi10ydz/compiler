#include <iostream>
#include <utility>
#include <vector>

namespace {
    int heihei()
    {
        return 23333;
    }
    
}

namespace nihao {
    int heihei()
    {
        return 23333;
    }
}

namespace {
    int haha()
    {
        return 66666;
    }
}

struct _GLOBAL__N_1
{
    _GLOBAL__N_1& operator()(int)
    {
        return *this;
    }
    void zsy()
    {

    }
    int haha()
    {
        return 66667;
    }
};

struct Base
{
    int *p;
    std::string *s;

    Base() : p(new int(2333)) { }

    Base(int i) : p(new int(i)) { }

    Base(const Base &rhs)
    {
        if (rhs.p)
            p = new int(*rhs.p);
        else
            p = nullptr;
    }
    Base(Base &&rhs) noexcept : p(rhs.p) { rhs.p = nullptr; }

    Base& operator=(const Base &rhs)
    {
        if (rhs.p)
            p = new int(*rhs.p);
        else
            p = nullptr;
        return *this;
    }

    Base& operator=(Base &&rhs)
    {
        p = rhs.p;
        rhs.p = nullptr;
        return *this;
    }

    Base operator+(const Base &rhs) const
    {
        Base res;
        int tmp = *res.p;
        *res.p = 0;
        if (p)
        {
            *res.p += *p;
        }
        if (rhs.p)
        {
            *res.p += *rhs.p;            
        }
        if (*rhs.p == 0)
            *res.p = tmp;
        return res;
    }

    Base operator*(const Base &rhs)
    {
        Base res;
        if (!p || !rhs.p)
        {
            return Base(0);
        }
        return Base(*p * *rhs.p);
    }

    Base operator/(const Base &rhs)
    {
        Base res;
        if (!p || !rhs.p)
        {
            return Base(0);
        }
        return Base(*p / *rhs.p);
    }

    Base operator-(const Base &rhs)
    {
        Base res;
        if (!p || !rhs.p)
        {
            return Base(0);
        }
        return Base(*p - *rhs.p);
    }

    bool operator<(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p < *rhs.p;        
    }

    bool operator<=(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p <= *rhs.p;        
    }

    bool operator>(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p > *rhs.p;        
    }

    bool operator>=(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p >= *rhs.p;        
    }

    bool operator==(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p == *rhs.p;        
    }

    Base& operator+=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator-=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator*=(const Base &rhs)
    {
        return *this;        
    }
    
    Base& operator/=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator%=(const Base &rhs)
    {
        return *this;        
    }
    
    Base& operator|=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator|(const Base &rhs)
    {
        return *this;        
    }

    Base& operator&(const Base &rhs)
    {
        return *this;        
    }

    Base& operator~()
    {
        return *this;        
    }

    Base& operator&=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator>>=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator<<=(const Base &rhs)
    {
        return *this;        
    }

    Base& operator!()
    {
        return *this;        
    }

    Base& operator^(const Base &rhs)
    {
        return *this;
    }

    Base& operator^=(const Base &rhs)
    {
        return *this;
    }

    bool operator!=(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p != *rhs.p;        
    }
        
    bool operator%(const Base &rhs)
    {
        if (!p || !rhs.p)
        {
            return false;
        }
        return *p % *rhs.p;        
    }

    Base& operator++()
    {
        if (p)
            ++*p;
        return *this;
    }

    Base operator++(int)
    {
        if (p)
        {
            return Base((*p)++);
        }
        return Base(0);
    }

    Base& operator--()
    {
        if (p)
            --*p;
        return *this;
    }

    Base operator--(int)
    {
        if (p)
        {
            return Base((*p)--);
        }
        return Base(0);
    }

    int operator()()
    {
        if (p)
            return *p;
        else
            return 0;
    }

    std::string& operator*() const
    {
        return *s;
    }

    std::string* operator->() const
    {
        return & this -> operator*();
    }

    std::string operator[](const int)
    {
        return "test";
    }

    std::string operator[](const double)
    {
        return "test";
    }

    std::string operator[](const Base*)
    {
        return "test";
    }

    std::ostream& operator<<(std::ostream &os)
    {
        if (p)
            os << *p;
        return os;
    }

    std::istream& operator>>(std::istream &is)
    {
        if (p)
            is >> *p;
        return is;
    }

    std::string operator()(int, float, double, bool)
    {
        return "test";
    }

    std::string operator()(std::string, std::vector<Base*>, int(*)(int))
    {
        return "test";
    }

    std::string operator()(const char**, const short***)
    {
        return "test";
    }

    operator int() noexcept
    {
        return p ? *p : 0;
    }

    static void test(){ }

    virtual ~Base()
    { 
        if (p)
            delete p;
    }
};

struct Inherit : Base
{
    long *pl;
    Inherit() : pl(new long(0)) {  }
    Inherit(Base) {  }
    void operator()(long, long long) { (*this)("heihei"); }
    Inherit(int, Inherit&) { }
protected:
    int* operator()(char* c) { }

};

struct Inheri : Base
{
    long long *q;
    Inheri(Inheri&) = delete;
    Inheri() : q(new long long(0)) { }
};

struct ___ : Base
{
    bool *gs;
    ___() : gs(new bool(false)) { }
};

struct $__ : Base
{
    bool *gs;
    $__() : gs(new bool(false)) { }
};

int hehe(int)
{
    return 66666;
}

int main()
{
   std::cout << "1234";
   std::printf("1234\n");
   Base b, b1, b2;
   b = b1 + b2;
   b = b1 - b2;
   b = b1 * b2;
   b = b1 / b2;
   b1 == b2;
   b1 <<= b2;
   b1 >>= b2;
   b1 != b2;
   b1 < b2;
   b1 <= b2;
   b1 > b2;
   b1 >= b2;
   b1 % b2;
   b1 %= b2;
   b1 += b2;
   b1 -= b2;
   b1 *= b2;
   b1 /= b2;
   b1 | b2;
   b1 & b2;
   ~b1;
   const char **ppp;
   const short ***pp;
   b1(ppp, pp);
   !b1;
   b1 ^ b2;
   b1 ^= b2;
   b1 &= b2;
   b1 |= b2;
   b << std::cout;
   b >> std::cin;
   b1++;
   b2--;
   ++b2;
   --b1;
   *b1;
   b1->size();
   b1[2333];
   b2[233.0];
   b1[const_cast<const Base*>(&b2)];
   b();
   auto hdaadjklfjdkljafkljflkfjalkdjaslkdjalskjdlkasjdsalkdjaklsjdlaksdsjakldjalkdjalk = [=](bool){return true;};
   auto f = [](int i) -> int { return 2333; };
   auto g = [&]() {return (*b.p)++;};
   auto flxg = []() { auto z = [](){ return "apre"; }; z(); return "flxg-apre"; };
   flxg();
   b(1, 1.0f, 1.2, true);
   b("hq", {&b}, f);
   f(23333);
   hdaadjklfjdkljafkljflkfjalkdjaslkdjalskjdlkasjdsalkdjaklsjdlaksdsjakldjalkdjalk(true);
   g();
   b.test();
   Base::test();
   (int)b;
   Base btest(b);
   Base bmtest(std::move(b));
   bmtest = btest;
   btest = std::move(bmtest);
   Inherit gs;
   auto f1 = Inherit(b);
   Inherit bgl(2333, gs);
   gs(1, 2);
   Inheri test;
   ___ kp;
   $__ zy;
   hehe(23333);
   heihei();
   haha();
   nihao::heihei();
   *b.p = 23333;
   _GLOBAL__N_1 tttt;
   tttt.haha();
   tttt(23333);
}
