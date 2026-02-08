---
name: supercharge
description: Weekly codebase hygiene skill that identifies and fixes AI-generated code problems ("slop") using Martin Fowler's refactoring techniques. Scans for 15 common issues, prioritizes by severity, and generates superplan-compatible plans for systematic improvement.
metadata:
  version: "1.0.0"
  generated-at: "2026-02-05"
compatibility: Works with any codebase. Stack auto-detected. Integrates with superplan and superbuild.
license: MIT
---

# Supercharge: Weekly Codebase Hygiene Engine

## Overview

Supercharge systematically identifies and fixes "AI slop" - the verbose, repetitive, and poorly structured code that AI coding assistants commonly generate. It uses Martin Fowler's proven refactoring techniques to improve code quality without changing behavior.

**This is a maintenance skill, not a feature skill.** Use supercharge on a weekly cadence to keep AI-assisted codebases clean and readable.

### What Supercharge Does

1. **Scans** the codebase for 15 categories of AI-generated code problems
2. **Prioritizes** issues by severity (CRITICAL → HIGH → MEDIUM → LOW)
3. **Plans** refactorings using the superplan format
4. **Executes** safe refactorings automatically, requests approval for others
5. **Verifies** no behavioral changes occurred
6. **Reports** hygiene metrics and trends over time

### What Supercharge Does NOT Do

- Architecture changes (use dedicated refactoring skills)
- Security vulnerability fixes (use security scanning tools)
- Performance optimization (use profiling tools)
- New feature development (use superplan)

---

## When to Use Supercharge

- **Weekly maintenance** on actively developed codebases
- **Before code review** to clean up AI-generated PRs
- **After major AI-assisted development** to reduce accumulated slop
- **When onboarding** to improve readability of unfamiliar code
- **When tests pass but code is hard to read**

## When NOT to Use Supercharge

- Codebase has no tests (too risky to refactor)
- Code is being actively rewritten (wasted effort)
- Need architectural changes (wrong tool)
- Time-critical hotfix (refactor later)

---

## Core Workflow

