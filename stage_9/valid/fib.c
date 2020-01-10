int fib(int n) {
    if (n == 0 || n == 1) {
        return n;
    } else {
        return fib(n - 1) + fib(n - 2);
    }
    return -1;
}

int main() {
    int n = 5;
    return fib(n);
}