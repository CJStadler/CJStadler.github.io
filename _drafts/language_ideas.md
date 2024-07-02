---
layout: post
title: Language ideas
---

- Rust, but tradeoff performance for ease of use.
- Require named parameters? Works nicely with currying because you don't need to worry about order.
- No methods, just functions. Need a way to search for functions that take X type.
- Values immutable by default.
- Functions that take mutable arguments cannot return data from those arguments.
- No closures that capture implicitly. Either:
  - Syntax for naming captures
  - Make currying easy: `set_args(f, a: 1, b: 2)`.
- Concurrency:
  - `par_iter` type thing.
  - Structured:
    ```
      results = wait_for(f1,f2,f3)
    ```
- Modules? Interfaces?
- "type systems are the parts of formal methods that we’ve figured out how to make easy" https://without.boats/blog/ownership/
