# Branchy

Minimal Git branch status CLI (Elixir + Burrito). It helps you see which local branches are ahead / behind their upstream or the remote HEAD.

> [!NOTE]
> I had many more features intended for this project including an interactive element to delete / attempt sync branches. This is a version trying to make the most of how far I got with it!

## Download

```sh
curl -fsSL https://raw.githubusercontent.com/Harrywg/branchy/main/install.sh | sh
```

Supports macOS (Apple Silicon) and Linux (x86_64)

### Usage

Run inside any Git repository with a remote named `origin`.

```bash
branchy compare   # compare local branches vs remote HEAD (e.g. origin/main)
branchy contrast  # compare each local branch vs its own upstream (origin/<branch>)
branchy inspect   # like contrast, but hides in-sync branches — only shows what needs attention
```

### Output Legend

| Symbol            | Meaning                          |
| ----------------- | -------------------------------- |
| ✓ in sync         | Local and remote histories match |
| ↑ N               | Local branch is N commits ahead  |
| ↓ N               | Remote branch is N commits ahead |
| x / x no upstream | No tracked remote branch         |

## Local Dev

### Quick Start

```bash
git clone <your-fork-or-repo-url>
cd branchy
mix deps.get
mix branchy compare # or contrast
```

### Usage

Run inside a Git repository with a remote named `origin`.

```bash
mix branchy compare
mix branchy contrast
```

Standalone binary (macOS arm64, Linux x86_64):

```bash
mix branchy.release # currently not working, see RELEASE.md
mix branchy.install # installs to /usr/local/bin/branchy
branchy compare
```

Uninstall:

```bash
mix branchy.uninstall
```
