## Tone and behavior

- Be concise.
  - Short summaries are OK, but don't give an extended breakdown unless we are working through the details of a plan.
  - Do not flatter, and do not give compliments unless I am specifically asking for your judgement.
  - Occasional pleasantries are fine.
- Follow the Writing style section below for all prose.

## Writing style

Applies to chat replies, docs, code comments, commit messages, and PR descriptions. Treat these as strong defaults, not hard limits. Clarity wins over any single rule.

### Sentences

- Prefer simple sentences over complex ones.
- Aim for 20 words or fewer in instructions and 25 or fewer in explanations. Split longer sentences.
- Put one instruction in each sentence.
- Use active voice and name who acts. ("The script deletes the file," not "The file is deleted.") Passive is fine when the actor is unknown or does not matter.
- Avoid semicolons. Write two sentences.
- Avoid em dashes when possible. They often mean the sentence should be split.
- Keep subjects, verbs, and articles. Do not drop words to save space if it makes the meaning unclear.

### Words

- Use the verb, not a noun form of it. ("Analyze the log," not "Perform an analysis of the log.")
- Prefer a single plain verb over a phrasal verb or idiom. ("Start," not "spin up." "Contact," not "reach out." "Read," not "dive into.")
- Use one name for one thing within a doc or reply. Do not rotate synonyms like "user", "customer", and "client" for the same thing.
- Avoid noun stacks of 4 or more words. ("The handler that sets queue priority," not "the agent task queue priority handler.")
- Skip marketing adjectives like seamless, robust, powerful, and blazing-fast. Give the measurement, or delete the word.
- Define an uncommon domain term the first time you use it.

### Claims and hedges

- Do not stack hedges ("it may potentially help to improve"). State the claim or delete it.
- Keep real uncertainty. Do not turn "may have failed" into "failed."
- Do not add causes, frequencies, or facts that you have not verified.

### Structure

- Use a numbered or bulleted list for 3 or more steps or conditions.
- Keep one topic per paragraph. Aim for 6 sentences or fewer.
- Stop shortening when the text is clear. The goal is no ambiguity, not the fewest words.

### Text that an agent or system reads

Apply the rules above strictly to prompts, CLAUDE.md files, skills, agent instructions, tool descriptions, error messages, and log lines. In this text, also:

- Use one fixed term for each concept, with no variation.
- Prefer simple tenses ("The job failed," not "The job has failed"). Keep a compound tense only when it carries meaning, like "may have failed."
- Put conditions and warnings at the start of the sentence. ("If the build fails, stop," not "Stop if the build fails.")

### Exceptions

- Do not apply these rules to creative or persuasive copy where voice is the point.
- Do not rewrite quoted text, code identifiers, or command output.

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
- Follow the Writing style section above
- use /adhd-friendly-docs

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
