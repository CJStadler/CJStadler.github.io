# CJStadler.github.io

My blog.

## Building the TODO app

The repo is included as a submodule but not served directly because it does not
include the built javascript file. Instead, this repo includes a Makefile which
builds the todo-app and copies the static files into `todo/`, from where they
are served.

This means that when the todo-app is updated this repo can pull in the changes
by running the following:

```bash
make
```

This `git pull`s and rebuilds the todo-app submodule, and copies the site files
into `todo/`.
