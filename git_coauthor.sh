#!/bin/bash
#
# A git porcelain to add co-authored-by trailers to git commits
# and manage a database of authors.
#
# I live at https://github.com/simoleone/git-coauthor

readonly COMMIT_TEMPLATE="${HOME}/.git_coauthor_commit_template"

function err() {
  echo "$@" >&2
}

function author_create() {
  local -r author="$1"
  git config --global --add coauthor.author "${author}"
}

function author_delete() {
  local -r query="$1"

  local full_author
  full_author="$(author_match "${query}")"
  [[ $? -eq 0 ]] || { err "no authors deleted" && return 1; }
  git config --global --unset coauthor.author "${full_author}"
}

function author_list() {
  git config --global --get-all coauthor.author
}

function author_match() {
  local -r query="$1"
  local match
  local pattern


  if [[ -z "${query}" ]]; then
    # empty query no good
    return 1
  elif [[ "${#query}" -eq 2 ]]; then
    # match on author's initials
    local -r first_initial="${query:0:1}"
    local -r second_initial="${query:1:1}"
    pattern="^${first_initial}.* ${second_initial}"
  else
    # just try to match something
    # preference to lines that start with the query
    pattern="^${query}|${query}"
  fi

  match="$(author_list | grep -i -m 1 -E "${pattern}")"
  [[ $? -eq 0 ]] || { err "no author matched: ${query}" && return 1; }
  echo "${match}"
  return 0
}

function setup_pair() {
  local commit_template

  [[ "$#" -lt 2 ]] && { err "need at least two authors to pair!" && return 1; }

  commit_template=""
  for i in "$@"; do
    local full_author
    full_author="$(author_match "$i")"
    [[ $? -eq 0 ]] || { err "could not set up pair" && return 1; }
    commit_template="${commit_template}\nCo-authored-by: ${full_author}"
  done

  commit_template="$(echo -e "${commit_template}" | sort)"
  echo -e "\n${commit_template}" > "${COMMIT_TEMPLATE}"
  git config --global commit.template "${COMMIT_TEMPLATE}"

  display_current
}

function solo() {
  echo "" > "${COMMIT_TEMPLATE}"
  git config --global --unset commit.template
  echo "now committing solo"
}

function display_current() {
  local -r authors="$(cat "${COMMIT_TEMPLATE}" | grep 'Co-authored-by:' | cut -d':' -f2)"
  echo "CURRENT CO-AUTHORS"
  if [[ -z "${authors}" ]]; then
    echo "You're committing solo!"
  else
    echo "${authors}"
  fi
}

function usage(){
  cat <<EOF
Usage
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

EOF
}

function main() {
  local -r cmd="$1"

  case "${cmd}" in
  --add)
    shift
    author_create "$*"
  ;;
  --ls)
    author_list
  ;;
  --rm)
    shift
    author_delete "$*"
  ;;
  --help|-h)
    usage
    exit 1
  ;;
  --solo)
    solo
  ;;
  '')
    usage
    display_current
  ;;
  *)
    setup_pair "$@"
  ;;
  esac
}

main "$@"