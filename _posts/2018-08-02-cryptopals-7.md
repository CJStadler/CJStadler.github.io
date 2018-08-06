---
layout: post
title:  "Cryptopals challenge 7"
date:   2018-08-02 17:00:00 -0400
categories: cryptopals rust
---
The challenge: [https://cryptopals.com/sets/1/challenges/7](https://cryptopals.com/sets/1/challenges/7)
My solution: [https://github.com/CJStadler/cryptopals-rust/commit/32e4762](https://github.com/CJStadler/cryptopals-rust/commit/32e4762)

This was a very short challenge but I managed to have some difficulty with it
so maybe it's still worth writing a blog. The instructions say
> Do this with code.  
> You can obviously decrypt this using the OpenSSL command-line tool, but we're
> having you get ECB working in code for a reason.

But I didn't listen to this and tried to solve it using the `openssl`
command-line tool first (mostly so that I could then use the solution in the
test for my Rust implementation). Having never used `openssl` before how to do
this turned out to be far from "obvious" to me. Eventually I resorted to
googling and got this incantation from  [reddit](https://www.reddit.com/r/netsecstudents/comments/48nnmc/matasano_cryptopals_17_why_cant_i_decrypt_7txt/d0m4w35):
```
curl http://cryptopals.com/static/challenge-data/7.txt 2>/dev/null|openssl enc -aes-128-ecb -a -d -K '59454c4c4f57205355424d4152494e45' -nosalt
```
The thing getting passed to `-K` there is the hex representation of the ASCII
encoded key ("YELLOW SUBMARINE").[^1]

For the Rust implementation I used the `openssl` crate which made the solution
very simple:
```rs
use self::openssl::symm::{decrypt, Cipher};

fn decode_aes_128_ecb(ciphertext: &[u8], key: &[u8]) -> Vec<u8> {
    decrypt(Cipher::aes_128_ecb(), key, None, ciphertext).unwrap()
}
```

Hmm I should probably get rid of the `unwrap` and return a `Result` instead if
I'm going to be using this function in future challenges...

[^1]: For example (because I find this confusing), the first letter of the
    key, "Y", is coded as the bits `1011001` (most significant on the left) in
    ASCII. The bits `101` decode to "5" in hex, and `1001` to "9".
