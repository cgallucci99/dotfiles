function git-today --wraps="git --no-pager log --all --since=midnight --author='Camden Gallucci' --oneline" --description "alias git-today=git --no-pager log --all --since=midnight --author='Camden Gallucci' --oneline"
    git --no-pager log --all --since=midnight --author='Camden Gallucci' --oneline $argv
end
