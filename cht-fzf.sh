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
readonly DATE="2022-02-10"




function _version() {
	cat <<EOS
#${THIS_CMD} v${VERSION}
#released under the ${LICENSE} license.
#    Author: ${AUTHOR} (${GITHUB_URL}/${AUTHOR})
EOS
}

function _help() {
	cat <<EOS
gh fzrepo -- GitHub repository browser with fzf

USAGE
    gh fzrepo KEYWORDS...
    gh fzrepo -h|--help
    gh fzrepo -V|--version
EOS
}


#chtfzf "${@}"
#exit "${?}"



function chtfzf() {

   search_query="$1"
   [[ -z "$search_query" ]] && search_query=":list"

#		_help
#		_err "Must require arguments..."
#		return 1

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

#function _err() {
#	printf "[\e[31m ERR \e[m] %s\n" "${*}"
#}

#function _encode() {
#	echo -n "${*}" | od -tx1 -An | tr ' ' % | tr -d \\n
#}

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
#		--bind "enter:execute(search_cht {})"
#		--preview "search_cht" \
#		--bind "ctrl-d:execute(gh repo clone {})" \
#		--bind "ctrl-o:execute(gh repo view {} -w &>/dev/null &)" \
#		--bind "ctrl-n:change-preview-window(right,80%|up,65%,border-horizontal|hidden|right)" \
#		--bind "esc:accept-non-empty"
}




function check_cht_input(){


}


function list_chts(){

  cht_list=$(curl --silent "https://cht.sh/$search_query")
  echo "$cht_list" | fzf --ansi


}



function cht(){

  echo "Searching for cheatsheets ..."
  curl --silent "https://cht.sh"/"$1" | bat --plain --language=Manpage

}







#check_cht_input "$1"
#list_chts
