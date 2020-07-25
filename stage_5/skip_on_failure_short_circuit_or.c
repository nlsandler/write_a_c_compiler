int main() {
    int a = 1;
    int b = 0;
    a || (b = 5);
    return b;
}