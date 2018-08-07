# git-coauthor
Simple and dependency-free coauthor support porcelain for git.

## Installation
brew install simoleone/tap/git-coauthor

## Usage
Add your friends and colleagues, and probably yourself.
```bash
git coauthor add "Cool Person <me@example.com>"
git coauthor add "Linux Penguin <penguin@example.com>"
git coauthor add "Jane Smith <jane@example.com>"
```

Set up a pair or mob. You can use initials or any matching substring (first match wins).
```bash
git coauthor pair cp js
git coauthor pair cool smith
```

Commit as usual. The commit message will be pre-populated with the selected authors. 
```bash
git commit
```

Done pairing? Easy.
```bash
git coauthor solo
```

## Why?
Github announced support in January 2018. Pairing is a great way to get things done, and
everyone gets credit in commit graphs as well as in Github's UI.

### See Also
* [github help](https://help.github.com/articles/creating-a-commit-with-multiple-authors/)
* [github blog](https://blog.github.com/2018-01-29-commit-together-with-co-authors/)