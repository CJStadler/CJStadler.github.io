---
layout: post
title: 3 * 2 bits = 5 bits
date: 2021-03-21 08:00:00 -0400
---

My co-worker Justin recently wrote [a great blog post][jp] describing how
algebraic data types can be refactored using the laws of algebra. This was super
interesting and I was continuously __:mind-blown:__. It also gave me an idea: if we
represent bits as an algebraic data type can we "refactor" any type into bits?
This would basically tell us how much space the type requires in memory.
Obviously this is a kind of roundabout way to figure that out, but I found it
to be an interesting exercise.

Before getting to that I will provide some summary of Justin's post, but I'm
going to assume that you are at least familiar with algebraic data types (Justin
gives a [great explanation][adts]).

[jp]: https://justinpombrio.net/2021/03/11/algebra-and-data-types.html
[adts]: https://justinpombrio.net/2021/03/11/algebra-and-data-types.html#algebraic-data-types

## Refactoring with Algebra

The core idea is to establish a mapping between types and algebraic expressions.
We can then translate any type into an expression, apply the laws of algebra to
find an _equivalent_ expression, and then translate that expression into a new
type. Since the expressions are equivalent, the types are also equivalent.

What does "equivalence" of types mean here? That depends on how we map between
types and expressions.

For algebraic data types we map each type to an algebraic expression for the
number of possible values of the type. For example, a "product" type like `(A,
B)` has `A * B` possible values. By the commutative property we know

```
A * B = B * A
```

and so

```
(A, B) = (B, A)
```

These types are equivalent in the sense that they have the same number of
possible values. This "number of possible values" seems like some kind of
representation of information. Hmm, isn't the standard unit of information
[the bit][bit]? How can we relate this metric to bits?

[bit]: https://en.wikipedia.org/wiki/Bit

## Bits as an algebraic data type

Now we know how to refactor types using algebra. One "refactoring" we might want
to do for any type is to represent it using bits. This is pretty important
since we use digital computers where everything is represented as bits, and
ideally we would like to use as few bits as possible.

The first step is to write an algebraic data type for bits. In Rust we could
write:

```rust
// This could be boolean, but for semantics...
enum Bit {
  Zero,
  One,
}

// An array of `N` `Bit`s.
type Bits<const N: usize> = [Bit; N];
```

Then, using Justin's derivations, we can write the algebraic expressions for
these types:

```
Bit -> 1 + 1 = 2
Bits<N> = [Bit; N] -> Bit^N = 2^N
```

So with `N` bits we can represent `2^N` values! Surprise!

## Refactoring into bits

Since we have an algebraic expression for `Bits<N>`, we now know that refactor a
type `T` into an equivalent `Bits<N>` representation we need to transform its
expression into the form `2^N`. Since bits don't come in fractions we won't
always be able to find an exact representation (hence the `≥` instead of `=`
below). Generally:

```
    2^N ≥ log(T)
lg(2^N) ≥ lg(T)
      N ≥ lg(T)
```

So for any type `T` we can take the log (base 2) of the number of possible
values of `T` to find out how many bits we need for an equivalent representation.

Again, "equivalence" here just refers to the amount of information, so process
won't tell us anything about _how_ to represent types using these bits.

### Concrete examples

Let's try this for some concrete types.

```
bool -> 2
  2^N ≥ 2
    N ≥ lg(2)
    N = 1
```
1 bit for a `bool`, that makes sense! How about a product type?

```
(bool, u8) -> 2 * (2^8) = 512
                    2^N ≥ 512
                      N ≥ lg(512)
                      N = 9
```
This is what I would expect: 1 bit for the `bool` plus 8 for the `u8` equals 9
bits.

#### The unit type

```
() -> 1
2^N ≥ 1
  N ≥ lg(1)
  N = 0
```
0 bits??? Even though I knew that Rust stores `()` in 0 bits I was still
surprised that the math worked out. Good job math!

```rust
println!("{}", std::mem::size_of::<()>());
// prints 0
```

#### The empty type

```
 ! -> 0
2^N ≥ 0
  N ≥ lg(0)
  N = -∞
```

I'm not sure how to interpret this. I guess it is fewer bits than we need for
`()` — Don't even _think_ about representing `!`! Unfortunately Rust doesn't do
anything interesting here:

```rust
println!("{}", std::mem::size_of::<!>());
// prints 0
```

#### `Option<T>`

Sum types seem a bit more complicated. Let's start with `Option<T>`. How do we
expect this to be represented in memory? The simplest thing would seem to be to
use 1 bit as a flag for whether the option is `None` or `Some`, plus the bits
for `T` itself.

For example, I would expect `Option<bool>` to require two bits. Let's check:

```
Option<bool> -> 1 + 2 = 3
                  2^N ≥ 3
                    N ≥ lg(3)
                    N = 2
```

That looks good. How about if we wrap it in another `Option`? By my logic above
this will take 3 bits: 1 for each layer of `Option`, and 1 for the `bool`.

