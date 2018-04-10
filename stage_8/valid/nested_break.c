int main() {
    int ans = 0;
    for (int i = 0; i < 10; i = i + 1)
        for (int j = 0; j < 10; j = j + 1)
            if (i % 2 == 0)
                break;
            else
                ans = ans + i;
    return ans;
}