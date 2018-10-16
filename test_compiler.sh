#!/bin/bash

padding_dots=$(printf '%0.1s' "."{1..60})
padlength=50
cmp=$1
success_total=0
failure_total=0

test_success () {
    echo "OK"
    ((success++))
}

test_failure () {
    echo "FAIL"
    ((fail++))
}

test_stage () {
    success=0
    fail=0
    echo "===================================================="
    echo "STAGE $1"
    echo "===================Valid Programs==================="
    for prog in `ls stage_$1/valid/{,**/}*.c 2>/dev/null`; do
        gcc -w $prog
        expected_out=`./a.out`
        expected_exit_code=$?
        rm a.out

        $cmp $prog >/dev/null
        base="${prog%.*}" #name of executable (filename w/out extension)
        actual_out=`./$base`
        actual_exit_code=$?
        test_name="${base##*valid/}"
        printf '%s' "$test_name"
        printf '%*.*s' 0 $((padlength - ${#test_name})) "$padding_dots"

        if [[ $test_name == "undefined"* ]]; then
            # return value is undefined
            # make sure it runs w/out segfaulting, but otherwise don't check exit code
            if [ "$actual_exit_code" -eq 139 ]; then
                #segfault!
                test_failure
            else
                test_success
            fi
        else
            # make sure exit code is correct
            if [ "$expected_exit_code" -ne "$actual_exit_code" ] || [ "$expected_out" != "$actual_out" ]
            then
                test_failure
            else
                test_success
            fi
        fi
        rm $base      
    done
    echo "===================Invalid Programs================="
    for prog in `ls stage_$1/invalid/{,**/}*.c 2>/dev/null`; do
        base="${prog%.*}" #name of executable (filename w/out extension)
        test_name="${base##*invalid/}"

        $cmp $prog >/dev/null 2>&1
        failed=$? #failed, as we expect, if exit code != 0

        printf '%s' "$test_name"
        printf '%.*s' $((padlength - ${#test_name})) "$padding_dots"

        if [[ -f $base || -f $base".s" ]] #make sure neither executable nor assembly was produced
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

num_stages=9

for i in `seq 1 $num_stages`; do
    test_stage $i
done

total_summary