```text
┌─────────────────────────────────────────────────────────────────────┐
│                      SUPERCHARGE WORKFLOW                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. DETECT         →  Identify stack, quality tools, codebase size  │
│        ↓                                                             │
│  1.5 CHARACTERIZE  →  Add missing tests (if coverage < 60%)         │
│        ↓               Red-Green-Refactor: tests BEFORE changes     │
│  2. SCAN           →  Find AI slop using smell detection prompts    │
│        ↓                                                             │
│  3. PRIORITIZE     →  Rank issues by severity, identify quick wins  │
│        ↓                                                             │
│  4. PLAN           →  Generate superplan-compatible refactoring     │
│        ↓                                                             │
│  5. EXECUTE        →  Apply safe refactorings, request approval     │
│        ↓                                                             │
│  6. VERIFY         →  Run tests, confirm no behavioral changes      │
│        ↓                                                             │
│  7. REPORT         →  Generate hygiene report with metrics          │
│                                                                      │
│  ═══════════════════════════════════════════════════════════════════ │
│  Phase 1.5 is MANDATORY if test coverage < 60% on files to refactor │
│  Phases 5-6 repeat per refactoring batch. Tests MUST pass after each│
│  ═══════════════════════════════════════════════════════════════════ │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## Reference Index - MUST READ Before Each Phase

**References contain detailed templates and patterns. Read BEFORE starting each phase.**

| When | Reference | What You Get |
|------|-----------|--------------|
| **Phase 1.5: Characterize** | [CHARACTERIZATION-TESTS.md](references/CHARACTERIZATION-TESTS.md) | How to write tests for legacy/untested code |
| **Phase 2: Scan** | [AI-SLOP-CATALOG.md](references/AI-SLOP-CATALOG.md) | 15 AI code problems with examples |
| **Phase 2: Scan** | [SMELL-DETECTION-PROMPTS.md](references/SMELL-DETECTION-PROMPTS.md) | Exact prompts for Explore agents |
| **Phase 3: Prioritize** | [SEVERITY-MATRIX.md](references/SEVERITY-MATRIX.md) | How to rank and prioritize issues |
| **Phase 4: Plan** | [FOWLER-REFACTORINGS.md](references/FOWLER-REFACTORINGS.md) | 20 refactoring techniques with mechanics |
| **Phase 5: Execute** | [SAFE-REFACTORING-RULES.md](references/SAFE-REFACTORING-RULES.md) | What can be auto-applied vs needs approval |
| **Phase 7: Report** | [REPORT-TEMPLATE.md](references/REPORT-TEMPLATE.md) | Weekly hygiene report format |

**DO NOT SKIP REFERENCES.** They contain exact prompts, examples, and rules that are NOT duplicated here.

---

## Phase 1: DETECT - Stack Analysis

### Step 1: Identify Technology Stack

Detect the primary language, framework, and quality tools:

| Detection | Check For |
|-----------|-----------|
| **Language** | File extensions, package files |
| **Framework** | Framework-specific config files |
| **Linter** | .eslintrc, ruff.toml, .golangci.yml, clippy.toml |
| **Formatter** | .prettierrc, pyproject.toml [black], rustfmt.toml |
| **Type Checker** | tsconfig.json, mypy.ini, pyrightconfig.json |
| **Test Framework** | jest.config, pytest.ini, go.mod, Cargo.toml |

### Step 2: Estimate Codebase Size

| Size | Criteria | Session Approach |
|------|----------|-----------------|
| **Small** | <50 files, <5K LOC | Full scan, fix all |
| **Medium** | 50-200 files, 5-20K LOC | Focused scan, fix critical+high |
| **Large** | >200 files, >20K LOC | Targeted scan (recent changes), fix critical only |

### Step 3: Verify Test Coverage Exists

**CRITICAL**: Do NOT proceed with refactoring if tests don't exist for areas being refactored.

#### Scenario A: No Tests At All

```text
⛔ SUPERCHARGE BLOCKED
━━━━━━━━━━━━━━━━━━━━━━

No tests detected in this codebase.
Refactoring without tests is too risky.

Options:
1. Bootstrap tests first: Run `/superplan bootstrap the testing pyramid for this codebase`
2. Run supercharge in scan-only mode (identify issues, no fixes)
3. Abort

Recommended: Option 1
━━━━━━━━━━━━━━━━━━━━━━
Superplan will create a comprehensive plan to add unit, integration,
and E2E tests following the testing pyramid. Once tests exist, return
to supercharge for safe refactoring.

Which option?
```

**If user selects Option 1**: Stop execution immediately and hand off to `/superplan`.

**If user selects Option 2**: Continue to Phase 2 (SCAN) but skip Phases 5-6 (EXECUTE/VERIFY). Generate report only.

#### Scenario B: Tests Exist But Coverage Is Incomplete

If the codebase has tests but specific files/functions lack coverage:

```text
⚠️  PARTIAL TEST COVERAGE DETECTED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test framework: Jest
Total coverage: 45%

Files with issues but NO test coverage:
  - src/services/userService.ts (0% coverage, 9 issues)
  - src/utils/helpers.ts (12% coverage, 6 issues)
  - src/api/handlers.ts (0% coverage, 5 issues)

Files with issues AND test coverage:
  - src/models/user.ts (89% coverage, 3 issues) ✓
  - src/components/Form.tsx (76% coverage, 4 issues) ✓

Options:
1. Add characterization tests for uncovered files first (recommended)
2. Only refactor files with existing coverage
3. Continue with scan-only mode

