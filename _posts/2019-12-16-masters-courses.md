---
layout: post
title: "What did I learn from my Masters?"
date: 2019-12-23 08:00:00 -0400
---

I just finished my Masters in Computer Science at Northeastern and have been
having two conflicting thoughts:

1. I can't remember anything I learned. Did I just waste two years and a bunch
   of money?
2. I knew so much less before going back to school than I do now.

To help resolve this I made a list of what I have learned over the last two
years — things that were interesting, seemed important, or just stuck with me
for some reason. Hopefully it can also serve as a reference and reminder to
myself in the future.

## Computer Systems

Online textbook: [http://pages.cs.wisc.edu/~remzi/OSTEP/](http://pages.cs.wisc.edu/~remzi/OSTEP/)

- Learned C.
- Learned assembly (MIPS).
  - Instructions operate on CPU registers. Data needs to be moved between
    registers and memory.
- Learned how to write makefiles.
- Memory layout: stack, heap, and text.
  - Code is data (text segment).
- OS and user process interaction.
  - Syscalls jump into kernel.
  - Hardware timer interupts transfer control to kernel.
- `fork` makes a new process by copying the current one.
- Atomic primitives are required to build locks.
- Processes see virtual memory. Translated to physical memory by OS + hardware.
- Files are represented as "inodes" in OS.
- Log-structured FS allows fast writes.
  - Wrote a FUSE log-structured filesystem in Python.
- The solution is always to add a layer of indirection.

## Algorithms

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
  is a program to compute it, `p[f]`. Every such program can be represented as an
  integer (by interpreting its source code as a binary integer), `i[f]`. Define a
  function `g(i[f]) = f(i[f]) + 1`. Then `g(i[g]) = g(i[g]) + 1`, which is
  contradictory. Therefore `g` cannot be represented by any program.

## Programming Design Paradigms

- Learned (more) Java.
- Properties of good design:
  - High cohesion: each component has one purpose.
  - Low coupling: changing one component does not require changes to those
    dependent on it.
- Information hiding facilitates lower coupling.
- SOLID:
  - Single responsibility.
  - Open for extension, closed for modification.
  - Liskov's substitution principle: if `S` subtypes `T` then objects of `S` can
    be used as objects of `T` without changing behavior.
  - Interface segregation: No client should be forced to depend on methods it
    does not use.
  - Dependency inversion: Abstractions should not depend on details. Details
    should depend on abstractions.

## Machine Learning

- Machine learning theory is a lot of math that's not very interesting to me.
  And applying it requires a lot of trial and error.

## Principles of Programming Languages

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
  - Used to implement recursion in non-recursive languages.
  - Still don't really understand this.
- Church encoding: represent natural numbers in a language with only functions.
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
       Γ ⊢ (A + B) : Number
  ```
  This means that `(A + B)` has type `Number` in environment `Γ` if `A` and
  `B` both have type `Number` in that environment.
- A continuation represents the state of a process.

## Engineering Reliable Software

- Testing can prove that properties are violated. Formal methods can prove that
  properties are never violated.
- Formal methods are applied to models. To analyze a concrete program it needs
  to be translated to a model. The translation limits the conclusions that can
  be drawn about the concrete program.
- A functional specification describes the output.
- Non-functional specifications:
  - Safety properties: violation is witnessed by a finite path. E.g. "X never
    happens".
  - Non-safety properties: violation is witnessed by an infinite path. E.g. "The
    program never terminates (liveness)".
- SMT solvers (e.g. Z3) check whether mathematical formulae are satisfiable, and
  if so can give a satisfying assignment.
- SMT solvers can be used to generate testcases to cover specific (or all)
  branches (KLEE).
- Temporal logic (LTL and CTL) allows us to make statements about the execution
  of finite state machines (model checking).
- I wrote a model checking library for Ruby state machines
  ([https://github.com/CJStadler/state_machine_checker](https://github.com/CJStadler/state_machine_checker)).

## Compilers

- Compilers seems to be viewed as a "hardcore" topic. On the first day: "if
  you have a girlfriend break up with her now."
- 20+ people in the class, 0 women... Above attitude probably doesn't help?
- Learned StandardML.
- Rice's theorem: all semantic properties of programs are undecidable
  (equivalent to halting).
  - Compiler writer's full employment theorem: there can be no perfect compiler
    (because such a compiler would need to decide whether a program halts).
- Programming languages are characterized by three structures: data, control,
  and environment (e.g. scope).
- A compiler is made up of several components, each of which requires its own
  specialized algorithms. We implemented a compiler with the following:
  - Lexer: string -> tokens. Uses regex.
  - Parser: tokens -> AST. Uses context free grammar.
  - Type checking (of AST).
  - AST -> IR
  - IR -> assembly (MIPS)
  - Register allocator. Uses graph coloring.
- Regex is equivalent to deterministic finite automota (DFA).
- A context free grammer (CFG) defines a set of strings (language).
  - "context free" because any non-terminal can always be expanded using any of
    its productions (to generate a valid string).
- Parsers can be generated from a CFG by tools like Yacc and Bison.
- Function call protocol/linkage defines how caller and callee communicate. E.g.
  where arguments and result go.
- Register allocation with graph coloring:
  1. Analyze live ranges of every variable.
  2. Construct interference graph. Variables with overlapping live ranges are
     connected.
  3. Color interference graph. Colors correspond to registers.
  4. If coloring fails spill a variable to the stack. GOTO 3.

## Introduction to CS Research

This was a survey type course where we read papers from many different areas of
Computer Science. Here are a few I found most interesting:

- Patterson et al.. 1988. [A case for redundant arrays of inexpensive disks
  (RAID)](https://www.cs.cmu.edu/~garth/RAIDpaper/Patterson88.pdf).
- Breiman, Leo. 2001. [Statistical Modeling: The Two
  Cultures](https://projecteuclid.org/euclid.ss/1009213726).
- Leroy, Xavier. 2006. [Formal certification of a compiler back-end or:
  programming a compiler with a proof
  assistant](https://xavierleroy.org/publi/compiler-certif.pdf).
  - Compiler (CompCert) and proofs are written in Coq.
  - Register allocation is done via graph coloring but because of its complexity
    this module is not certified (written in OCaml). Instead the coloring that
    is produced is verified. Thus the compiler is guaranteed to never produce an
    invalid coloring (but it may error out on valid code if there is a bug in
    the graph coloring implementation).

In addition, for my final project I read [Linking Types of Multi-Language
Software: Have Your Cake and Eat It
Too](https://www.ccs.neu.edu/home/amal/papers/linking-types.pdf) by Daniel
Patterson and Amal Ahmed, and then presented the paper to the class. A few
notes:

- "Fully abstract" compilation means that the semantics of the source program
  are preserved in the compiled program.
- Compilation destroys the guarantees of the source language. E.g. your
  language might be memory safe but once a program is compiled to assembly there
  is no way of enforcing this. This becomes a problem when linking with other
  programs because they may not follow the rules of your language.
- If the target language is typed and linking is done at this level then
  type-checking can be done at link time.
- The paper proposes annotating types in a source language to specify features
  of another language which we are linking with. E.g. if your language is pure
  you could specify when you allow impure functions (from other languages) to be
  passed.

That's it! In this condensed form it feels small relative to the two years I
spent, but I am very happy with what I have learned.
