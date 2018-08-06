#!/bin/bash

readonly COMMIT_TEMPLATE="${HOME}/.git_coauthor_commit_template"

function err() {
  echo "$@" >&2
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

  [[ "$#" -lt 2 ]] && return 1

  commit_template="\n"
  for i in "$@"; do
    local full_author
    full_author="$(author_match "$i")"
    [[ $? -eq 0 ]] || { err "could not set up pair" && return 1; }
    commit_template="${commit_template}\nCo-authored-by: ${full_author}"
  done

  echo -e "${commit_template}" > "${COMMIT_TEMPLATE}"
  git config --global commit.template "${COMMIT_TEMPLATE}"
  echo "Co-authors set"
  echo -e "${commit_template}"
}

function solo() {
  echo "" > "${COMMIT_TEMPLATE}"
  git config --global --unset commit.template
}

function main() {
  local -r cmd="$1" ; shift

  case "${cmd}" in
  add)
    exec git config --global --add coauthor.author "$*"
  ;;
  ls)
    author_list
  ;;
  rm)
    exec git config --global --unset coauthor.author "$*"
  ;;
  pair|mob|duet)
    setup_pair "$@"
  ;;
  solo)
    solo
  ;;
  *)
    # help / usage
    echo "usage: git coauthor <cmd>"
    exit 1
  ;;
  esac
}

main "$@"