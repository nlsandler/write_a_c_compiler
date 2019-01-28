int foo;

int main() {
    for (int i = 0; i < 3; i = i + 1)
        foo = foo + 1;
    return foo;
}