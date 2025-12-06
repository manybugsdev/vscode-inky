# Contributing to vscode-inky

Thank you for your interest in contributing to vscode-inky!

## Commit Message Format

This project enforces [Conventional Commits](https://www.conventionalcommits.org/) specification. All commit messages must follow this format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type

The type must be one of the following:

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **build**: Changes that affect the build system or external dependencies
- **ci**: Changes to our CI configuration files and scripts
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Scope

The scope is optional and can be anything specifying the place of the commit change.

### Subject

The subject contains a succinct description of the change:

- Use the imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize the first letter
- No dot (.) at the end

### Examples

```
feat: add preview functionality for ink files
fix: resolve syntax highlighting issues
docs: update README with installation instructions
chore: add commitlint and lefthook for conventional commits
```

## Setup

After cloning the repository, run:

```bash
pnpm install
```

This will automatically install the git hooks that enforce conventional commits.

## Validation

Commit messages are automatically validated using:
- [commitlint](https://commitlint.js.org/) - Lints commit messages
- [lefthook](https://github.com/evilmartians/lefthook) - Manages git hooks

If your commit message doesn't follow the conventional format, the commit will be rejected with a helpful error message.