```
Option<Option<bool>> -> 1 + (1 + 2) = 4
                                2^N ≥ 4
                                  N ≥ lg(4)
                                  N = 2
```

Wait, how can this `Option<Option<bool>>` take the same space as
`Option<bool>`? There's an extra `Option` in there!

You may have noticed that there were only 3 possible values of `Option<bool>`
but we had to round `lg(3)` up to 2 bits. This means that one of the possible
values of those bits was not being used. Since `Option<Option<bool>>` only has
one new value, we can assign it to that bit value. To prove this beyond a doubt
let's write out possible bit representation for each `Option<Option<bool>>`.

```
             None -> 00
       Some(None) -> 01
Some(Some(false)) -> 10
 Some(Some(true)) -> 11
```

The Rust compiler is enough to take advantage of this in practice, instead of
using the naive representation I described above. The `Option` [docs][opt]
describe how `Option<T>` has the same size `T`, for certain `T`.

[opt]: https://doc.rust-lang.org/std/option/#representation

### Sum types in general

Here's a generic sum type with `m` variants:

```rust
enum Sum<T1, ..., Tm> {
  T1Variant(T1),
  ...,
  TmVariant(Tm),
}
```

If a variant contains no type (like `None`) we can pretend that it actually
contains the unit type (e.g. `None(())`).

How do we expect this to be represented in memory? I would think you need
`lg(m)` bits as a "tag", plus however many bits are needed for the largest
variant: `lg(m) + lg(max(T1, ..., Tm))`. Can we find a smaller representation?

```
Sum<T1, ..., Tm> -> T1 + ... + Tm
              2^N ≥ T1 + ... + Tm
                N ≥ lg(T1 + ... + Tm)
```

Hmm I don't think there's anything we can do to simplify this (although my math
is very ~rusty~). We can at least prove that `lg(m) + lg(max(T1, ... Tm))` is
valid though:

```
define MaxT = max(T1, ..., Tm)
then, since MaxT ≥ Ti for all Ti:
  N ≥ lg(MaxT + ... + MaxT)
    = lg(m * MaxT)
    = lg(m) + lg(MaxT)
  N ≥ lg(m) + lg(MaxT)
```

Applying this to our `Option<Option<bool>>` we get `lg(2) + lg(3)` which rounds
up to 3 bits. So unfortunately we didn't find the 2 bit representation this way.

### Product types in general

We calculated the number of bits we need for `(bool, u8)`, but what about for
product types in general? I.e., can we say how many bits are necessary for a
product type with `m` fields?

```
(T1, ..., Tm) -> T1 * ... * Tm
           2^N ≥ T1 * ... * Tm
             N ≥ lg(T1 * ... * Tm)
             N ≥ lg(T1 * ... * Tm)
             N ≥ lg(T1) + ... + lg(Tm)
```

That makes sense, the total number of bits is equal to the sum of the bits
needed for each field.

Wait a second, that's not exactly what the equation says! For example, if `T1`
has only 3 values then by itself it requires 2 bits, but `lg(T1)` is less 
than 2. This means that we could potentially need fewer bits for the product
type than the sum of the bits of the individual types! Can we find such a type?

We need a `T` for which `lg(T)` is not an integer. Let's go back to our
`Option<bool>`, which only has 3 values but requires 2 bits by itself. We would
therefore naively expect a 3-tuple of `Option<bool>` to take 6 bits. Let's
check:

```
(Option<bool>, Option<bool>, Option<bool>)
->
3 * 3 * 3 = 27
      2^N ≥ 27
        N ≥ lg(27)
        N ≥ 4.755
        N = 5
```

Woah only 5 bits! This was genuinely surprising to me. A product type is made up
of several distinct types, but this suggests that by thinking about the
representation _holistically_ you can use fewer bits.

Of course, this doesn't seem very practical though because it makes accessing
individual elements more complicated. The bits representing an individual
element may not exist within the bits of the product type. And mutating one
element might requiring changing the whole representation. Maybe it could be
useful for storage, but I'm not sure it will play nicely with compression
algorithms.

## Conclusion

I don't think we discovered anything very practical, but I found this linkage
between bits and abstract data types interesting. Bits and representing data
structures in memory seems like it belongs on the "applied" side of CS, while
algebraic data types are on the "theory" side, but this reminded me of how they
are deeply related.

### Appendix: `Vec<A>`

Justin [proves][vec] that a `Vec<A>` has `1 / (1 - A)` possible values. This is
a _bit_ odd because it seems like `Vec<A>` should have infinite possible values,
and yet applying that formula to `Vec<bool>`, for example, gives -1.

The result will clearly be negative for any `A` > 1. But for `Vec<!>` we get `1
/ (1 - 0) = 1`. That actually makes sense because the only possible value is the
empty vec!

Going back to `Vec<bool>`, how many bits do you need to represent -1 values?

```
Vec<bool> -> -1
       2^N ≥ -1
         N ≥ lg(-1)
         N ≥ (i π)/log(2)
```

Makes sense to me...

[vec]: https://justinpombrio.net/2021/03/11/algebra-and-data-types.html#lists

[^neg]: 
