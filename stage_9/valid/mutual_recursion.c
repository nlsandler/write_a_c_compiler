int foo(int a);
int bar(int b);

int main() {
    return foo(5);
}

int foo(int a) {
    if (a <= 0) {
        return a;
    }

    return a + bar(a - 1);
}

int bar(int b) {
    if (b <= 0) {
        return b;
    }

    return b + bar(b / 2);
}