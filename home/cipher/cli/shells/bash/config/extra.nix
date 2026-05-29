''
  [[ -f ~/.profile ]] && . ~/.profile
  iatest=$(expr index "$-" i)

  # Ignore case on auto-completion
  # Note: bind used instead of sticking these in .inputrc
  if [[ $iatest -gt 0 ]]; then bind "set completion-ignore-case on"; fi

  # Show auto-completion list automatically, without double tab
  if [[ $iatest -gt 0 ]]; then bind "set show-all-if-ambiguous On"; fi

  # Disable the bell
  if [[ $iatest -gt 0 ]]; then bind "set bell-style visible"; fi


  # Searches for text in all files in the current folder
  ftext ()
  {
  	# -i case-insensitive
  	# -I ignore binary files
  	# -H causes filename to be printed
  	# -r recursive search
  	# -n causes line number to be printed
  	# optional: -F treat search term as a literal, not a regular expression
  	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
  	grep -iIHrn --color=always "$1" . | less -r
  }

  # GitHub Additions
  gcom() {
  	git add .
  	git commit -m "$1"
  	}
  lazyg() {
  	git add .
  	git commit -m "$1"
  	git push
  }

  # For some reason, rot13 pops up everywhere
  rot13 () {
  	if [ $# -eq 0 ]; then
  		tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
  	else
  		echo $* | tr '[a-m][n-z][A-M][N-Z]' '[n-z][a-m][N-Z][A-M]'
  	fi
  }
''
