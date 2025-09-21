# Branchy

Minimal Git branch status CLI (Elixir + Burrito). It helps you see which local branches are ahead / behind their upstream or the remote HEAD.

> [!NOTE]
> I had many more features intended for this project including an interactive element to delete / attempt sync branches. This is a version trying to make the most of how far I got with it!

## Features

- `compare`: local branches vs remote HEAD (e.g. `origin/main`).
- `contrast`: each local branch vs its own upstream (`origin/<branch>`), marking missing upstreams.

## Quick Start

```bash
git clone <your-fork-or-repo-url>
cd branchy
mix deps.get
mix branchy compare   # or contrast / inspect
```

## Usage

Run inside a Git repository with a remote named `origin`.

```bash
mix branchy compare
mix branchy contrast
```

Standalone binary (macOS arm64 only for now):

```bash
mix branchy.release
mix branchy.install   # installs to /usr/local/bin/branchy
branchy compare
```

Uninstall:

```bash
mix branchy.uninstall
```

### Output Legend

| Symbol            | Meaning                          |
| ----------------- | -------------------------------- |
| ✓ in sync         | Local and remote histories match |
| ↑ N               | Local branch is N commits ahead  |
| ↓ N               | Remote branch is N commits ahead |
| x / x no upstream | No tracked remote branch         |

## Development

- Elixir ~> 1.18.
- Tests create temporary Git repos (no network).

Run tests:

```bash
mix test
```

## Release (Burrito)

```bash
mix branchy.release
ls burrito_out/  # contains branchy_macos
```
