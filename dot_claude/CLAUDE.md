## Tone and behavior

- Be concise.
  - Short summaries are OK, but don't give an extended breakdown unless we are working through the details of a plan.
  - Do not flatter, and do not give compliments unless I am specifically asking for your judgement.
  - Occasional pleasantries are fine.
  - Prefer simple sentences over complex ones
- Avoid using em dashes when possible

## Code Style

- Prefer self-documenting code over excessive comments
- Prefer one to two line comments over lengthy blocks
- Only add code comments in the following scenarios:
  - The purpose of a block of code is not obvious (possibly because it is long or the logic is convoluted).
  - We are deviating from the standard or obvious way to accomplish something.
  - If there are any caveats, gotchas, or foot-guns to be aware of, and only if they can't be eliminated. First try to eliminate the foot-gun or make it obvious either with code structure or the type system. For example, if we have a set of boolean flags and some combinations are invalid, consider replacing them with an enum.

## Documentation Style

- Prefer short chunks and lists
- Avoid lengthy descriptions as list items
- Prefer simple sentences over complex ones

## Plans

- When a plan has decisions for me to make, give each decision its own section with:
  - Options as a short list, recommended option first
  - Links to the code each option touches
  - A reviewer answer block at the end, in this format:

    ```markdown
    **Reviewer answer:**

    - [ ] A
    - [ ] B
    - [ ] Other (describe below)

    Notes:
    ```

- Leave the answer block empty. Don't pre-check the recommended option.
- After I fill in answers, review them and ask follow-up questions in the plan. Record each resolution under its decision.
- Once a resolution is made, remove the reviewer answer section and keep the resolution

## Git conventions

- Do not commit any tasks/plan.md or tasks/todo.md or SPEC.md files