Which option?
```

> **STOP. Read [CHARACTERIZATION-TESTS.md](references/CHARACTERIZATION-TESTS.md) NOW** for characterization testing patterns.

---

## Phase 1.5: CHARACTERIZE - Add Missing Tests

**Before refactoring any code, ensure tests exist that characterize its current behavior.**

Characterization tests (from Michael Feathers' "Working Effectively with Legacy Code") capture what code *actually does* - not what it *should do*. They provide a safety net for refactoring.

### When to Create Characterization Tests

| Situation | Action |
|-----------|--------|
| No tests for file being refactored | Create characterization tests FIRST |
| Tests exist but low coverage (<60%) | Add tests for uncovered paths |
| Complex function being extracted | Add tests covering all branches |
| Code behavior is unclear | Write tests to document behavior |

### Red-Green-Refactor Discipline

**EVERY refactoring follows this cycle:**

```text
┌─────────────────────────────────────────────────────────────────────┐
│                     RED-GREEN-REFACTOR CYCLE                         │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. RED (Characterize)                                              │
│     │  Write a test that captures current behavior                  │
│     │  Run test → it should PASS (characterizing existing code)     │
│     │  If it fails, your understanding is wrong - investigate       │
│     ↓                                                                │
│  2. GREEN (Verify)                                                  │
│     │  Confirm all characterization tests pass                      │
│     │  These tests are your safety net                              │
│     ↓                                                                │
│  3. REFACTOR (Improve)                                              │
│     │  Apply the refactoring (extract, rename, move, etc.)          │
│     │  Run tests → they MUST still pass                             │
│     │  If tests fail, refactoring changed behavior - REVERT         │
│     ↓                                                                │
│  4. REPEAT                                                          │
│     │  One refactoring at a time                                    │
│     │  Tests pass after each step                                   │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Creating Characterization Tests

For each file/function lacking tests:

1. **Identify inputs** - What parameters does it accept?
2. **Identify outputs** - What does it return? What side effects?
3. **Call the code** - Execute with known inputs
4. **Assert actual behavior** - Whatever it returns, assert THAT

```text
CHARACTERIZATION TEST CREATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: src/services/userService.ts
Function: processUser(user)
Coverage: 0% → Target: 80%+

Step 1: Identify inputs
  - user: { id: string, name: string, email: string }

Step 2: Call with sample input
  - result = processUser({ id: "1", name: "Test", email: "test@example.com" })

Step 3: Observe actual output
  - result = { id: "1", name: "TEST", email: "test@example.com", processed: true }

Step 4: Write test asserting actual behavior
  - expect(result.name).toBe("TEST")  // Captures uppercase transformation
  - expect(result.processed).toBe(true)  // Captures added flag

Tests created: 3 characterization tests
Coverage: 0% → 78%
Ready for refactoring: ✓
```

### Test Quality Gate

**Do NOT proceed to refactoring until:**

- [ ] All files to be refactored have characterization tests
- [ ] Coverage is at least 60% for each file (80% preferred)
- [ ] Tests cover happy path AND error cases
- [ ] Tests document any surprising or non-obvious behavior
- [ ] All tests pass

```text
CHARACTERIZATION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━

Files characterized:
  ✓ src/services/userService.ts (82% coverage, 12 tests)
  ✓ src/utils/helpers.ts (71% coverage, 8 tests)
  ✓ src/api/handlers.ts (65% coverage, 15 tests)

Total new tests: 35
All tests passing: ✓

Ready to proceed to Phase 2 (SCAN).
```

### CHECKPOINT - Phase 1.5

After characterization complete:

```text
/compact focus on: Phase 1.5 complete, [N] characterization tests added, coverage now [X]%, Phase 2 ready for smell detection
```

---

## Phase 2: SCAN - Find AI Slop

> **STOP. Read [AI-SLOP-CATALOG.md](references/AI-SLOP-CATALOG.md) NOW** to understand the 15 smell categories.
> **STOP. Read [SMELL-DETECTION-PROMPTS.md](references/SMELL-DETECTION-PROMPTS.md) NOW** for exact Explore agent prompts.

### Scanning Strategy

Launch parallel Explore agents to scan for different smell categories:

