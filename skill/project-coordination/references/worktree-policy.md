# Worktree Policy

Use a dedicated worktree for each concurrently writable Git root. A multi-repository task therefore has one worktree record per modified repository, not one shared worktree for the parent directory.

Before creating or reusing a worktree, record:

- repository and source checkout;
- exact base ref and current HEAD;
- `git status --short`;
- intended branch and worktree path;
- whether the dependency is writable or read-only.

Create a new branch and worktree with the repository-local equivalent of:

```bash
git -C <source-checkout> worktree add -b <task-branch> <worktree-path> <base-ref>
```

If the branch already exists, verify that it belongs to the task and is not attached to another incompatible worktree before reusing it. Do not guess, switch away from another session's branch, or adopt an unexplained dirty worktree.

For formatter or generated-code commands, capture these before and after the command:

```bash
git status --short
git diff --name-only
git diff --stat
```

Record the exact command, timestamp, and affected file count. Accept mechanical changes only when every changed file is explained by the task scope and the recorded command. Escalate unexplained changes instead of labeling all post-formatter output as trusted.

Do not automatically remove a worktree after implementation. Cleanup belongs to the task owner after acceptance and must not discard uncommitted work.
