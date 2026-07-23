# Dependency Gates

Classify each relationship as one of these:

- `hard prerequisite`: downstream work cannot implement safely before upstream evidence exists.
- `soft dependency`: work can proceed with a documented assumption and later reconciliation.
- `independent`: work can run in parallel.

Typical hard prerequisites include an unresolved public API shape, database migration contract, permission model, authentication callback behavior, SDK compatibility rule, or accepted product decision.

When a hard prerequisite is incomplete:

1. Dispatch only the prerequisite owner.
2. Record the required execution evidence.
3. Mark downstream work as blocked or planned, not active implementation.
4. Re-evaluate after the prerequisite execution record is present.

Do not turn a missing external input into a guessed implementation. Record the input, the owner who must provide it, and the behavior permitted while it is missing.
