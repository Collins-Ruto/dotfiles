function qs
    # Fish Quick Substitution: Replace the full command with a new one and preserve arguments/flags
    # Usage: qs oldcommand newcommand

    # Get the most recent command from history
    set -l last (history | head -n1)

    # Ensure two arguments are passed
    if test (count $argv) -ne 2
        echo "Usage: qs oldcommand newcommand"
        return 1
    end

    # Split the command into an array to avoid replacing components incorrectly
    set -l cmd_parts (string split ' ' $last)

    # Replace the first part (the command name) with the new one
    set cmd_parts[1] $argv[2]

    # Join the parts back into a single command
    set -l edited_cmd (string join ' ' $cmd_parts)

    # Echo the substituted command and run it
    echo "Running: $edited_cmd"
    eval $edited_cmd
end

