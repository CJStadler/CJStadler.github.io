---
layout: post
title:  "Cryptopals challenge 9"
date:   2018-08-26 08:00:00 -0400
categories: cryptopals rust
---
The challenge: [https://cryptopals.com/sets/2/challenges/9](https://cryptopals.com/sets/2/challenges/9)

My solution: [https://github.com/CJStadler/cryptopals-rust/commit/8144a1](https://github.com/CJStadler/cryptopals-rust/commit/8144a1)

This should have been simple but I messed it up on the first try and had to
correct it [here](https://github.com/CJStadler/cryptopals-rust/commit/075e169).

It wasn't just a coding mistake — I misunderstood the algorithm and wrote
[an incorrect test](https://github.com/CJStadler/cryptopals-rust/commit/075e169)
in the first commit.

When the message length is a multiple of the blocksize I assumed that no
padding was necessary. Once you think about how to un-pad (de-pad?) a message
though it's clear this won't work. If a message is allowed to have no padding
then how do you know if the last byte represents the number of padding bytes, or
whether it is part of the message? So when the message length is equal to the
blocksize we must use a whole block of padding. The [spec](https://tools.ietf.org/html/rfc2315#page-22)
makes this clear:
> The padding can be removed unambiguously since all input is padded and no
  padding string is a suffix of another.

If I had implemented removing the padding too I would have caught this, but
because the challenge didn't specifically say to do so I didn't think about that
part and went through the challenge too quickly.

As frequently turns out to be the case, the fix actually made the code simpler,
because I had an unnecessary special case in the original implementation.
