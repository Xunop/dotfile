# dotfile
This Git repository stores the configuration files for my personal computer.

Referenced from this article: [How to Store Dotfiles - A Bare Git Repository | Atlassian Git Tutorial](https://www.atlassian.com/git/tutorials/dotfiles)

## Usage

### Install dotfile from repo

1. Create an alias for the Git repository using the config command:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

2. Add .cfg folder to .gitignore

```bash
echo ".cfg" >> .gitignore
```

3. Clone repo:

```bash
git clone --bare <git-repo-url> $HOME/.cfg
```

4. Checkout the actual content from the bare repository to your $HOME:

```bash
config checkout
```

if you fail with a message like:

```bash
error: The following untracked working tree files would be overwritten by checkout:
    .bashrc
    .gitignore
Please move or remove them before you can switch branches.
Aborting
```

This is because your $HOME folder might already have some stock configuration files which would be overwritten by Git. I alaways delete those files.

According to that article you can save these file like this:

```bash
mkdir -p .config-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .config-backup/{}
```

rerun `config chekout`

Don't forget to enter the following command, this command tells Git not to display status informantions for untracked files (i.e., files that are not under version control). the `--local` parameter indicates that this configuration is only valid for the current repository.

```bash
config config --local status.showUntrackedFiles no
```

### Tracking your configurations in a Git repository

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

### AGS

```console
gtksourceview3
brightnessctl
dart-sass
ddcutil(mod: i2c-dev)
gnome-bluetooth-3.0
ttf-readex-pro
ttf-jetbrains-mono-nerd
ttf-material-symbols-variable-git
ttf-space-mono-nerd
ttf-rubik-vf
ttf-gabarito-git
```
