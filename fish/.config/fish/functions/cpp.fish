function cpp --description 'Copy files/folders and auto-create missing destination directories'
    if test (count $argv) -ne 2
        echo "Error: cpp requires exactly 2 arguments (source and destination)"
        return 1
    end

    set -l src $argv[1]
    set -l dest $argv[2]

    # 1. Create the parent directory of the destination target
    mkdir -p (dirname "$dest")

    # 2. Check if the source is a directory to dynamically apply -r
    if test -d "$src"
        cp -r "$src" "$dest"
    else
        cp "$src" "$dest"
    end
end
