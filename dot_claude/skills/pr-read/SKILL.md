---
name: pr-read
description: Fetch a GitHub PR description and reformat it as an ADHD-friendly doc for reading. Read-only. Use when the user runs /pr-read or asks to make a PR description easier to read. Pass --page to publish the result as a private artifact page.
argument-hint: "[--page] <pr-number | pr-url | owner/repo#number>"
---

# PR Read: ADHD-friendly PR descriptions

Reformat a PR description so the user can read it quickly. This skill is read-only on GitHub.

## Hard rules

- Never change the PR. Do not run `gh pr edit`, `gh pr comment`, `gh pr review`, `gh pr merge`, `gh pr close`, or `gh api` with a write method.
- Do not save the result to disk, except the temporary HTML file for `--page`.
- Keep every fact, link, code block, checklist item, and screenshot link from the original.
- Do not add facts. If the original is unclear, say "Unclear in the original:" and quote it.

## Arguments

`$ARGUMENTS` holds one PR reference and an optional `--page` flag.

The PR reference is one of:

- A full URL: `https://github.com/bebraven/platform/pull/1234`
- A number: `1234`. `gh` resolves it against the repo in the current directory.
- `owner/repo#1234`. Convert this to `1234 --repo owner/repo` for `gh`.

If no PR reference is present, print `usage: /pr-read [--page] <pr-number | pr-url | owner/repo#number>` and stop.

## Steps

1. Fetch the PR:

   ```bash
   gh pr view <ref> --json number,title,url,author,state,isDraft,baseRefName,headRefName,body,additions,deletions,changedFiles,files,labels
   ```

   If `gh` fails, print its error and stop.

2. Load the `adhd-friendly-docs` skill. Use its Refine mode on the PR `body`.
3. Build the output in this order:
   1. Title line: `# #<number> <title>`
   2. One meta line: author, state (mark drafts), `head → base`, `+additions / -deletions`, file count, PR link.
   3. **TL;DR:** 1 to 2 lines on what the PR does and why.
   4. The reformatted body sections.
   5. **Files changed:** group the files by directory or area. Keep this section to 15 lines or fewer.
   6. **Review focus:** list items only if the author asks reviewers to check something. Otherwise omit this section.
4. If the PR body is empty, say so under the TL;DR. Build the TL;DR from the title and file list, and label it "Inferred from title and files".
5. Deliver the result:
   - If `--page` is absent, print the markdown as the final response. Print nothing else.
   - If `--page` is present, follow "Page mode".

## Page mode

1. If the Artifact tool is not available, say "Page mode needs an interactive session. Run `prr --page` or `/pr-read --page` in Claude." Then print the markdown result.
2. Follow the Artifact tool's guidance for a new page (quickstart with intent `other`, then the design pass).
3. Write the page as HTML in the scratchpad directory. Name it `pr-<repo>-<number>.html`.
4. Make the page readable next to the diff. Use a narrow column, a sticky section list, and collapsible "Files changed".
5. Publish it with icon `code`. Use the description `Reformatted description for <owner>/<repo>#<number>`.
6. Print only the artifact link and the PR link.
