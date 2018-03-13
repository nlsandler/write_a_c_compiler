int main() {
    int a = 2;
    int b = 3;
    {
        int a = 1;
        b = b + a;
    }
    return b;
}