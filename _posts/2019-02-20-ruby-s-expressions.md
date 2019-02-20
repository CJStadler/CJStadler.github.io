---
layout: post
title:  "Ruby in S-Expressions?"
date:   2019-02-20 08:00:00 -0400
categories: ruby
---

Since parenthesis are optional in function application, why not do `(foo a, b,
c)` Instead of `foo(a, b, c)`?

```rb
def send(f, o, *args, &block)
  o.public_send(f, *args, &block)
end

(puts (send :join,
            (send :map,
                  (send :push, (Array 1), 2),
                  &(->(n) { send :*, n, n })),
            ", "))
```

Not quite there...