```text
LAUNCHING SMELL DETECTION
━━━━━━━━━━━━━━━━━━━━━━━━━

Agent 1: Dead Code + Debug Artifacts     [scanning...]
Agent 2: Verbose Functions + Deep Nesting [scanning...]
Agent 3: Naming + Duplication             [scanning...]
Agent 4: Magic Literals + Long Parameters [scanning...]
Agent 5: Style + Comments                 [scanning...]

Estimated time: 2-5 minutes for medium codebase
```

### Scan Output Format

Each agent should return issues in this format:

| File | Line | Smell | Severity | Description |
|------|------|-------|----------|-------------|
| src/utils.ts | 45 | Dead Code | CRITICAL | Unused function `oldHelper` |
| src/api.ts | 102 | Deep Nesting | HIGH | 4 levels of nesting |
| src/models.ts | 23 | Poor Naming | MEDIUM | Variable `data` is too generic |

### Verify Scan Results

**CRITICAL: Sub-agent reports are CLAIMS, not EVIDENCE.**

After parallel Explore agents complete, verify findings before proceeding:

- [ ] Review each agent's findings independently
- [ ] Cross-check for false positives (is that variable actually unused?)
- [ ] Verify line numbers are accurate (code may have changed)
- [ ] Merge into unified issue list, removing duplicates
- [ ] Confirm issue count matches sum of agent reports

```text
SCAN VERIFICATION
━━━━━━━━━━━━━━━━━

Agent 1: 5 issues reported  → 5 verified ✓
Agent 2: 8 issues reported  → 7 verified (1 false positive removed)
Agent 3: 6 issues reported  → 6 verified ✓
Agent 4: 4 issues reported  → 4 verified ✓
Agent 5: 4 issues reported  → 3 verified (1 duplicate removed)

Total: 27 reported → 25 verified issues
```

### CHECKPOINT - Phase 2

After scan verification, run context compaction if session is long:

```text
/compact focus on: Phase 2 complete, [N] issues found across [M] files, top smells: [list], Phase 3 needs prioritization
```

---

## Phase 3: PRIORITIZE - Rank Issues

> **STOP. Read [SEVERITY-MATRIX.md](references/SEVERITY-MATRIX.md) NOW** for prioritization rules.

### Severity Summary

| Severity | Fix Urgency | Examples |
|----------|-------------|----------|
| **CRITICAL** | Fix immediately | Dead code, debug artifacts, hardcoded secrets |
| **HIGH** | Fix this session | God classes, deep nesting, DRY violations |
| **MEDIUM** | Fix if time permits | Poor naming, magic literals, feature envy |
| **LOW** | Opportunistic | Style inconsistencies, excessive comments |

### Quick Win Identification

Prioritize issues that are **high impact + low effort**:

| Quick Win | Impact | Effort | Action |
|-----------|--------|--------|--------|
| Remove console.log | CRITICAL | 1 min | Delete line |
| Remove unused import | CRITICAL | 1 min | Delete line |
| Replace magic number | MEDIUM | 2 min | Extract constant |
| Apply guard clause | HIGH | 5 min | Restructure |

### Present Summary to User

```text
SCAN COMPLETE
━━━━━━━━━━━━━

Issues Found:
  CRITICAL:  3 (dead code, debug artifacts)
  HIGH:      7 (verbose functions, deep nesting)
  MEDIUM:   12 (naming, magic literals)
  LOW:       5 (style)

Total: 27 issues

Quick Wins: 8 issues fixable in <5 minutes each

Top 3 Hotspot Files:
  1. src/services/userService.ts (9 issues)
  2. src/utils/helpers.ts (6 issues)
  3. src/api/handlers.ts (5 issues)

Proceed with planning? (y/n)
```

### CHECKPOINT - Phase 3

After prioritization, run context compaction if session is long:

```text
/compact focus on: Phase 3 complete, [N] issues prioritized ([X] critical, [Y] high), [Z] quick wins identified, Phase 4 needs plan generation
```

---

## Phase 4: PLAN - Generate Refactoring Plan

