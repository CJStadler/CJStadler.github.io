---
layout: post
title:  "Cryptopals challenge 8"
date:   2018-08-06 08:00:00 -0400
categories: cryptopals rust
---
The challenge: [https://cryptopals.com/sets/1/challenges/8](https://cryptopals.com/sets/1/challenges/8)

My solution: [https://github.com/CJStadler/cryptopals-rust/commit/bd0d3c](https://github.com/CJStadler/cryptopals-rust/commit/bd0d3c)

This challenge was a little intimidating at first because there were no
specific instructions. Once I thought about it though it turned out to be
very simple.

The trick is that if a message contains duplicate blocks, when encoded using ECB
the resulting ciphertext will also contain duplicate blocks in the same
positions. My solution is just to count the number of unique blocks in each
line, and pick the line with the fewest.[^1] This of course will only work if
the message contains duplicate blocks. In "the wild" some types of messages are
more likely than others to contain duplicates (for example, images with
blocks of the same color pixels). The challenge doesn't say what the source of
the message is, but since it's meant to be solvable it of course contains
duplicate blocks.

## Rust

`Iterator` methods like `enumerate`, `map`, and `min` made expressing the
solution simple and clear. I'm still learning how to reason about the
performance implications of these methods in Rust though. For example, in Ruby
```rb
an_array.map { |x| f(x) }.min
```
would return a new array from `map` and then iterate through it to find the
minimum. This is not optimally space efficient though because you can avoid
allocating a new array by using a single loop to both do the "mapping" and to
find the minimum:
```rb
smallest = nil

an_array.each do |x|
  result = f(x)

  if smallest.nil? || result < smallest
    smallest = result
  end
end

smallest
```
There's a trade-off here between elegance and performance, and which one I would
pick depends mostly on the expected sizes of `an_array`.

I suspect that the Rust compiler might be "smart" enough to avoid the extra
allocations and combine the `map` and `min` into a single loop. A little testing
seems to confirm this:
```rs
let a: Vec<i64> = vec![-3, 0, 1, -1];
a.iter().map(|x| {
    println!("map");
    x * 2
}).min_by(|x, y| {
    println!("min");
    x.cmp(y)
}).unwrap();
```
[prints out](https://play.rust-lang.org/?gist=649ec6b8b76bfabd38a4b73759b1a9b7&version=stable&mode=release&edition=2015)
```
map
map
min
map
min
map
min
```
I haven't read a full explanation of how this works in Rust and how to reason
about it, so if there is one out there send it to me!

I also took advantage of Rust's borrowed slices to simply and efficiently
construct a `Vec` of blocks from each ciphertext. A slice is sort of a "view"
into the underlying data, so breaking the ciphertext into blocks does not
require any copying of the data itself.

[^1]: The lines all happen to be the same length, otherwise we would need to
    normalize the count.
