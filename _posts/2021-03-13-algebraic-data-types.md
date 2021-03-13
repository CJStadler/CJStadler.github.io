---
layout: post
title: Refactoring Algebraic Data Types into Bits
date: 2021-03-13 08:00:00 -0400
published: false
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

Let's try this for some concrete types:
```
bool -> 2
      2^N ≥ 2
        N ≥ lg(2)
        N = 1
```
1 bit for a `bool`, that makes sense! Let's try a product type:
```
(bool, u8) -> 2 * (2^8) = 512
                    2^N ≥ 512
                      N ≥ lg(512)
                      N = 9
```
This is pretty clear: 1 bit for the `bool` plus 8 for the `u8` equals 9 bits.
Now a sum type:

```
Option<bool> -> 1 + 2 = 3
                  2^N ≥ 3
                    N ≥ lg(3)
                    N = 2
```
Even though there are only 3 possible values we need two bits. Let's try
something more complicated:

```
Option<Option<bool>> -> 1 + (1 + 2) = 4
                                2^N ≥ 4
                                  N ≥ lg(4)
                                  N = 2
```
Wait, how can this `Option<Option<bool>>` take the same space as
`Option<bool>`? There's an extra `Option` in there!

Since there are only 3 possible values of `Option<bool>` but it requires 2 bits,
one of the possible values of those bits was not being used. Since
`Option<Option<bool>>` only has one new value, we can assign it to that bit
value. We can write out a set of possible representations to prove that only two
bits are necessary:
```
             None -> 00
       Some(None) -> 01
Some(Some(false)) -> 10
 Some(Some(true)) -> 11
```

```
() -> 1
      2^N ≥ 1
        N ≥ lg(1)
        N = 0
```
0 bits??? I was actually surprised by this, but as Justin pointed out it is
correct in Rust:

```rust
println!("{}", std::mem::size_of::<()>());
// prints 0
```


