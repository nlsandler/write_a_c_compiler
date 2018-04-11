int main() {
    int i = 0;
    int j = 0;
    for (i = 0; i < 10; i = i + 1) {
        int k = i;
        for (int i = k; i < 10; i = i + 1)
            j = j + 1;
    }
    return j + i;
}