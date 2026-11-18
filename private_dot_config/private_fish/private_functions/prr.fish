function prr --description 'Read a PR description reformatted as an ADHD-friendly doc'
    set -l mode print
    set -l ref
    for arg in $argv
        switch $arg
            case --page
                set mode page
            case --save
                set mode save
            case --code
                set mode code
            case '*'
                set ref $arg
        end
    end

    if test -z "$ref"
        echo "usage: prr [--page | --save | --code] <pr-number | pr-url | owner/repo#number>" >&2
        return 1
    end

    # A full URL tells us the repo, so move to its local clone if one exists.
    if string match -rq 'github\.com/(?<owner>[^/]+)/(?<repo>[^/]+)/pull/\d+' -- $ref
        set -l root ~/Documents/Braven
        set -q PRR_ROOT; and set root $PRR_ROOT
        set -l slug (string escape --style=regex -- "$owner/$repo")
        for dir in $root/*/
            set -l remote (git -C $dir remote get-url origin 2>/dev/null); or continue
            if string match -rqi "github\.com[:/]$slug(\.git)?\$" -- $remote
                cd $dir
                echo "→ cd $dir" >&2
                break
            end
        end
    end

    set -l model sonnet
    set -q PRR_MODEL; and set model $PRR_MODEL
    set -l claude_args --model $model --allowedTools 'Skill' 'Read' 'Write' 'Artifact' 'Bash(gh pr view:*)'
    switch $mode
        case page
            # Headless `claude -p` has no Artifact tool, so page mode needs an interactive session.
            claude "/pr-read --page $ref" $claude_args
        case save code
            set -l file (__prr_save_path $ref); or return 1
            set -l output (claude -p "/pr-read $ref" $claude_args | string collect); or return 1
            printf '%s\n' $output >$file
            echo "→ saved $file" >&2
            test $mode = code; and code $file
        case print
            if type -q glow
                claude -p "/pr-read $ref" $claude_args | glow -
            else
                claude -p "/pr-read $ref" $claude_args
            end
    end
end

function __prr_save_path --argument-names ref
    set -l url $ref
    if string match -rq '^(?<slug>[^/#]+/[^/#]+)#(?<num>\d+)$' -- $ref
        set url "https://github.com/$slug/pull/$num"
    else if not string match -q '*github.com*' -- $ref
        set url (gh pr view $ref --json url -q .url); or return 1
    end

    string match -rq 'github\.com/[^/]+/(?<repo>[^/]+)/pull/(?<num>\d+)' -- $url; or return 1
    set -l dir ~/Documents/Braven/pr_descriptions
    set -q PRR_SAVE_DIR; and set dir $PRR_SAVE_DIR
    mkdir -p $dir
    echo "$dir/$repo-$num.md"
end
