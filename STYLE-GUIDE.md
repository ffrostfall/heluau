# Style Guide

---

## Casing

- For anything which doesn't end up in the compiled bytecode\* use SCREAMING_SNAKE_CASE
- For variables & function names, use snake_case

\* This means functions which will ALWAYS be inlined (e.g. `local function REAL(n) return n.x end`), and constants which get constant folded.

## Functions

Since functions need to be local to be inlined, each publicly exposed function should be named `<scope>_<name>`. For example, `complex_conjugate`, where `complex` is the name of the library the function is a member of, and `conjugate` is the operation.

For "short accessor functions" (for example, `REAL` in complex.luau), use SCREAMING_SNAKE_CASE.

## File Structure

In the order of top to bottom:

1. Constants
2. Imports
3. Variables
4. Functions
5. Return statement

## Metatables

`__index` and `__newindex` are okay, but metamethods like `__add` are difficult to make type-safe and end up hurting refactorability and performance, so we should avoid them.

## Comments

Generally, shy away from comments.

Section comments are okay if the ordering is not obvious (e.g. local function ordering).

Comments should be used in situations where the code does not make itself immediately obvious, explaining _why_ and _what_, not _how_. If there is some black magic witchcraft going on, comments should be used.
