#
# Miroamarillo ZSH Theme
#
# Author: Julian Pineda, miroamarillo.com
# License: MIT
# https://github.com/miroamarillo/miroamarillo-zsh-theme
# Credits:
# Denys Dovhan - https://github.com/denysdovhan/spaceship-zsh-theme
# Arialdo Martini - https://github.com/arialdomartini/oh-my-git

#---FUNCTIONS---#

# Create Octicons icons variables
# Escape the variables with %{ iconCode %}
local octoface="%{\uf008%}"
local branch="%{\uf020%}"
local alert="%{\uf02d%}"
local diff="%{\uf04d%}"
local diff_added="%{\uf06b%}"
local trash_can="%{\uf0d0%}"
local remote_behind="%{\uf00b%}"
local remote_ahead="%{\uf00c%}"
local stashes="%{\uf0c4%}"
local terminal="%{\uf0c8%}"
local arrow="%{\uf06e%}"

#colors - copy and paste "spectrum_ls" to see the complete pallete of colors
#Ref escaping colors https://stackoverflow.com/questions/13546672/custom-oh-my-zsh-theme-long-prompts-disappear-cut-off/14179542#14179542
#Ref escaping colors https://stackoverflow.com/questions/7957435/zsh-auto-complete-screws-up-command-name/10644062#10644062
#Ref spectrum_ls https://gabri.me/blog/custom-colors-in-your-zsh-prompt/
#Ref spectrum_ls https://github.com/robbyrussell/oh-my-zsh/issues/3964

yellow="%{$fg[yellow]%}"
orange="%{$FG[208]%}"
red="%{$fg[red]%}"
magenta="%{$fg[magenta]%}"
violet="%{$fg_bold[magenta]%}"
blue="%{$fg[blue]%}"
cyan="%{$FG[045]%}"
green="%{$fg[green]%}"
white="%{$fg[white]%}"
pink="%{$FG[013]%}"
octoface_color="%{$FG[252]%}"

# get the date
dateP() {
	date '+%d-%m-%y '
}
#get the time
timeP() {
	date '+%H:%M:%S '
}

# Status of last command (for prompt)
local stat="%(?.$green.$red)"

#Build Custom Prompt
build_prompt(){
	#Print Working Directory
	#local get_pwd="${PWD/$HOME/~}"

	#Get git info
	local current_commit_hash="$(git rev-parse HEAD 2> /dev/null)"
	local is_git_repo="$reset_color$octoface_color$octoface"
	local current_branch="[$branch $(current_branch)]"
	local git_status="$(git status --porcelain 2> /dev/null)"

	local upstream="$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)"
	if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then
		local has_upstream=true
	fi
	#Untracked files
	local number_of_untracked_files="$(\grep -c "^??" <<< "${git_status}")"
	local git_untracked="[$alert $number_of_untracked_files]"
	#Modified but not staged
	local number_of_modified="$(\grep -c " M" <<< "${git_status}")"
	local git_modified="[$diff $number_of_modified]"

	local number_of_added="$(\grep -c "A " <<< "${git_status}")"
	local git_added="[$diff_added $number_of_added]"
	#Deleted Files
	local number_of_deleted="$(\grep -c "D " <<< "${git_status}")"
	local git_deleted="[$trash_can $number_of_deleted]"

	if [[ $has_upstream == true ]]; then
		local commits_diff=$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)
		local commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
		local commits_behind=$(\grep -c "^>" <<< "$commits_diff")
	fi

	local git_commits_behind="[$remote_behind -$commits_behind]"
	local git_commits_ahead="[$remote_ahead +$commits_ahead]"

	#Number of Stashes
	local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
	local git_stashes="$stashes"

	local prompt=""

	ZSH_THEME_GIT_PROMPT_DIRTY="$red"
	ZSH_THEME_GIT_PROMPT_CLEAN="$green"

	#if git repo - show relevant info in second line
	#Check that folder is a git repo
	if [[ -n $current_commit_hash ]]; then
		local is_a_git_repo=true
	fi

	if [[ $is_a_git_repo == true ]]; then
		prompt+="$orange$(dateP)$cyan$terminal  $yellow${PWD/$HOME/~}\n"
		prompt+="$is_git_repo $(parse_git_dirty) $current_branch"
		#Stashes
		if [[ $number_of_stashes -gt 0 ]]; then
			prompt+="$pink$git_stashes "
		fi
		#Modified files
		if [[ $number_of_modified -gt 0 ]]; then
			prompt+="$blue$git_modified"
		fi
		#Untracked Files
		if [[ $number_of_untracked_files -gt 0 ]]; then
			prompt+="$yellow$git_untracked"
		fi
		#Added Files
		if [[ $number_of_added -gt 0 ]]; then
			prompt+="$green$git_added"
		fi
		#Deleted Files
		if [[ $number_of_deleted -gt 0 ]]; then
			prompt+="$red$git_deleted"
		fi
		#Commits Behind remote
		if [[ $commits_behind -gt 0 ]]; then
			prompt+="$red$git_commits_behind"
		fi
		#Commits Ahead remote
		if [[ $commits_ahead -gt 0 ]]; then
			if [[ $commits_behind == 0 && $number_of_deleted == 0 && $number_of_added == 0 && $number_of_untracked_files == 0 && $number_of_modified == 0 ]]; then
				prompt+="$green$git_commits_ahead"
			else
				prompt+="$red$git_commits_ahead"
			fi
		fi
		prompt+="\n$orange$(timeP)$stat$arrow $reset_color "
	else
		prompt+="$orange$(dateP)$cyan$terminal  $yellow${PWD/$HOME/~}\n"
		prompt+="$orange$(timeP)$stat$arrow $reset_color "
	fi

	#Print Prompt
	echo $prompt
}
#Execute Build Custom Prompt
PROMPT='$(build_prompt)'

