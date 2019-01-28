static int foo() {
    return 3;
}

extern int foo();

int main() {
    return foo();
}