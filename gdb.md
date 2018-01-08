# Learning GDB Basics

I'm starting to learn C after primarily working in Ruby and one intimidating things about C so far is the lack of visibility into programs. The ability in Ruby to run code directly from a REPL — and in the middle of your program with `binding.pry` — gives me confidence that I understand how a program is behaving. So far coding in C feels more like working on a black box, but I'm hoping learning GDB will help with that.

Inspired by Julia Evans, I thought it would be useful to document what I've learned so far in the form of a blog post. I had trouble finding a good resource that gave a basic overview of GDB and its capabilities, so I want to try to do that here. Two resources that did help a lot were [this post by Julia Evans](https://jvns.ca/blog/2014/02/10/three-steps-to-learning-gdb/), and [this part of the GDB docs](https://sourceware.org/gdb/current/onlinedocs/gdb/Sample-Session.html). Using the `help` command from within `gdb` was also useful to learn more about the commands it supports. I have only just started using GDB so definitely let me know if there are any mistakes or if I am misunderstanding anything!

Here's the program we're going to walk through running `gdb` on:
```
#include <stdio.h>

int add(int a, int b) { return (a + b); }

void hello_world() {
  int i = add(1, 2);
  printf("Hello World %i\n", i);
}

int main(int argc, char **argv) { hello_world(); }
```

## Compile your program with symbols

The first step is to compile your program for GDB using the `-g` flag:
```
gcc -g src/main.c -o bin/main
```

I'm sure there is more to it than this, but what I've observed is that the `-g` flag compiles your program in such a way that `gdb` is able to create a mapping between lines in the source code and the binary.

## Set breakpoints

In Ruby (at least using Pry) I debug by setting breakpoints in the source and then running the program as normal. With GDB we instead run the `gdb` program, specify breakpoints, and then trigger our own program from within `gdb`. I think of debugging in Ruby as working from inside the target program, while `gdb` instead lets us inspect a program from the outside.

First we call `gdb` with the filename of our program's binary:
```
gdb bin/main
```

Then we use the `break` command from within `gdb` to set breakpoints:
```
(gdb) break hello_world
Breakpoint 1 at 0x6cc: file src/main.c, line 6.
```
This sets a breakpoint at the start of the `hello_world` function. We can then run the program, and execution will pause at the breakpoint:
```
(gdb) run
Starting program: .../bin/main

Breakpoint 1, hello_world () at src/main.c:6
6	  int i = add(1, 2);
```

We can also set a breakpoint at any line in the source code:
```
(gdb) break src/main.c:7
Breakpoint 1 at 0x6de: file src/main.c, line 7.
```

## Step through program execution

Once the program is paused we can step through execution using `next` and `step`. `next` (or `n`) resumes execution until the next source line of the current function — skipping over calls to other functions. `next` (or `s`) also resumes execution until the next line, but "steps into" called functions.

```
(gdb) run
Starting program: .../bin/main

Breakpoint 1, hello_world () at src/main.c:6
6	  int i = add(1, 2);
(gdb) next
7	  printf("Hello World %i\n", i);
```

To resume execution of the program until the next breakpoint, or until it completes, use `continue` (or `c`).

## Inspect program state

While execution is paused GDB has many tools that let us inspect the current state, and can function almost like a REPL. Here are some of the tools that seem most essential to me.

`print` displays the value of a variable:
```
(gdb) print i
$1 = 3
```
I'm not exactly sure what the `$1` means, but the value here is `2`.

`print` actually supports full expressions, not just variables, and we can even call functions:
```
(gdb) p add(4, 5)
$1 = 9
```

`whatis` prints the type of a variable:
```
(gdb) whatis i
type = int
```

`disassemble` shows the assembly code for the current function:
```
(gdb) disassemble
Dump of assembler code for function hello_world:
   0x00005555555546c4 <+0>:	  push   %rbp
   0x00005555555546c5 <+1>:	  mov    %rsp,%rbp
   0x00005555555546c8 <+4>:	  sub    $0x10,%rsp
   0x00005555555546cc <+8>:	  mov    $0x2,%esi
   0x00005555555546d1 <+13>:	mov    $0x1,%edi
   0x00005555555546d6 <+18>:	callq  0x5555555546b0 <add>
   0x00005555555546db <+23>:	mov    %eax,-0x4(%rbp)
=> 0x00005555555546de <+26>:	mov    -0x4(%rbp),%eax
   0x00005555555546e1 <+29>:	mov    %eax,%esi
   0x00005555555546e3 <+31>:	lea    0xba(%rip),%rdi        # 0x5555555547a4
   0x00005555555546ea <+38>:	mov    $0x0,%eax
   0x00005555555546ef <+43>:	callq  0x555555554560 <printf@plt>
   0x00005555555546f4 <+48>:	nop
   0x00005555555546f5 <+49>:	leaveq
   0x00005555555546f6 <+50>:	retq   
End of assembler dump.
```
The `=>` shows either the last or the next instruction, I'm not sure which.

I haven't worked with assembly before so this isn't very helpful to me right now, but I can see how it would useful to see how the compiler has translated your source into assembly. Perhaps there is a bug because your expectation of how the source should be compiled does not match the actual behavior of the compiler.

`x` lets us inspect a memory region by address. For example, we can use it to examine one of the addresses from the above assembly:
```
(gdb) x/s 0x5555555547a4
0x5555555547a4:	"Hello World %i\n"
```
The `/s` part specifies the format to display the data in — here I used `s` for a string.

## Quit

I often have trouble figuring out or remembering how to quit command line applications — CTRL+D or `quit` works for gdb.

I haven't used `gdb` to debug something I'm actually working on yet, but these are the things that seem like they will be most useful.
