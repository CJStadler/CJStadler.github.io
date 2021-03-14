---
layout: post
title: Refactoring Algebraic Data Types into Bits
date: 2021-03-13 08:00:00 -0400
---

I just read [an excellent blog post][jp] by my co-worker Justin Pombrio
describing how algebraic data types can be refactored using the laws of algebra.
This was super interesting and I was continuously :mind-blown:. It also made me
think about another application: calculating the size of these data types.

I will provide some summary of Justin's post, but I highly recommend reading it
and I'm going to assume that you are at least familiar with algebraic data
types.

[jp]: https://justinpombrio.net/2021/03/11/algebra-and-data-types.html

## Refactoring with Algebra

The core idea is to establish a mapping between types and algebraic expressions.
We can then translate any type into an expression, apply the laws of algebra to
find an equivalent expression, and then translate that expression into a new
type. Since the expressions are equivalent, the types are also equivalent, and
so the new type is a valid refactoring.

Wait a second, what does "equivalence" of types mean here? That depends on how
we map between types and expressions.

The the specific mapping for algebraic data types is to represent each type as
an expression for the number of possible values of the type. For example, a
"product" type like `(A, B)` has `A * B` possible values. By the law of
commutivity we know
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
the bit?...

## Bits as an algebraic data type

Now we know how to refactor types using algebra. One "refactoring" we might want
to do for any type is to represent it using bits. This is pretty important
because on digital computers every type needs to be representable as bits, and
ideally we would do so using the fewest number of bits possible.

How can we represent bits as an algebraic data type? In Rust:
```rust
// This could be boolean, but for semantics...
enum Bit {
  Zero,
  One,
}

// An array of `N` `Bit`s.
type Bits<const N: usize> = [Bit; N];
```

Using Justin's derivations we can write the algebraic expressions for these types:
```
Bit     -> 1 + 1 = 2
Bits<N> -> Bit^N = 2^N
```

So with `N` bits we can represent `2^N` values! Surprise!

## Refactoring into bits

Since we have an algebraic expression for `Bits<N>`, we now know that refactor a
type `T` into an equivalent `Bits<N>` representation we need to transform its
expression into the form `2^N`. And since bits don't come in fractions we won't
always be able to find an exact representation (hence the `≥` instead of `=`
below). Generally:

```
    2^N ≥ log(T)
lg(2^N) ≥ lg(T)
      N ≥ lg(T)
```

So for any type `T` we can take the log (base 2) of the number of possible
values of `T` to find out how many bits we need for an equivalent representation.

### Concrete examples

Let's try this for some concrete types. First, some simple ones:
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

#### `Option<T>`

Sum types are more complicated. Let's start with `Option<T>`. How do we expect
this to be represented in memory? The simplest thing would seem to be to use 1
bit as a flag for whether the option is `None` or `Some`, plus the bits for `T`
itself.

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

I'm not sure how to interpret this. I guess it is fewer bits than we need for `()`.
Don't even _think_ about representing `!`! Unfortunately Rust doesn't do
anything weird here:

```rust
println!("{}", std::mem::size_of::<!>());
// prints 0
```

### Product types in general

We saw with `(bool, u8)`