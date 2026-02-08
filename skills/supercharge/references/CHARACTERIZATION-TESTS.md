# Characterization Tests

> **MANDATORY**: Read this reference during Phase 1.5 (CHARACTERIZE) before any refactoring.

Characterization tests capture what code *actually does* - not what it *should do*. They provide a safety net for refactoring by documenting existing behavior.

---

## What Are Characterization Tests?

From Michael Feathers' "Working Effectively with Legacy Code":

> "A characterization test is a test that characterizes the actual behavior of a piece of code. There's no 'expected' behavior... the expected behavior is simply the current behavior."

### Purpose

| Goal | How Characterization Tests Help |
|------|--------------------------------|
| **Preserve behavior** | Tests fail if refactoring changes output |
| **Document behavior** | Tests show what code actually does |
| **Find surprises** | Tests reveal edge cases and bugs |
| **Enable refactoring** | Safety net allows confident changes |

### Characterization vs Traditional Tests

| Aspect | Traditional Tests | Characterization Tests |
|--------|------------------|----------------------|
| **When written** | Before code (TDD) | After code exists |
| **Assert what** | Expected behavior | Actual behavior |
| **Purpose** | Drive design | Enable refactoring |
| **Failure meaning** | Code is wrong | Behavior changed |

---

## When to Write Characterization Tests

| Situation | Action |
|-----------|--------|
| File has 0% test coverage | Write characterization tests for all public functions |
| File has <60% coverage | Add tests for uncovered branches |
| Function is complex (>30 lines) | Characterize all code paths before extracting |
| Behavior is unclear | Write tests to document what it does |
| About to refactor | Ensure behavior is captured first |

---

## Step-by-Step Process

### Step 1: Identify the Code to Characterize

```text
TARGET IDENTIFICATION
━━━━━━━━━━━━━━━━━━━━━

File: src/services/userService.ts
Functions to characterize:
  - processUser(user) - 0% coverage, 45 lines
  - validateEmail(email) - 0% coverage, 12 lines
  - formatName(name) - 0% coverage, 8 lines

Priority: processUser (most complex, most issues)
```

### Step 2: Identify Inputs and Outputs

For each function, document:

- **Parameters**: Types, valid ranges, edge cases
- **Return value**: Type, possible values
- **Side effects**: Database writes, API calls, global state
- **Dependencies**: External services, other functions

```text
FUNCTION ANALYSIS: processUser(user)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Inputs:
  - user: { id: string, name: string, email: string, role?: string }
  - Optional: user.role defaults to "user"

Outputs:
  - Returns: { ...user, processed: true, timestamp: Date }
  - Side effects: Logs to console, writes to database

Dependencies:
  - database.save() - mocked for testing
  - logger.info() - mocked for testing
```

### Step 3: Call the Code with Sample Inputs

Write a test that calls the function and observes the output:

```typescript
// TypeScript/Jest example
describe('processUser characterization', () => {
  it('characterizes basic user processing', () => {
    const input = { id: '1', name: 'Test User', email: 'test@example.com' };

    const result = processUser(input);

    // First run: observe what it returns
    console.log('Actual result:', JSON.stringify(result, null, 2));
    // Output: { id: '1', name: 'TEST USER', processed: true, ... }
  });
});
```

### Step 4: Assert the Actual Behavior

Whatever the code returns, assert THAT:

```typescript
describe('processUser characterization', () => {
  it('converts name to uppercase', () => {
    const input = { id: '1', name: 'Test User', email: 'test@example.com' };

    const result = processUser(input);

    // Assert what it ACTUALLY does (uppercase transformation)
    expect(result.name).toBe('TEST USER');
  });

  it('adds processed flag', () => {
    const input = { id: '1', name: 'Test', email: 'test@example.com' };

    const result = processUser(input);

    expect(result.processed).toBe(true);
  });

  it('preserves original id', () => {
    const input = { id: '123', name: 'Test', email: 'test@example.com' };

    const result = processUser(input);

    expect(result.id).toBe('123');
  });
});
```

### Step 5: Cover Edge Cases

Characterize behavior for edge cases:

```typescript
describe('processUser edge cases', () => {
  it('handles empty name', () => {
    const input = { id: '1', name: '', email: 'test@example.com' };

    const result = processUser(input);

    // Document actual behavior (maybe it returns empty string)
    expect(result.name).toBe('');
  });

  it('handles missing email', () => {
    const input = { id: '1', name: 'Test' } as any;

    // Document that it throws (or doesn't)
    expect(() => processUser(input)).toThrow('Email required');
  });

  it('handles null input', () => {
    // Document actual behavior for null
    expect(() => processUser(null as any)).toThrow();
  });
});
```

---

## Language-Specific Examples

### JavaScript/TypeScript (Jest)

