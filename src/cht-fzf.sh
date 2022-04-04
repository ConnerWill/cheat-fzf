#!/usr/bin/env bash

########################################
#[============== CHTFZF ==============]#
########################################

# THIS_CMD="${0##*/}"
# PRODUCTNAME="chtfzf"
# VERSION="0.1.1"
# LICENSE="GNU General Public License, version 3"
# WEBSITE="https://github.com/ConnerWill/cheat-fzf"
# AUTHOR="ConnerWill"
# DATE="2022-04-02"

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
    --no-mouse \
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








function _fzf() {
    fzf </dev/stdin \
            --query "$SearchInput" \
            --print-query \
            --select-1 \
            --exit-0 \
                --extended \
            --tac \
            --no-sort \
            --keep-right \
                --header "${KEYBINDINGS}" \
                --header-first \
                --header-lines=0 \
                    --multi \
                    --marker="✔ " \
                    --prompt="> " \
                    --pointer="[>" \
                --info=inline \
                --height=100% \
            --ansi  \
            --color='16,bg:#1A1A1A,bg+:#333333,info:#999999,border:#999999,spinner:#F5F5F5'  \
            --color='hl+:#BD2C00,hl:#4078C0,fg:#C1C1C1,fg+:#FFFFFF,header:#666666,preview-bg:#333333'  \
            --color='header:#666666,query:#4183c4,pointer:#BD2C00,marker:#6CC644,prompt:#F5F5F5' \
            --color='gutter:#141414' \
                --layout 'default' \
                --preview "$detailedPreview {}" \
                --preview-window "right:65%" \
                    --margin 0%,0% \
                    --padding 3%,2% \
                --border "rounded" \
                --delimiter=" " \
                    --tabstop=4 \
                    --filepath-word \
                --scroll-off=0  \
                --hscroll-off=100  \
                    --expect=ctrl-c,esc \
            --bind "alt-d:execute: echo 'Installing: {+}' && $installPackage {+}" \
            --bind 'pgdn:page-down' \
            --bind 'pgup:page-up' \
            --bind 'home:last'  \
            --bind 'end:first'  \
        --bind 'ctrl-/:change-preview-window(up,border-rounded|up,40%,border-rounded|left,border-rounded|left,border-rounded,40%|down,border-rounded|down,40%,border-rounded|down,10%,border-rounded|hidden|right,40%,border-rounded|right,70%,border-rounded|right,90%,border-r
ounded)' \
        --bind 'ctrl-v:toggle-preview'  \
        --bind "?:preview: less $SHORTKEYBINDINGS"  \
        --bind "f1:preview: echo $SHORTKEYBINDINGS"  \
        --bind "ctrl-h:preview: echo $SHORTKEYBINDINGS"  \
            --bind 'tab:select'  \
            --bind 'shift-tab:deselect' \
            --bind 'ctrl-d:deselect-all'  \
            --bind 'alt-left:kill-word' \
            --bind 'alt-bspace:clear-query'  \
            --bind 'ctrl-l:clear-query'  \
        --bind 'ctrl-q:print-query' \
        --bind "esc:accept-non-empty"
}
_main "${@}"
exit "${?}"
