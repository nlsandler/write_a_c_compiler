extern int foo;

int foo;

int main() {
    for (int i = 0; i < 5; i = i + 1)
        foo = foo + 1;
    return foo;
}