> **STOP. Read [FOWLER-REFACTORINGS.md](references/FOWLER-REFACTORINGS.md) NOW** to select appropriate refactorings.

### Plan Generation

Generate a superplan-compatible plan with:

1. **Grouped refactorings** - Related fixes together
2. **Dependency order** - Safe refactorings first
3. **TDD micro-structure** - Verify tests before/after each change
4. **CHECKPOINT markers** - Context compaction points

### Plan Structure

```markdown
# Supercharge Refactoring Plan - [Date]

## Phase 1: Critical Fixes (Dead Code + Debug)

- [ ] Task 1.1: Remove dead code in src/utils.ts
  - Lines 45-67: Remove unused function `oldHelper`
  - Refactoring: Remove Dead Code
  - Verify: Run tests

- [ ] Task 1.2: Remove debug artifacts
  - src/api.ts:102: Remove console.log
  - src/services.ts:55: Remove TODO comment
  - Refactoring: Remove Dead Code
  - Verify: Run tests

### Definition of Done - Phase 1
- [ ] All dead code removed
- [ ] All debug artifacts removed
- [ ] Tests pass
- [ ] No new warnings

### CHECKPOINT: Run `/compact focus on: Phase 1 complete, dead code removed`

## Phase 2: High Priority (Verbose Functions)
...
```

### Handoff Options

```text
REFACTORING PLAN READY
━━━━━━━━━━━━━━━━━━━━━━

Plan saved to: docs/supercharge-[date]-plan.md

Options:
1. Execute now with `/superbuild docs/supercharge-[date]-plan.md`
2. Continue execution in this session
3. Review plan first

Which option?
```

### CHECKPOINT - Phase 4

After plan generation, run context compaction before execution:

```text
/compact focus on: Phase 4 complete, refactoring plan saved to docs/supercharge-[date]-plan.md, [N] refactorings planned across [M] phases, Phase 5 begins execution
```

---

## Phase 5: EXECUTE - Apply Refactorings

> **STOP. Read [SAFE-REFACTORING-RULES.md](references/SAFE-REFACTORING-RULES.md) NOW** for auto-apply rules.
> **STOP. Read [CHARACTERIZATION-TESTS.md](references/CHARACTERIZATION-TESTS.md) NOW** for test-first patterns.

### The Golden Rule

**NO REFACTORING WITHOUT CHARACTERIZATION TESTS.**

Even "safe" refactorings like removing dead code require tests that prove the code is actually dead. The test proves the refactoring is safe.

### Execution Rules

| Refactoring Type | Action |
|-----------------|--------|
| **SAFE** (dead code, rename local) | Verify tests exist, then apply |
| **REQUIRES APPROVAL** (extract function, move) | Add characterization tests, show diff, ask user |
| **NEVER AUTO-APPLY** (delete files, change API) | Create subtask for human |

### Characterization-First Workflow (Per Refactoring)

**EVERY refactoring follows this micro-cycle:**

```text
┌─────────────────────────────────────────────────────────────────────┐
│              CHARACTERIZATION-FIRST REFACTORING                      │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. CHECK: Does test coverage exist for this code?                  │
│     │  YES → Proceed to step 3                                      │
│     │  NO  → Step 2                                                 │
│     ↓                                                                │
│  2. CHARACTERIZE: Write test capturing current behavior             │
│     │  Run test → MUST PASS (it characterizes existing code)        │
│     │  If fails → your understanding is wrong, investigate          │
│     ↓                                                                │
│  3. REFACTOR: Apply the single refactoring                          │
│     │  One change only                                              │
│     ↓                                                                │
│  4. VERIFY: Run characterization tests                              │
│     │  PASS → Behavior preserved, continue                          │
│     │  FAIL → Refactoring broke behavior, REVERT immediately        │
│     ↓                                                                │
│  5. NEXT: Move to next refactoring, repeat from step 1              │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### Pre-Flight Checks (Before Each Refactoring)

- [ ] Characterization tests exist for affected code (or add them NOW)
- [ ] All characterization tests currently PASS
- [ ] Understand what the code does (tests document this)
- [ ] Identified all affected locations
- [ ] Coverage is at least 60% for the code being changed

### Post-Flight Checks (After Each Refactoring)

- [ ] All characterization tests still PASS
- [ ] No behavioral change (tests prove this)
- [ ] No new warnings
- [ ] Diff is minimal (no accidental changes)

### Example: Characterization Before Dead Code Removal

Even "obviously safe" refactorings need verification:

```text
REFACTORING: Remove unused function oldHelper()
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 1: CHECK - Is oldHelper() truly unused?
  - Grep for "oldHelper" across codebase
  - Check for dynamic calls: obj["oldHelper"]
  - Check for reflection usage
  - Result: No references found ✓

