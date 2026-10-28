class Demo {
    public static void main(String[] args) {
        int x = 1;
        if (x < 3) {
            x = x + 2;
        } else {
            x = x * 2;
        }
        for (int i = 0; i < 3; i = i + 1) {
            x = x + 1;
        }
    }
}
