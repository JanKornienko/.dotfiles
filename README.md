# Dotfiles

## Apps

### [Homebrew](https://brew.sh)

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### [Oh My Zsh](https://ohmyz.sh)

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -s ~/.dotfiles/.zshrc ~/.zshrc
```

#### Theme

```sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
p10k configure
```

#### Plugins

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
```

### Other
```sh
brew install --cask iterm2
brew install --cask brave-browser
brew install --cask postico
brew install --cask postman
brew install --cask clickup
brew install --cask slack
brew install --cask signal
brew install --cask spotify
brew install --cask messenger
brew install --cask discord
brew install --cask figma
brew install --cask notion
brew install --cask onyx
brew install --cask microsoft-teams
brew install --cask microsoft-word
brew install --cask microsoft-excel
brew install --cask microsoft-powerpoint
brew install --cask microsoft-outlook
brew install --cask aldente
brew install --cask logi-options-plus
brew install --cask rectangle
brew install --cask cheatsheet
brew install --cask vlc
brew install --cask hiddenbar
brew install --cask maccy
brew install node@20
brew install yarn
```

- [HiCoffee - Caffeine Tracker](https://apps.apple.com/cz/app/hicoffee-caffeine-tracker/id1507361706)
- [Revolut - Mobile Finance](https://apps.apple.com/cz/app/revolut-mobile-finance/id932493382)
- [HBO Max: Stream TV & Movies](https://apps.apple.com/cz/app/hbo-max-stream-tv-movies/id971265422)
- [AdGuard for Safari](https://apps.apple.com/cz/app/adguard-for-safari/id1440147259?mt=12)
- [ColorSlurp](https://apps.apple.com/cz/app/colorslurp/id1287239339)

### PostgreSQL

```sh
brew install postgresql@16
brew services restart postgresql
createuser -s <db_user>
createdb <db_name>
psql postgres
```

```
\li
\du
\q
```

### tmux

```sh
brew install tmux
ln -s ~/.dotfiles/.tmux.conf ~/.tmux.conf
```

### Neovim

```sh
brew install neovim
mkdir ~/.config/nvim
ln -s ~/.dotfiles/.config/nvim ~/.config/nvim
```

#### Plugins

- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
