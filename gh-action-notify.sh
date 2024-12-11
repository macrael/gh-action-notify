#!/bin/bash

# TODO: allow setting the branch name by argument instead

# pull action name config if passed in


# Get Branch Name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Try for 20 seconds to find a new action

while (( SECONDS < 20 )); do    # Loop until interval has elapsed.
    echo "checking for action"

    # Filter Running Actions
    run_line=$(gh run list | grep "$branch_name" | grep "in_progress")

    if [ -n "$run_line" ]; then
        break
    fi

    sleep 1
done

if [ -z "$run_line" ]; then
    echo "No active GH action run found for the current branch"
    exit 1
fi

# if we got multiple lines back from the filter, we need to be told which to watch
# action_count=$(wc -l <<< "$run_line")
# if [ "$action_count" -gt 1 ]; then

# fi

# Parse out run id
run_id=$(echo "$run_line" | awk '{print $(NF - 2)}')

# Watch that 
gh run watch "$run_id"

# say something
say "Github action run complete"
