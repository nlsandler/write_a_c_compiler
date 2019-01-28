static int foo();

extern int foo() {
    return 2;
}

int main() {
    return foo();
}