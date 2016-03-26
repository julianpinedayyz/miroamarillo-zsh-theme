#miroamarillo-zsh-theme
---
##Install Octicons on your mac


	brew install caskroom/cask/brew-cask
	brew tap "caskroom/fonts"
	brew cask install "font-octicons"
	
### Set Non-ASCII Font in iTerm 2

Go to Preferences > Profiles.  Select your profile and choose The **Text** tab on the right panel.  Change the Non-ASCII font option to **github-octicons**.

Close iTerm and open it again.  Test that your font is working:

	echo "\uf008"      #Should print the octiface
	
For reference on the icons and unicodes, go to [Github Octicons](https://octicons.github.com/).

