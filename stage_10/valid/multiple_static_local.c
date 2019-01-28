int foo() {
    static int a = 3;
    a = a * 2;
    return a;
}

int bar() {
    static int a = 4;
    a = a + 1;
    return a;
}

int main() {
    return foo() + foo() + bar() + bar();
}