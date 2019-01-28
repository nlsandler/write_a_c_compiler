int foo(int a) {
    static int s = a + 1;
    return s;
}

int main() {
    return foo(1);
}