---
layout: page
title: Projects
permalink: /projects/
---

## [Trackr](http://trackr.cjstadler.com/)

![Trackr screenshot, showing my 1500 and 3000 times.](/assets/trackr.png)

Charts the race times of collegiate runners, to visualize progress and to
compare athletes. Data is scraped from [TFRRS](https://tfrrs.org).

Uses React, and D3 for the charts. I worked on this mostly in 2015, and
surprisingly the scraper has only needed to be updated once since then.

## [Lap Counter](/lap-counter)

![Lap counter screenshot](/assets/lap_counter.png)

Helps with counting the laps of runners in track races. In races where many
athletes are lapped (e.g. an indoor 5k) it can get very difficult to keep track
of how many laps everyone has to go if you are using pen and paper. With this
app the user just taps each runner each time they complete a lap, and the list
of athletes is kept sorted so that the next athlete should always be near the
top of the list. Leader is in green, lapped athletes are in red, current lap
times are displayed in the middle.

This was also written in 2015, and is more of a prototype than a usable
application.

## [Ruby State Machine Checker](https://github.com/CJStadler/state_machine_checker)

Verifies (as in proves, not tests) properties of state machines written with the
[state\_machines gem](https://rubygems.org/gems/state_machines).

This was a project for the formal methods course in my master's program (2019).
I was interested in making verification accessible to more developers, albeit in
a very limited manner. I still think it's pretty cool to be able to write
specifications in Ruby:

```rb
it "cannot fail after completed" do
  formula = AG(atom(:completed?).implies(neg(EF(:failed?))))
  # Translation: for all paths it is always true that from a `completed?` state
  # there is no path to a `failed?` state.
  expect { Payment.new }.to satisfy(formula)
end
```

And get readable error messages:

```
Expected state machine for Payment#state to satisfy
  "AG((completed?) => (¬(EF(failed?))))" but it does not.
Counterexample:
  [:started_processing, :complete, :started_processing, :pend, :failure]
```

This was all written in Ruby.

## [Floating Point Fast Math Exception Detector](https://github.com/CJStadler/floating-point-exceptions)

Identifies inputs to a program that are likely to cause exceptions if the
program is compiled with "fast math" flags. Ideally we would be able to compile
programs with these flags enabled, and still have confidence that unexpected
exceptions will not occur.

This was part of a research project I worked on in my master's program (2019)
with [Thomas Wahl](https://www.khoury.northeastern.edu/home/wahl/). I wrote an
LLVM pass for instrumenting floating point operations with exception checks, and
a Python program to compile the LLVM IR into SMT formulae.
