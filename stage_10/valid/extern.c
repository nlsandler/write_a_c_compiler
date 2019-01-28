int foo = 3;

int main() {
    int outer = 1;
    int foo = 0;
    if (outer) {
        extern int foo;
        return foo;
    }
    return 0;
}