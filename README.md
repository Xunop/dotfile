# dotfile
This Git repository stores the configuration files for my personal computer.
Referenced from this article: [How to Store Dotfiles - A Bare Git Repository | Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/dotfiles)

## Usage
1. Initialize the Git repository:

```bash
git init --bare $HOME/.cfg
```

2. Create an alias for the Git repository using the config command:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

You can use this command to add an alias to the user's .bashrc/.zshrc file so that it can be used every time you start the terminal:

```bash
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
```

3. Configure Git to ignore untracked files:

```bash
config config --local status.showUntrackedFiles no
```

4. Add your configuration files to the Git repository:

```bash
config add <file>
config commit -m "<commit message>"
```

5. Push your changes to a remote repository:

```bash
config push <remote> <branch>
```

6. Clone repo:
```bash
git clone --bare <git-repo-url> $HOME/.cfg
```
