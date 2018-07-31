---
layout: post
title:  "Cryptopals challenge 6"
date:   2018-07-31 10:00:00 -0400
categories: cryptopals rust
---

The [instructions for this challenge](https://cryptopals.com/sets/1/challenges/6)
are fairly detailed so I'm not going to go through each step. But, following
the instructions was only about half of the work — it didn't take long to
implement something that compiled and spit out a message, but I needed to spend
a lot of time fine-tuning the algorithm before it guessed the right key and
decoded the message correctly.

As test cases I used the example from the challenge, and the example that I
encoded in [challenge 5](https://cryptopals.com/sets/1/challenges/5).

The commit with my solution is [here](https://github.com/CJStadler/cryptopals-rust/commit/e3db08b).

## Do these bytes represent English?

Probably the most important change I made was improving my algorithm for scoring
whether some bytes represent English. Previously I had just been counting the
number of space characters (`32` in ASCII encoding), since I figured that they
occur more frequently in English than in random bytes. That worked well enough
for the earlier challenges but here it was resulting in incorrect guesses for
some of the bytes of the key.

To improve this I tried counting "e" in addition to spaces, but that wasn't good
enough either, so I extended it to the 9 most common English characters, and
weighted each of them by their frequency in English. Of course this would score
an input that is just a string of "e"s higher than any actual English text, so
it's far from perfect. I think a better solution would be to calculate the
difference between the expected and actual frequency of each character and then
sum them, sort of like a mean squared error. I'm interested to see whether
implementing that becomes necessary in later challenges, or whether my current
solution continues to be good enough.

## Guessing the key size

To guess the key size the instructions say to take a range of possible key sizes
and for each one calculate the edit distance between blocks of that size from
the ciphertext. It recommends "You could proceed perhaps with the smallest 2-3
KEYSIZE values. Or take 4 KEYSIZE blocks instead of 2 and average the
distances." I ended up needing to do both of these.

First I tried checking multiple blocks for each key size and then selecting the
single best key size. Even as I increased the number of blocks though this did
not always select the correct key size.

I then decided to return the N key sizes with the lowest edit distance, attempt
to guess the key for each of these, score each decoded message, and finally
return the message with the best score. Surprisingly, the hardest part of this
was selecting the key sizes with the lowest edit distance.

Originally I was mapping each key size to `(distance, keysize)` and taking the
`max`. I was hoping that there was a `max(n)` function which would
return the `n` elements of maximum value (like in [ruby's](https://ruby-doc.org/core-2.5.1/Enumerable.html#method-i-max)).
Unfortunately such a function doesn't seem to exist in `std`, so I had to
implement it myself.

The most obvious solution was to keep a vector of the best key sizes and update
it as I iterated through the array. This seemed a little complicated to
implement though, and I was hoping for something less imperative. My final
solution was to put the `(distance, keysize)` pairs into a max-heap (which
Rust's `BinaryHeap` is [guaranteed to be](https://doc.rust-lang.org/std/collections/struct.BinaryHeap.html))
and then `pop` off however many I wanted to return at the end. This was a good
learning experience as it required defining a struct and implementing traits.
While writing this I also realized that I could map the range of key sizes into
a binary heap, instead of iterating and `push`ing.

## Rust

With the challenges so far I haven't run into any major roadblocks from using
Rust. Since the challenges are small and self-contained solving them doesn't
require sharing a lot of state, so the borrow checker has not been an issue.
I have also been allowing myself to `unwrap` results when convenient, avoiding
some of the overhead of proper result handling. I'm sure there are lots of other
things that I am doing incorrectly or in less than ideal ways, but hopefully I
will continue to learn as I go!
