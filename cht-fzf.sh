#!/usr/bin/env bash

########################################
#[============== CHTFZF ==============]#
########################################

readonly THIS_CMD="${0##*/}"
readonly PRODUCTNAME="chtfzf"
readonly VERSION="0.1.0"
readonly LICENSE="GNU General Public License, version 3"
readonly WEBSITE="https://github.com/ConnerWill/cheat-fzf"
readonly AUTHOR="ConnerWill"
readonly DATE="2022-02-12"

#readonly KEYBINDINGS="\
#        Alt+d       Install Package(s)
#        PageDn      Scroll One Page Down
#        PageUp      Scroll One Page Up
#        Home        Top
#        End         Bottom
#        Tab         Select
#        Ctrl+d      Deselect All
#        Ctrl+l      Clear Query
#        Ctrl+v      Toggle Preview Window
#        Ctrl+/      Change Layout
#        Ctrl+h      Show Help
#        ?           Show Help
#        Ctrl+q      Exit
#        Esc         Exit"

function _version() {
	cat <<EOS
========================================================
    NAME    :    ${PRODUCTNAME}
    VERSION :    v${VERSION}
    DATE    :    ${DATE}
    LICENCE :    ${LICENSE}
    AUTHOR  :    ${AUTHOR}
    WEBSITE :    ${WEBSITE}/${AUTHOR}
========================================================
EOS
}

function _help() {
	cat <<EOS
    NAME
        cht-fzf
    DESCRIPTION
        Browse command line cheatsheets with fzf on the command line
    USAGE
        chtfzf  KEYWORDS...
        chtfzf  -h|--help
        chtfzf  -V|--version
========================================================
EOS
}
#$KEYBINDINGS

function chtfzf() {
   search_query="$1"
   [[ -z "$search_query" ]] && search_query=":list"
	for arg in "${@}"; do
		case "${arg}" in
		-h | --help)
			_help
			return 0
			;;
		-V | --version)
			_version
			return 0
			;;
		esac
	done
	search_cht "${*}" | _fzf
}

function search_cht() {
    search_cht_cmd="curl --silent https://cht.sh/$search_query"
    curl --silent "https://cht.sh/$search_query"
}

function _fzf() {
	fzf </dev/stdin \
        --ansi \
		--multi \
		--cycle \
		--keep-right \
		--header "${KEYBINDINGS}" \
		--header-first \
		--preview "${search_cht_cmd} {}" \
		--preview "curl --silent https://cht.sh/{}" \
}

function list_chts(){
  cht_list=$(curl --silent "https://cht.sh/$search_query")
  echo "$cht_list" | fzf --ansi
}

function cht(){
  echo "Searching for cheatsheets ..."
  curl --silent "https://cht.sh"/"$1" | bat --plain --language=Manpage
}

### Define Aliases
alias cheat-fzf="chtfzf"
alias cht-fzf="chtfzf"
