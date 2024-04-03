---
layout: post
title: Code Quality
date: 2023-11-25 00:00:00 -0400
---

Identify desireable attributes in code. These attributes are often in tension, which means optimizing for only one usually results in bad code. Code that is "elegant" is able to maintain the different attributes to a surprising level.

Goals:

- Correctness
- Performance
- Maintainability as its own goal, or part of the above two?
- Cost to write? Not relevant when reviewing code (except thinking about future cost), but if you're deciding on an approach it is important to consider.

Qualities:

- Units are obviously correct
- Units are loosely coupled?
- There is a minimum number of units

Below are a bunch of frequently discussed concepts related to code quality. Can they be organized somehow?

- Locality of behavior (https://htmx.org/essays/locality-of-behaviour/)
- Encapsulation
- Coupling
- Information hiding
- Separation of concerns
- DRY
- Naming
  - Short
  - Descriptive of behavior
- Extensibility
- Specificity (referencing by name instead of index)
- Abstraction
- Single responsibility principle (cohesion?)
- Reusability
- Cyclomatic complexity
- Avoid going from high information data (parsed) to low (serialized) and back. Reduces possibility of errors and duplication of code. In the other direction, don't parse something unnecessarily.

Does testing belong in here somewhere?