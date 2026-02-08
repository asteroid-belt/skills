# Sub-Agent Syntax Reference

> **MANDATORY**: Use these exact patterns when launching parallel operations.

## Parallel File Reads

Launch multiple Read operations in a single message:

```
Read: src/routes/auth.ts
Read: src/middleware/validate.ts
Read: tests/routes/auth.test.ts
```

---

## Parallel Explore Agents

Use Task tool with `subagent_type: Explore`:

```
Task 1 (subagent_type: Explore):
"Find authentication patterns in src/auth/.
Search for: login handlers, token validation, session management.
Return: file paths, key patterns used, testing approach for each."

Task 2 (subagent_type: Explore):
"Find validation patterns in src/middleware/.
Search for: input validation, schema validation, error handling.
Return: file paths and validation approaches."

Task 3 (subagent_type: Explore):
"Find test patterns in tests/.
Search for: test setup, fixtures, mocking patterns.
Return: testing conventions and fixture patterns."
```

---

## Parallel Phase Execution

When executing parallelizable phases (e.g., 1A, 1B, 1C):

```
Task (subagent_type: general-purpose):
"Implement Phase 1A from plans/NNN-feature/plan.md.

Instructions:
1. Read the Phase 1A section of the plan
2. For each task, follow the 5-step TDD micro-structure in references/TASK-MICROSTRUCTURE.md
3. Run quality gates (lint, typecheck, test) before completing
4. Return conventional commit message when complete

Plan location: plans/NNN-feature/plan.md
Phase: 1A"

Task (subagent_type: general-purpose):
"Implement Phase 1B from plans/NNN-feature/plan.md.

Instructions:
1. Read the Phase 1B section of the plan
2. For each task, follow the 5-step TDD micro-structure in references/TASK-MICROSTRUCTURE.md
3. Run quality gates (lint, typecheck, test) before completing
4. Return conventional commit message when complete

Plan location: plans/NNN-feature/plan.md
Phase: 1B"

Task (subagent_type: general-purpose):
"Implement Phase 1C from plans/NNN-feature/plan.md.

Instructions:
1. Read the Phase 1C section of the plan
2. For each task, follow the 5-step TDD micro-structure in references/TASK-MICROSTRUCTURE.md
3. Run quality gates (lint, typecheck, test) before completing
4. Return conventional commit message when complete

Plan location: plans/NNN-feature/plan.md
Phase: 1C"
```

---

## Sub-Agent Prompt Checklist

Every sub-agent prompt MUST include:

- [ ] Which phase to implement (exact phase ID: "Phase 1A")
- [ ] Path to plan file (exact path: "plans/NNN-feature/plan.md")
- [ ] Instruction to follow TDD micro-structure
- [ ] Instruction to run quality gates
- [ ] Instruction to return conventional commit message

---

## Collecting Results

After parallel phases complete, the main agent MUST:

1. Collect all commit messages from sub-agents
2. Output each commit message to the user
3. Label which phase each belongs to

Example output:

```
PARALLEL PHASES COMPLETE (1A, 1B, 1C)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 1A - Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(auth): implement JWT token validation

Files changed:
- src/middleware/auth.ts (CREATE)
- tests/middleware/auth.test.ts (CREATE)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE 1B - Commit Message:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
feat(api): add user profile endpoints

Files changed:
- src/routes/profile.ts (CREATE)
- tests/routes/profile.test.ts (CREATE)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  DO NOT COMMIT - User will handle git operations
```

---

## When to Use Parallel Execution

| Scenario | Parallelize? | Why |
|----------|--------------|-----|
| Independent file reads | ✅ Yes | No dependencies |
| Code searches in different areas | ✅ Yes | No shared state |
| Phases marked "Parallel With" | ✅ Yes | Plan designed for it |
| Unit, integration, E2E tests | ✅ Yes | Independent suites |
| Sequential phases | ❌ No | Has dependencies |
| Migration then data access | ❌ No | Order matters |
| Shared state setup | ❌ No | Race conditions |
