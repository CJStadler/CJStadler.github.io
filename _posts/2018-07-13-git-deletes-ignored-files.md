---
layout: post
title:  "Git deleted my file!?"
date:   2018-04-26 12:28:50 -0400
categories: tools
---

I was working on a rails project recently and got an error that my local database configuration file could not be found. This was surprising because I had been running the app earlier in the day without issue, and I hadn't been working on anything that I expected to touch the config file. I didn't immediately believe the error message so I checked the filesystem but it was definitely not there. The file was pretty minimal, but I didn't want to reconstruct it if I didn't need to. I checked in "Trash" but the file wasn't there, and I couldn't restore it with git because it is ignored.

The file being ignored by git gave me a clue though, and I started forming a hypothesis.

I had just been using [git bisect](https://robots.thoughtbot.com/git-bisect) — maybe during that process I checked out a commit (let's call it `A`) in which the config file was tracked. At some point in the history there is a commit `B` which removed the config file from git. Going from `A` to `B` (or any later commit) would cause git to delete the file.

I made a little repo to demonstrate the issue: [https://github.com/CJStadler/git_deletes_ignored_files](https://github.com/CJStadler/git_deletes_ignored_files)

When ignoring a file that has already been committed you can use `git rm --cached` which removes the file from git's index without deleting the file from the filesystem. However, using `--cached` is not recorded in the commit log any differently from `git rm` (as far as I know), so in the future when you go from `A` to `B` git just sees a deletion.

While this behavior makes sense now it was very unexpected to me. The ability to checkout different versions of a code base without worrying about losing anything is very powerful (git bisect is awesome!), but the potential for ignored files to be deleted introduces risk to that. For me losing this config file was not a big deal, but it will be annoying if it happens regularly. And there are probably lots of people with more important and difficult to restore ignored files in their git repositories.

I don't see a way that git could handle this better though. Even if there was a way of recording in a commit "ignore this file but don't delete it" the content of the file could still have been changed. Fundamentally, if git does not track ignored files then it has no way of restoring them in the event of unavoidable conflicts. The only solution I see is to keep all files that should not be tracked by git out of the repository directory.
