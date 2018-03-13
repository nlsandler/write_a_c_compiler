int main(){
    int a = 2;
    if (a < 3) {
        {
            int a = 3;
            return a;
        }
        return a;
    }
}