Step 2: CHARACTERIZE - Prove it's safe to remove
  - Existing tests don't call oldHelper() ✓
  - No test failures when function body is commented out ✓
  - Characterization: Removal is safe

Step 3: REFACTOR - Delete the function
  - Remove lines 45-67 from src/utils.ts

Step 4: VERIFY - Run all tests
  - npm test → All 127 tests pass ✓
  - Behavior preserved ✓

Step 5: NEXT - Proceed to next refactoring
```

### Example: Characterization Before Extract Function

```text
REFACTORING: Extract validateUser() from processUser()
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Step 1: CHECK - Coverage for processUser()?
  - Current coverage: 45%
  - Missing: error paths, edge cases
  - Result: Need more characterization tests

Step 2: CHARACTERIZE - Add tests for lines being extracted

  // New characterization tests
  it('validates email format', () => {
    const user = { email: 'invalid' };
    expect(() => processUser(user)).toThrow('Invalid email');
  });

  it('validates name is not empty', () => {
    const user = { email: 'test@example.com', name: '' };
    expect(() => processUser(user)).toThrow('Name required');
  });

  - Run tests → All pass ✓
  - Coverage now: 78% ✓

Step 3: REFACTOR - Extract validateUser()
  - Move validation logic to new function
  - Call validateUser() from processUser()

Step 4: VERIFY - Run characterization tests
  - All tests pass ✓
  - Behavior preserved ✓

Step 5: NEXT - Proceed to next refactoring
```

### Batch Execution

For efficiency, batch similar refactorings - but verify characterization for each:

```text
EXECUTING BATCH: Dead Code Removal
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1/5] src/utils.ts:1 - unused import
      Characterization: No references found ✓
      Refactoring: Remove import ✓
      Tests: 127/127 pass ✓

[2/5] src/utils.ts:45 - unused function oldHelper()
      Characterization: No callers, no dynamic refs ✓
      Refactoring: Remove function ✓
      Tests: 127/127 pass ✓

[3/5] src/api.ts:102 - console.log statement
      Characterization: Debug only, no side effects ✓
      Refactoring: Remove line ✓
      Tests: 127/127 pass ✓

[4/5] src/services.ts:33 - commented code block
      Characterization: Dead code, git has history ✓
      Refactoring: Remove comments ✓
      Tests: 127/127 pass ✓

[5/5] src/models.ts:12 - TODO comment
      Characterization: Non-functional, safe to remove ✓
      Refactoring: Remove TODO ✓
      Tests: 127/127 pass ✓

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Batch complete: 5/5 refactorings applied
All characterizations verified ✓
All tests passing ✓
```

**CRITICAL**: If ANY characterization check fails, STOP the batch and investigate.

### Approval Flow (For Non-Safe Refactorings)

```text
APPROVAL REQUIRED: Extract Function
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

File: src/services/userService.ts
Lines: 45-78

BEFORE:
function processUser(user) {
  // 33 lines of mixed logic
}

AFTER:
function processUser(user) {
  const validated = validateUser(user);
  const transformed = transformUser(validated);
  return saveUser(transformed);
}

