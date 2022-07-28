# CJStadler.github.io

My blog.

Start locally with
```
bundle exec jekyll serve
```

## Building the apps

The repos for apps hosted here are included as submodules but not served
directly because they do not include their build outputs. Instead, this repo
includes a Makefile which builds each app and copies the static files into this
repo.

This means that when an app is updated this repo can pull in the changes
by running the following:

```bash
make
```
