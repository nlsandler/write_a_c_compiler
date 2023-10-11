# Write a C Compiler!

**This repo is no longer active. The latest version of this test suite, which accompanies the [Writing a C Compiler book](https://nostarch.com/writing-c-compiler), is available [here](https://github.com/nlsandler/writing-a-c-compiler-tests/).**

This is a set of C test programs to help you write your own compiler. They were written to accompany [this tutorial](https://norasandler.com/2017/11/29/Write-a-Compiler.html).

## Usage

### test all
```
./test_compiler.sh /path/to/your/compiler
```

### test specific stages
To test stage 1 and stage 3,
```
./test_compiler.sh /path/to/your/compiler 1 3
```
To test from stage 1 to stage 6,
```
./test_compiler.sh /path/to/your/compiler `seq 1 6`
```

In order to use this script, your compiler needs to follow this spec:

1. It can be invoked from the command line, taking only a C source file as an argument, e.g.: `./YOUR_COMPILER /path/to/program.c`

2. When passed `program.c`, it generates executable `program` in the same directory.

3. It doesn’t generate assembly or an executable if parsing fails (this is what the test script checks for invalid test programs).

The script doesn’t check whether your compiler outputs sensible error messages, but you can use the invalid test programs to test that manually.

## Contribute

Additional test cases welcome! You can also file issues here, either about the test suite itself or about the content of the tutorial.
