# Read a PR description reformatted as an ADHD-friendly doc.
prr() {
  local mode=print ref="" arg
  for arg in "$@"; do
    case $arg in
      --page) mode=page ;;
      --save) mode=save ;;
      --code) mode=code ;;
      *) ref=$arg ;;
    esac
  done

  if [[ -z $ref ]]; then
    echo "usage: prr [--page | --save | --code] <pr-number | pr-url | owner/repo#number>" >&2
    return 1
  fi

  # A full URL tells us the repo, so move to its local clone if one exists.
  if [[ $ref =~ 'github\.com/([^/]+)/([^/]+)/pull/[0-9]+' ]]; then
    local slug="${match[1]:l}/${match[2]:l}" dir remote
    for dir in ${PRR_ROOT:-$HOME/Documents/Braven}/*(/); do
      remote=$(git -C "$dir" remote get-url origin 2>/dev/null) || continue
      remote=${${remote:l}%.git}
      if [[ $remote == *github.com[:/]$slug ]]; then
        cd "$dir"
        echo "→ cd $dir" >&2
        break
      fi
    done
  fi

  local claude_args=(--model ${PRR_MODEL:-sonnet} --allowedTools Skill Read Write Artifact 'Bash(gh pr view:*)')
  case $mode in
    page)
      # Headless `claude -p` has no Artifact tool, so page mode needs an interactive session.
      claude "/pr-read --page $ref" $claude_args
      ;;
    save|code)
      local file output
      file=$(_prr_save_path "$ref") || return 1
      output=$(claude -p "/pr-read $ref" $claude_args) || return 1
      print -r -- "$output" > "$file"
      echo "→ saved $file" >&2
      [[ $mode == code ]] && code "$file"
      ;;
    print)
      if (( $+commands[glow] )); then
        claude -p "/pr-read $ref" $claude_args | glow -
      else
        claude -p "/pr-read $ref" $claude_args
      fi
      ;;
  esac
}

_prr_save_path() {
  local ref=$1 url=$1
  if [[ $ref =~ '^([^/#]+/[^/#]+)#([0-9]+)$' ]]; then
    url="https://github.com/${match[1]}/pull/${match[2]}"
  elif [[ $ref != *github.com* ]]; then
    url=$(gh pr view "$ref" --json url -q .url) || return 1
  fi

  [[ $url =~ 'github\.com/[^/]+/([^/]+)/pull/([0-9]+)' ]] || return 1
  local dir=${PRR_SAVE_DIR:-$HOME/Documents/Braven/pr_descriptions}
  mkdir -p "$dir"
  echo "$dir/${match[1]}-${match[2]}.md"
}