function validateUser(user) { ... }
function transformUser(user) { ... }
function saveUser(user) { ... }

Apply this refactoring? (y/n)
```

---

## Phase 6: VERIFY - Confirm No Regressions

### Fresh Verification Requirement

**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Every verification must follow this protocol:

1. **IDENTIFY** - Which command proves this claim?
2. **RUN** - Execute the command NOW (not from memory)
3. **READ** - Examine FULL output, count failures/errors
4. **VERIFY** - Does output match the claim?
5. **THEN CLAIM** - Only state success after steps 1-4

| Invalid Evidence | Valid Evidence |
|------------------|----------------|
| "Tests passed earlier" | Run `npm test` NOW, show output |
| "I just refactored it correctly" | Show test output proving behavior preserved |
| "The linter should be clean" | Run linter NOW, show zero errors |
| "Based on my changes, this works" | Run verification command, show proof |
| Previous run output (even 2 min ago) | Fresh run output from this moment |

### Red Flag Language - HALT Immediately

If you find yourself using these words, STOP and run the actual check:

| Red Flag | Meaning | Required Action |
|----------|---------|-----------------|
| "should pass" | Uncertainty | RUN the check, don't assume |
| "probably works" | No evidence | RUN the check, get evidence |
| "seems to be fine" | Hedging | RUN the check, confirm |
| "I believe it passes" | Assumption | RUN the check, prove it |
| "based on my changes" | Inference | RUN the check, verify |
| "obviously correct" | Overconfidence | RUN the check anyway |

**Any hedging language = missing verification.** Stop and run the actual check.

### Verification Checklist

| Check | Command | Expected |
|-------|---------|----------|
| **Tests pass** | `npm test` / `pytest` / `go test` | All pass |
| **Linter clean** | `npm run lint` / `ruff` / `golangci-lint` | No errors |
| **Type checker clean** | `tsc --noEmit` / `mypy` | No errors |
| **No new warnings** | Compare before/after | Same or fewer |

### Rollback Protocol

If any check fails after a refactoring:

1. **STOP** immediately
2. **Revert** the change (`git checkout <file>`)
3. **Report** what went wrong
4. **Ask** user how to proceed

```text
⛔ REFACTORING FAILED
━━━━━━━━━━━━━━━━━━━━━

Refactoring: Extract Function in src/services.ts
Error: Test failure - testUserCreation

Action taken: Reverted change
File restored: src/services.ts

Options:
1. Skip this refactoring and continue
2. Investigate and retry
3. Abort session

Which option?
```

### CHECKPOINT - Phase 6

After verification complete, run context compaction before reporting:

```text
/compact focus on: Phase 6 complete, [N] refactorings applied and verified, all tests passing, Phase 7 needs report generation
```

---

## Phase 7: REPORT - Generate Hygiene Report

> **STOP. Read [REPORT-TEMPLATE.md](references/REPORT-TEMPLATE.md) NOW** for report format.

### Report Contents

1. **Summary statistics** - Issues found, fixed, remaining
2. **Issues by category** - Breakdown by smell type
3. **Files hotspots** - Where most issues concentrate
4. **Trend analysis** - Comparison to previous runs
5. **Recommendations** - What to focus on next

### Save Location

Save report to: `docs/supercharge-reports/[YYYY-MM-DD]-report.md`

### Report Output

```text
SUPERCHARGE REPORT GENERATED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Session Summary:
  Issues Found:  27
  Issues Fixed:  18
  Issues Deferred: 9

Fixed by Severity:
  CRITICAL:  3/3 (100%)
  HIGH:      7/7 (100%)
  MEDIUM:    8/12 (67%)
  LOW:       0/5 (0%)

Report saved: docs/supercharge-reports/2026-02-05-report.md

Recommended next session focus:
  1. src/services/userService.ts (4 remaining issues)
  2. Complete MEDIUM priority naming fixes