```typescript
// Characterization test for legacy function
describe('calculateDiscount (characterization)', () => {
  // Capture current behavior, even if surprising
  it('returns 0 for negative quantities', () => {
    expect(calculateDiscount(-5, 100)).toBe(0);
  });

  it('applies 10% discount for quantities > 10', () => {
    expect(calculateDiscount(15, 100)).toBe(135); // 15 * 100 * 0.9
  });

  it('truncates decimal prices', () => {
    // Discovered: function uses Math.floor internally
    expect(calculateDiscount(1, 99.99)).toBe(99);
  });
});
```

### Python (pytest)

```python
# Characterization test for legacy function
class TestProcessOrderCharacterization:
    def test_empty_items_returns_zero(self):
        # Document actual behavior
        result = process_order([])
        assert result == {"total": 0, "items": [], "status": "empty"}

    def test_single_item_calculation(self):
        items = [{"name": "Widget", "price": 9.99, "qty": 2}]
        result = process_order(items)
        # Capture actual rounding behavior
        assert result["total"] == 19.98

    def test_discount_applied_over_100(self):
        items = [{"name": "Widget", "price": 50, "qty": 3}]
        result = process_order(items)
        # Discovered: 5% discount for orders > $100
        assert result["total"] == 142.5  # 150 * 0.95
```

### Go

```go
// Characterization test for legacy function
func TestParseConfig_Characterization(t *testing.T) {
    tests := []struct {
        name     string
        input    string
        expected Config
    }{
        {
            name:  "empty string returns defaults",
            input: "",
            expected: Config{Port: 8080, Host: "localhost"},
        },
        {
            name:  "partial config merges with defaults",
            input: "port=3000",
            expected: Config{Port: 3000, Host: "localhost"},
        },
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := ParseConfig(tt.input)
            if result != tt.expected {
                t.Errorf("got %v, want %v", result, tt.expected)
            }
        })
    }
}
```

---

## Coverage Targets

| File Type | Minimum Coverage | Target Coverage |
|-----------|-----------------|-----------------|
| Business logic | 60% | 80%+ |
| Utility functions | 70% | 90%+ |
| API handlers | 50% | 70%+ |
| Complex algorithms | 80% | 95%+ |

### What to Cover

- [ ] Happy path (normal inputs)
- [ ] Edge cases (empty, null, negative, max values)
- [ ] Error cases (invalid inputs, exceptions)
- [ ] Boundary conditions (0, 1, max-1, max)
- [ ] State transitions (if stateful)

### What NOT to Cover

- Trivial getters/setters (unless they have logic)
- Framework-generated code
- Third-party library internals
- Code scheduled for deletion

---

## Discovering Surprising Behavior

Characterization tests often reveal bugs or unexpected behavior. **Document these but don't fix them yet.**

```typescript
describe('calculateTax (characterization)', () => {
  it('SURPRISING: returns negative tax for negative amounts', () => {
    // This is probably a bug, but document it first
    // Fix in a separate commit AFTER characterization
    expect(calculateTax(-100)).toBe(-10);
  });

  it('SURPRISING: rounds differently for amounts ending in .5', () => {
    // Banker's rounding? Document the actual behavior
    expect(calculateTax(10.5)).toBe(1.05);
    expect(calculateTax(11.5)).toBe(1.15);
  });
});
```

### Tagging Surprises

Use comments to flag surprising behavior:

```typescript
// CHARACTERIZATION: Unexpected behavior - negative values not rejected
// CHARACTERIZATION: Possible bug - rounding inconsistency
// CHARACTERIZATION: Undocumented feature - applies discount twice
```

---

## Integration with Red-Green-Refactor

### Before Refactoring

1. Write characterization tests (they should all PASS)
2. Run coverage report
3. Ensure >60% coverage on code to be refactored
4. Commit characterization tests separately

### During Refactoring

1. Make one small change
2. Run characterization tests
3. If tests FAIL → refactoring changed behavior → REVERT
4. If tests PASS → refactoring preserved behavior → continue

### After Refactoring

1. All characterization tests still pass
2. Consider converting characterization tests to specification tests
3. Add new tests for new behavior (if any)

---

## Anti-Patterns

| Anti-Pattern | Why It's Bad | Better Approach |
|--------------|--------------|-----------------|
| Asserting implementation details | Tests break on valid refactoring | Assert observable behavior only |
| Mocking everything | Doesn't characterize real behavior | Use real dependencies when safe |
| Too many assertions per test | Hard to identify failures | One concept per test |
| Ignoring edge cases | Bugs slip through refactoring | Cover all discovered paths |
| Fixing bugs in characterization | Conflates fixing with characterizing | Document now, fix later |

---

## Checklist Before Proceeding

- [ ] All public functions have characterization tests
- [ ] Coverage meets minimum threshold (60%+)
- [ ] Edge cases are documented
- [ ] Surprising behaviors are tagged
- [ ] Tests are committed separately from refactoring
- [ ] All characterization tests pass

```text
CHARACTERIZATION COMPLETE
━━━━━━━━━━━━━━━━━━━━━━━━━

Files characterized: 3
Tests added: 35
Coverage achieved: 78%
Surprises documented: 4

Ready for Phase 2 (SCAN).
```
