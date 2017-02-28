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

#Build Custom Prompt
build_prompt(){
	#Print Working Directory
	#local get_pwd="${PWD/$HOME/~}"
	#Get git info
	local current_commit_hash="$(git rev-parse HEAD 2> /dev/null)"
	local is_git_repo="$reset_color\uf008"
	local current_branch="[\uf020 $(current_branch)]"
	local git_status="$(git status --porcelain 2> /dev/null)"

	local number_of_untracked_files="$(\grep -c "^??" <<< "${git_status}")"
	local git_untracked="[\uf02d $number_of_untracked_files]"

	local number_of_modified="$(\grep -c " M" <<< "${git_status}")"
	local git_modified="[\uf04d $number_of_modified]"

	local number_of_added="$(\grep -c "A " <<< "${git_status}")"
	local git_added="[\uf06b $number_of_added]"

	local number_of_deleted="$(\grep -c "D " <<< "${git_status}")"
	local git_deleted="[\uf0d0 $number_of_deleted]"

	local prompt=""

	ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]"
	ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"

	#if git repo - show relevant info in second line
	#Check that folder is a git repo
	if [[ -n $current_commit_hash ]]; then
		local is_a_git_repo=true
	fi

	if [[ $is_a_git_repo == true ]]; then
		prompt+="$fg[cyan]%m: $fg[yellow]${PWD/$HOME/~}\n"
		prompt+="$is_git_repo $(parse_git_dirty) $current_branch"
		#Modified files
		if [[ $number_of_modified -gt 0 ]]; then
			prompt+="$fg[cyan]$git_modified"
		fi
		#Untracked Files
		if [[ $number_of_untracked_files -gt 0 ]]; then
			prompt+="$fg[yellow]$git_untracked"
		fi
		#Added Files
		if [[ $number_of_added -gt 0 ]]; then
			prompt+="$fg[green]$git_added"
		fi
		#Deleted Files
		if [[ $number_of_deleted -gt 0 ]]; then
			prompt+="$fg[red]$git_deleted"
		fi
		prompt+="\n$fg[green]→ $reset_color"
	else
		prompt+="$fg[cyan]%m: $fg[yellow]${PWD/$HOME/~}\n"
		prompt+="$fg[green]→ $reset_color"
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
      while [ -e ~/.Trash/"$dst" ]; do
        dst="$dst "$(date +%H-%M-%S)
      done
      /bin/mv "$path" ~/.Trash/"$dst"
    fi
  done
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
touchsb(){
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

#Create a simpre http server with Python
server(){
  open "http://localhost:8000" && python -m SimpleHTTPServer 8000
}

#---ALIAS---#

#Set up some alias
alias hosts="sudo sublime /etc/hosts"
alias today="cal |grep -A7 -B7 --color=auto $(date +%d)"
alias mou="open -a Mou.app"