```

---

## Rationalizations to Reject

| Excuse | Reality |
|--------|---------|
| "Let me rename everything at once" | **NO.** One refactoring at a time. Test between each. |
| "Tests can come after refactoring" | **NO.** Tests MUST exist before AND pass after. |
| "This is a quick fix, no need to test" | **NO.** All refactorings require verification. |
| "The code is obviously correct" | **NO.** Confidence ≠ evidence. Run the tests. |
| "I'll batch all the commits at the end" | **NO.** Commit after each verified batch. |
| "This file is too messy to refactor properly" | **NO.** Refactor incrementally. Small steps. |
| "Let me just rewrite this function" | **NO.** Refactoring preserves behavior. Rewriting doesn't. |
| "These naming changes are low risk" | **NO.** Even renames can break reflection, dynamic calls. |
| "The linter errors don't matter" | **NO.** Fix linter errors before refactoring more. |
| "I understand the code, I don't need tests" | **NO.** Characterization tests document behavior for future you. |
| "Writing tests first takes too long" | **NO.** Debugging broken refactorings takes longer. |
| "60% coverage is good enough" | **MAYBE.** 60% is minimum. 80%+ for complex code. |

---

## Red Flags - STOP Immediately

If you catch yourself doing any of these, STOP:

- Changing behavior while refactoring
- Refactoring code without tests
- Skipping Phase 1.5 (characterization) when coverage is low
- Skipping verification steps
- Batching too many changes before testing
- Assuming tests will pass without running them
- Ignoring test failures and continuing
- Making changes in generated files
- Refactoring code you don't understand
- Writing implementation before characterization tests pass
- Fixing bugs discovered during characterization (document now, fix later)

---

## Integration with superplan/superbuild

Supercharge generates plans compatible with `/superbuild`:

1. Run `/supercharge` to scan and plan
2. Review the generated plan
3. Run `/superbuild docs/supercharge-[date]-plan.md` to execute
4. Or continue execution in the same session

---

## Session State Tracking

For multi-session supercharge runs, track progress in `docs/supercharge-state.md`:

```markdown
# Supercharge Session State

**Codebase**: [project-name]
**Started**: [YYYY-MM-DD]
**Last Updated**: [YYYY-MM-DD]

## Current Phase
Phase 5: EXECUTE (in progress)

## Progress
- [x] Phase 1: DETECT - Stack identified (TypeScript, React, Jest)
- [x] Phase 2: SCAN - 27 issues found
- [x] Phase 3: PRIORITIZE - 3 critical, 7 high, 12 medium, 5 low
- [x] Phase 4: PLAN - Plan saved to docs/supercharge-2026-02-05-plan.md
- [ ] Phase 5: EXECUTE - 12/18 refactorings complete
- [ ] Phase 6: VERIFY
- [ ] Phase 7: REPORT

## Remaining Issues
| File | Severity | Smell | Status |
|------|----------|-------|--------|
| src/services/userService.ts | HIGH | Verbose Function | pending |
| src/utils/helpers.ts | MEDIUM | Magic Literals | pending |

## Resume Instructions
Continue from Phase 5, Task 13: Extract function in userService.ts:145
```

**Update this file after each session** to enable seamless continuation.

---

## Quick Reference

| Phase | Action | Reference |
|-------|--------|-----------|
| 1. DETECT | Identify stack, verify tests exist | - |
| 1.5. CHARACTERIZE | Add missing tests for untested code | CHARACTERIZATION-TESTS |
| 2. SCAN | Launch smell detection agents | AI-SLOP-CATALOG, SMELL-DETECTION-PROMPTS |
| 3. PRIORITIZE | Rank issues, identify quick wins | SEVERITY-MATRIX |
| 4. PLAN | Generate superplan-compatible plan | FOWLER-REFACTORINGS |
| 5. EXECUTE | Apply refactorings with verification | SAFE-REFACTORING-RULES |
| 6. VERIFY | Confirm tests pass, no regressions | - |
| 7. REPORT | Generate hygiene report | REPORT-TEMPLATE |
