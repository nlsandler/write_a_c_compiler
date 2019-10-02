int main() {
    int sum = 0;
    for (int i = 0; i < 10; i = i + 1) {
        if ((sum / 2) * 2 != sum)
            continue;
        sum = sum + i;
    }
    return sum;
}