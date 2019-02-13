# Notes on Dijkstra's Structured Programming

- We can't fully test most components, so we must take the internal structure
  into account (4).
  - We have to be able to make sense of the structure.
  - "In other words, we remark that the extent to which the program
    correctness can be established is not purely a function of the program's
    external specifications and behaviour but depends critically upon its internal
    structure." (5)
  - "usefully structured" (5)
  - "Program testing can be used to show the presence of bugs, but never to
    show their absence!" (6)
- "Computers are extremely flexible and powerful tools and many feel that their
  application is changing the face of the earth. I would venture the opinion that
  as long as we regard them primarily as tools, we might grossly underestimate
  their significance. Their influence as tools might turn out to be but a ripple
  on the surface of our culture, whereas I expect them to have a much more
  profound influence in their capacity of intellectual challenge!" (6)

- Types of reasoning:
  - Enumeration: step through each step.
  - Induction
  - Abstraction

- Structural control flow can always be translated into jumps, but the opposite
  is not true (20).
- Structural programming limits the necessity of enumerative reasoning (20).
  - Because we can rely on known theorems relevant to the structures.

- Two programs with the same behavior (24):
  ```rb
  if b2
    while b1
      s1
    end
  else
    while b1
      s2
    end
  end
  ```
  ```rb
  while b1
    if b2
      s1
    else
      s2
    end
  end
  ```
  - The second seems more elegant (shorter) but the first could be better if
    `b1` represents two distinct conditions, which happen to be represented by
    the same computation.

- Layers of abstraction (29):
  ```
  print_first_thousand_prime_numbers()
  ```
  ->
  ```
  primes = first_thousand_primes()
  print(primes)
  ```
