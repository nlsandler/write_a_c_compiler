#!/bin/bash

padding_dots=$(printf '%0.1s' "."{1..60})
padlength=50
cmp=$1
success_total=0
failure_total=0

print_test_name () {
    test_name=$1
    printf '%s' "$test_name"
    printf '%*.*s' 0 $((padlength - ${#test_name})) "$padding_dots"
}

test_success () {
    echo "OK"
    ((success++))
}

test_failure () {
    echo "FAIL"
    ((fail++))
}

test_not_implemented () {
    echo "NOT IMPLEMENTED"
}

run_our_program () {
    actual_out=`./$1 2>/dev/null`
    actual_exit_code=$?
    rm $1 2>/dev/null
}

run_correct_program () {
    expected_out=`./a.out`
    expected_exit_code=$?
    rm a.out
}

compare_program_results () {
    # make sure exit code is correct
    if [ "$expected_exit_code" -ne "$actual_exit_code" ] || [ "$expected_out" != "$actual_out" ]
    then
        test_failure
    else
        test_success
    fi
}

test_stage () {
    success=0
    fail=0
    echo "===================================================="
    echo "STAGE $1"
    echo "===================Valid Programs==================="
    for prog in `find . -type f -name "*.c" -path "./stage_$1/valid/*" -not -path "*/valid_multifile/*" 2>/dev/null`; do

        gcc -w $prog
        run_correct_program

        base="${prog%.*}" #name of executable (filename w/out extension)
        test_name="${base##*valid/}"

        print_test_name $test_name
        $cmp $prog 2>/dev/null
        status=$?

        if [[ $test_name == "skip_on_failure"* ]]; then
            # this may depend on features we haven't implemented yet
            # if compilation succeeds, make sure it gives the right result
            # otherwise don't count it as success or failure
            if [[ -f $base ]] && [[ $status -eq 0 ]]; then
                # it succeeded, so run it and make sure it gives the right result
                run_our_program $base
                compare_program_results
            else
                test_not_implemented
            fi
        else
            run_our_program $base
            compare_program_results
        fi
    done
    # programs with multiple source files
    for dir in `ls -d stage_$1/valid_multifile/* 2>/dev/null` ; do
        gcc -w $dir/*

        run_correct_program

        base="${dir%.*}" #name of executable (directory w/out extension)
        test_name="${base##*valid_multifile/}"

        # need to explicitly specify output name
        $cmp -o "$test_name" $dir/* >/dev/null

        print_test_name $test_name

        # check output/exit codes
        run_our_program $test_name
        compare_program_results

    done
    echo "===================Invalid Programs================="
    for prog in `ls stage_$1/invalid/{,**/}*.c 2>/dev/null`; do

        base="${prog%.*}" #name of executable (filename w/out extension)
        test_name="${base##*invalid/}"

        $cmp $prog >/dev/null 2>&1
        status=$? #failed, as we expect, if exit code != 0
        print_test_name $test_name

        # make sure neither executable nor assembly was produced
        # and exit code is non-zero
        if [[ -f $base || -f $base".s" ]]
        then
            test_failure
            rm $base 2>/dev/null
            rm $base".s" 2>/dev/null
        else
            test_success
        fi
    done
    echo "===================Stage $1 Summary================="
    printf "%d successes, %d failures\n" $success $fail
    ((success_total=success_total+success))
    ((failure_total=failure_total + fail))
}

total_summary () {
    echo "===================TOTAL SUMMARY===================="
    printf "%d successes, %d failures\n" $success_total $failure_total
}

if [ "$1" == "" ]; then
    echo "USAGE: ./test_compiler.sh /path/to/compiler [stages(optional)]"
    echo "EXAMPLE(test specific stages): ./test_compiler.sh ./mycompiler 1 2 4"
    echo "EXAMPLE(test all): ./test_compiler.sh ./mycompiler"
    exit 1
fi

if test 1 -lt $#; then
   testcases=("$@") # [1..-1] is testcases
   for i in `seq 2 $#`; do
       test_stage ${testcases[$i-1]}
   done
   total_summary
   exit 0
fi

num_stages=10

for i in `seq 1 $num_stages`; do
    test_stage $i
done

total_summary
