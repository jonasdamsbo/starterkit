# Copilot Instructions

## Core Principle

- Understand the existing system before changing it.
- Solve the actual problem that was asked, not problems that might exist.
- Prefer simple, explicit, and maintainable solutions over clever or unnecessarily abstract ones.
- Treat the existing codebase as the primary source of truth for its architecture, conventions, and behavior.

## Scope Discipline

- Solve the requested problem before considering architectural improvements.
- Make the smallest change that correctly solves the problem.
- Do not refactor unrelated code.
- Do not reformat unrelated code.
- Do not replace an existing pattern with a different pattern merely because you prefer it.
- Do not introduce abstractions unless they solve a concrete problem.
- Do not sacrifice correctness or maintainability merely to minimize the diff.
- Preserve behavior outside the requested change.
- If an existing implementation looks unusual, assume it may be intentional and investigate its usage before changing it.
- Do not solve hypothetical problems that do not currently exist.
- Do not add defensive code solely for hypothetical scenarios unless the risk is concrete and meaningful.
- Do not add configuration, validation, abstractions, or error handling without a demonstrated need.
- Avoid "while I'm here" improvements unless they are necessary for the requested change.

## Investigation First

- Before changing code, understand how the existing implementation works and how it is used.
- Inspect surrounding code, callers, dependencies, configuration, and relevant tests before making assumptions.
- Search the solution for similar implementations before creating a new pattern.
- Prefer reusing an established project pattern over introducing a new one.
- When debugging, identify the actual root cause before applying a fix.
- When a problem appears to involve multiple layers, trace the flow through those layers rather than fixing the first suspicious piece of code.
- Prefer evidence from the codebase over assumptions about how a framework, library, or tool "should" work.

## When Uncertain

- Do not guess when the answer can be determined by inspecting the repository.
- Do not invent APIs, configuration values, database fields, project conventions, or expected behavior.
- If two existing patterns conflict, follow the pattern used closest to the code being changed.
- Distinguish between known behavior and assumptions.
- If framework or library behavior is relevant and cannot be established from the codebase, verify it using authoritative documentation.
- If a requirement is genuinely ambiguous and choosing incorrectly could change behavior, ask for clarification rather than guessing.

## Existing Architecture

- Follow the architecture already established by the project unless the task explicitly requires changing it.
- Prefer consistency with surrounding code over introducing a theoretically superior alternative.
- Do not introduce new architectural patterns merely because they are newer, more fashionable, or considered best practice elsewhere.
- Do not replace an existing dependency, library, abstraction, or implementation approach without a concrete reason.
- Before introducing a dependency, determine whether the existing codebase or framework already provides the required functionality.
- Respect existing boundaries between projects, layers, and responsibilities.

## Framework and Tool Behavior

- Do not assume framework behavior; verify it from the codebase, configuration, tests, or authoritative documentation when relevant.
- Be especially careful with lifecycle, dependency injection, configuration, deployment, database, build, and test-environment behavior.
- Do not change established framework usage merely because a different approach appears more modern or conventional.
- Consider the difference between development, test, CI, and production environments before changing environment-specific behavior.
- Do not introduce environment-specific workarounds without understanding when and why they are required.

## Code Quality

- Prefer clear, readable code over clever code.
- Prefer straightforward implementations over unnecessary abstraction.
- Keep methods and classes focused, but do not split code into additional abstractions without a concrete benefit.
- Use existing naming, formatting, and structural conventions.
- Do not add comments that merely describe what the code already makes obvious.
- Comments should explain why something is done when the reasoning is not apparent from the code.
- Do not add XML documentation or other documentation solely to make a change appear more complete.
- Avoid speculative future-proofing.
- Do not introduce complexity merely to make code theoretically extensible.

## Changes and Refactoring

- Keep changes focused on the requested behavior.
- If a small refactoring is necessary to implement the change cleanly, keep it local and directly related to the change.
- Do not use a feature request as an excuse to clean up nearby code.
- If a larger refactoring appears genuinely necessary, explain why it is necessary rather than silently expanding the scope.
- Preserve existing behavior unless changing that behavior is part of the task.

## Tests

- Add or update tests when behavior changes.
- Treat existing tests as part of the specification.
- Preserve the intent of existing tests.
- Do not weaken or remove tests merely to make an implementation pass.
- If a test fails after a change, determine whether the implementation or the test is incorrect before modifying either.
- Prefer testing observable behavior rather than implementation details.
- Follow the existing test framework, structure, naming, and setup conventions.
- Do not introduce a new testing approach when the project already has an established one.

## Error Handling

- Follow the project's existing error-handling conventions.
- Do not silently swallow exceptions.
- Do not add broad exception handling without a concrete reason.
- Do not add validation merely because a value could theoretically be invalid; establish whether the invalid state is actually possible or meaningful.
- Preserve existing error behavior unless the task requires changing it.

## Dependencies

- Prefer functionality already provided by the project or its existing dependencies.
- Do not add a dependency for a problem that can be reasonably solved using existing functionality.
- Before adding a dependency, check whether an equivalent dependency or framework feature is already in use.
- Do not replace dependencies without a concrete reason and consideration of existing usage.

## Git

- Never use git commands.
- Do not commit, amend, reset, stash, checkout, switch branches, rebase, merge, or otherwise modify repository history or working-tree state through git.
- Do not assume permission to modify repository state outside the requested code changes.

## Final Verification

Before considering a task complete:

1. Verify that the requested behavior is actually implemented.
2. Check the surrounding code for consistency with the existing architecture.
3. Run or inspect relevant tests when appropriate.
4. Check for unintended changes outside the requested scope.
5. Do not make additional cleanup or refactoring changes merely because they are visible.

## Engineering Judgment

- When multiple valid approaches exist, prefer the approach that best fits the existing codebase and requirements.
- Do not silently make significant architectural or behavioral tradeoffs.
- If a change involves a meaningful tradeoff, briefly explain the tradeoff and why the chosen approach fits the project.
- Do not present assumptions as facts.