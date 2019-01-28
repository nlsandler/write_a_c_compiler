int foo() {
    static int x = 0;
    x = x + 1;
    return x;
}

int main() {
    int ret;
    for (int i = 0; i < 4; i = i + 1)
        ret = foo();
    return ret;
}