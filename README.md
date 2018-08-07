# git-coauthor
Simple multiple author support porcelain for git. Written in pure Bash.

## Installation
`brew install simoleone/tap/git-coauthor`

## Usage
```
git coauthor
    display current coauthors and this usage message

git coauthor <initials or name> ...
    set current co-authors to developers with matching initials or names

git coauthor --solo
    remove current co-authors and go solo

git coauthor --add "Jane Smith <jane@example.com>"
    add a new author to the database

git coauthor --ls
    list all authors in the database

git coauthor --rm <initials or name>
    remove author with matching initials or name from the database
```

## Why?
Github announced support for `Co-authored-by:` trailers for git commits in January 2018.
Pairing is a great way to get things done, and everyone gets credit in commit graphs as
well as in Github's UI by using this method. So basically, this is great.

There are a number of existing solutions to this problem out there, but all of them fall a little
bit short for one reason or another. The goals of this project are simple:

* No external dependencies (no node, ruby, etc). Should only depend on Bash and Git.
* Integration with git built-in porcelains. `git commit` should "just work".
* No munging of author (and do not interfere with gpg commit signing). Use only the Co-authored-by trailer.

## See Also
* [github help](https://help.github.com/articles/creating-a-commit-with-multiple-authors/) about multiple authors.
* [github blog](https://blog.github.com/2018-01-29-commit-together-with-co-authors/) announcing support for co-authored-by.

## Prior Art
* [chrisk/git-pair](https://github.com/chrisk/git-pair) (depends on ruby, munges author name and email)
* [findmypast-oss/git-mob#readme](https://github.com/findmypast-oss/git-mob#readme) (depends on node)
* [pivotal/git_scripts]()https://github.com/pivotal/git_scripts#git-pair) (depends on ruby, munges author name and email)
* [git-duet/git-duet](https://github.com/git-duet/git-duet) (mungest author name and email, does not integrate git commit)