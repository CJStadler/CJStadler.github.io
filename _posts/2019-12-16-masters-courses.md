---
layout: post
title: "What did I learn from my Masters?"
date: 2019-02-20 08:00:00 -0400
---

### Computer Systems

Online textbook: [http://pages.cs.wisc.edu/~remzi/OSTEP/](http://pages.cs.wisc.edu/~remzi/OSTEP/)

- Learned C.
- Learned assembly (MIPS).
  - Instructions operate on CPU registers. Data needs to be moved between
    registers and memory.
- Learned how to use `make`.
- Memory layout: stack, heap, and text.
  - Code is data (text segment).
- OS and user process interaction.
  - Syscalls jump into kernel.
  - Hardware timer interupts transfer control to kernel.
- `fork` makes a new process by copying the current one.
- Atomic primitives are required to build locks.
- Processes see virtual memory. Translated to physical memory by OS + hardware.
- File is represented as an "inode" in OS.
- Log-structured FS allows fast writes.
  - Wrote a FUSE log-structured filesystem in Python.
- The solution is always to add a layer of indirection.

### Algorithms

- `O(f)` is the set of all functions which can be bounded above by a function
  roughly proportional to `f`. Given a function `g`, can I find a function
  roughly proportional to `f` that is always larger than `g`?
- `Ω(f)` is the same, but bounded below instead of above.
- `Θ(f)` is the intersection of `O(f)` and `Ω(f)`.
- To compute less store re-usable data.
  - Memoization is unbounded caching. "Top-down".
  - Dynamic programming is "bottom-up". Need to know structure of problem in
    advance, not as general purpose as memoization.
- Comparison-based sorting cannot be better than `O(n log(n))` on average.
- If the range of values is known in advance then sorting can be `O(n)`.
- Hashing doesn't need to be complicated:
  ```
  fun hash (a: int, b: int): int = a + b
  ```
  If `a` and `b` are uniformly distributed then their sum will be.
- String search algorithms: Boyer-Moore-Horspool, Knuth-Morris-Pratt,
  Rabin-Karp.
- Cryptosystems:
  - Public key: anyone can send a message that only the private key owner can
    decrypt, and the private key owner can send a message that everyone can
    prove that only they could have sent.
  - RSA: hard to break because it is hard to find prime factors of a large
    number.
- `P`: problems solveable in polynomial time.
- `NP`: problems whose solutions can be verified in polynomial time.
- Proof of undecidable functions: Suppose for every function `f: N -> N` there
  is a program to compute it, `p_f`. Every such program can be represented as an
  integer (by interpreting its source code as a binary integer), `i_f`. Define a
  function `g(i_f) = f(i_f) + 1`. Then `g(i_g) = g(i_g) + 1`, which is
  contradictory. Therefore `g` cannot be represented by any program.

### Programming Design Paradigms

- Learned (more) Java.
- Properties of good design:
  - High cohesion: each component has one purpose.
  - Low coupling: changing one component does not require changes to those
    dependent on it.
  - Hides information: facilitates lower coupling.
- SOLID:
  - Single responsibility.
  - Open for extension, closed for modification.
  - Liskov's substitution principle: if `S` subtypes `T` then objects of `S` can
    be used as objects of `T` without changing behavior.
  - Interface segregation: No client should be forced to depend on methods it
    does not use.
  - Dependency inversion: Abstractions should not depend on details. Details
    should depend on abstractions.

### Machine Learning

- Machine learning is a lot of math that's not very interesting to me. And in
  practice it requires a lot of trial and error.

### Principles of Programming Languages

- Learned Racket.
- Use Backus-Naur Form to specify syntax.
- First class functions: are "normal" values.
- Environment maps identifiers to values.
- Lexical scope: environment is determined by definition location.
  - A closure is the body of a function and an environment.
- Dynamic scope: environment is determined by call location.
- Y combinator:
  ```
  (define Y
    (lambda (f)
      ((lambda (x) (f (x x)))
       (lambda (x) (f (x x))))))
  ```
  - Has the property `(Y f) = (f (Y f))`.
  - Useful to implement recursion in non-recursive languages.
- Church numerals: encode natural numbers as functions.
- Lazy vs. eager evaluation
  - Call by name: expression re-evaluated at every use.
  - Call by need: expression only evaluated once (when first needed).
  - How to do side-effects (e.g. I/O) in a lazy languages? Build a type
    representing the side-effects.
- Macros are functions that map code to code.
  - Hygiene problem: naming conflicts between macro and calling code. Generated
    symbols should not equal any other symbols.
- True union types (e.g. Racket) vs. disjoint/tagged unions (ML).
- Type judgements:
  ```
  Γ ⊢ A : Number   Γ ⊢ B : Number
  ———————————————————————————————
       Γ ⊢ {+ A B} : Number
  ```
  This means that `{+ A B}` has type `Number` in environment `Γ` if `A` and
  `B` both have type `Number` in that environment.
- A continuation represents the state of a process.

### Engineering Reliable Software

- SMT solvers (Z3)
- LTL and CTL

### Compilers

- Learned StandardML.
- A compiler is made up of several components, each of which requires its own
  specialized algorithms. We implemented a compiler with the following:
  - Lexer: string -> tokens. Uses regex.
  - Parser: tokens -> AST. Uses context free grammar.
  - Type checking
  - AST -> IR
  - IR -> assembly (MIPS)
  - Register allocator. Uses graph coloring.

### Introduction to CS Research

- CompCert
- Linking types
