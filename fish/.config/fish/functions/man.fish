function man
    if which zsh >/dev/null
        set -l page $argv[1]
        zsh -ic "man $page"    
    else
        command man $argv
    end
end
