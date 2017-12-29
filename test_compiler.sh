#!/bin/bash

padding_dots=$(printf '%0.1s' "."{1..60})
padlength=50

if [ "$1" == "" ]; then
    echo "USAGE: ./test_compiler.sh /path/to/compiler"
    exit 1
fi

cmp=$1

success_total=0
failure_total=0

num_stages=4
for i in `seq 1 $num_stages`; do
    success=0
    fail=0
    echo "===================================================="
    echo "STAGE $i"
    echo "===================Valid Programs==================="
    for prog in ./stage_$i/valid/*.c; do
        gcc -w $prog
        ./a.out
        expected_exit_code=$?
        rm a.out

        $cmp $prog >/dev/null
        base="${prog%.*}" #name of executable (filename w/out extension)
        ./$base
        actual_exit_code=$?
        test_name=$(basename $base)
        printf '%s' "$test_name"
        printf '%*.*s' 0 $((padlength - ${#test_name})) "$padding_dots"

        if [ "$expected_exit_code" -ne "$actual_exit_code" ]
        then
            echo "FAIL"
            ((fail++))
        else
            echo "OK"
            ((success++))
        fi
        rm $base      
    done
    echo "===================Invalid Programs================="
    for prog in ./stage_$i/invalid/*.c; do
        base="${prog%.*}" #name of executable (filename w/out extension)
        test_name=$(basename $base)

        $cmp $prog >/dev/null 2>&1
        failed=$? #failed, as we expect, if exit code != 0

        printf '%s' "$test_name"
        printf '%.*s' $((padlength - ${#test_name})) "$padding_dots"

        if [[ -f $base || -f $base".s" ]] #make sure neither executable nor assembly was produced
        then
            echo "FAIL"
            ((fail++))
            rm $base 2>/dev/null
            rm $base".s" 2>/dev/null
        else
            echo "OK"
            ((success++))
        fi
    done
    echo "===================Stage $i Summary================="
    printf "%d successes, %d failures\n" $success $fail
    ((success_total=success_total+success))
    ((failure_total=failure_total + fail))
done

echo "===================TOTAL SUMMARY===================="
printf "%d successes, %d failures\n" $success_total $failure_total