# Makes a search on google. Use: google "search term"
# Will open a new tab in the default browser (google) with the term
google(){
    search=""
    echo "Googling: $@"
    for term in $@; do
        search="$search%20$term"
    done
    open "http://www.google.com/search?q=$search"
}

# Use trash command to send files to the trash bin istead of using rm
trash(){
  local path
  for path in "$@"; do
    # ignore any arguments
    if [[ "$path" = -* ]]; then :
    else
      local dst=${path##*/}
      # append the time if necessary
    #   while [ -e ~/.Trash/"$dst" ]; do
    #     dst="$dst "$(date +%H-%M-%S)
    #   done
      /bin/mv "$path" ~/.Trash/"$dst"
	  echo "$fg[green]$@ $fg[yellow]was sent to the trash $fg[green]\uf0d0"
    fi
  done
}

# Move funtion with log
move() {
	/bin/mv $1 $2
	echo "$fg[green]$1 $fg[yellow]has been moved to $fg[green]$2"
}
#Pretty node version log
nodeV(){
	node_version=$(node -v 2>/dev/null)
	npm_version=$(npm -v 2>/dev/null)
	echo "$fg[green] "⬢ node" $node_version $fg[magenta] \uf0c4 "npm" "v"$npm_version"
}

#Make a directory and cd on it
mkcd(){
	mkdir -p "$@"  && cd $_
}

#Create a file and open in Sublime
tsb(){
	touch "$@" && sublime "$@"
}

#Log latest "n" changes from a git repo
gitLog(){
  echo "Here are your latest $@ commits, son!"
  git --no-pager log -n "$@" --graph --pretty=format:'%Cred%h%Creset: %s' --abbrev-commit
}

#Show wifi password after been logged in once
wifiPass(){
  security find-generic-password -D "AirPort network password" -a "$@" -g
}

#Create a simple http server with Python
pyserver(){
  open "http://localhost:8000" && python -m SimpleHTTPServer 8000
}
# Create php server on current folder
phpserver(){
  open "http://localhost:8088" && php -S 127.0.0.1:8088
}

# Show my ip
myip(){
    ifconfig lo0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "lo0       : " $2}'
	ifconfig en0 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en0 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en0 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en0 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet ' | sed -e 's/:/ /' | awk '{print "en1 (IPv4): " $2 " " $3 " " $4 " " $5 " " $6}'
	ifconfig en1 | grep 'inet6 ' | sed -e 's/ / /' | awk '{print "en1 (IPv6): " $2 " " $3 " " $4 " " $5 " " $6}'
}

#Open file in vscode from terminal
code(){
	VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;
}


#Create a file and open in Visual Studio
tcode(){
	touch "$@" && code "$@"
}
# Create a function to scafold an angular app

# list the ports in use that match localhost and listen
ports(){
	lsof -i@localhost -sTCP:LISTEN | col 1 2 3 5 8 9 10 | column -t | GREP_COLOR='01;36' egrep --color=always 'COMMAND|PID|USER|TYPE|NODE|NAME|$'
}
col() { awk '{print $'$(echo $* | sed -e 's/ /,$/g')'}'; }
#---ALIAS---#

#Set up some alias
alias hosts="sudo sublime /etc/hosts"
alias today="cal |grep -A7 -B7 --color=auto $(date +%d)"
alias mtheme="~/Sites/GitHub/miroamarillo-zsh-theme/themes && code miroamarillo.zsh-theme"
alias sameTab="open . -a iTerm"
alias codeFolder="open -a Viopen -a Visual\ Studio\ Code ."
alias las=" ls -la"
alias chrome="open -a 'Google Chrome'"
alias firef="open -a 'FirefoxLatestStable'"
#alias to register work an personal keys
alias keyWork="ssh-add -D && ssh-add -K ~/.ssh/jupinedaDTdot"
alias keyPersonal="ssh-add -D && ssh-add -K ~/.ssh/id_rsa"