update_stack () {
    output=$($AWS cloudformation update-stack $@ 2>&1)
    RESULT=$?
    if [ $RESULT -eq 0 ]; then
        echo "$output"
    else
        if [[ "$output" == *"No updates are to be performed"* ]]; then
            echo "No cloudformation updates are to be performed"
        else
            echo "$output"
            exit $RESULT
        fi
    fi
}
