int global_var = 3;

int main() {
    static int local = global_var;
    return local;
}