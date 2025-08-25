## Core functionality

### Branchy Inspect command

- Refine what is a branch that needs action

### Icons

- Display 🔨 next to current active branch
- Display 🚩 next to head branch

### Interactivity feature set

- keyboard navigation of displayed branches, show actions on highglighted branch
- Delete action -> prompt y/n, then delete local branch if y
- Sync action -> try to merge remote in to local, if conflict then abort

### Improvements

- Dynamically get the upstream path instead of assuming origin/
- Better error messages instead of just 128 exit code

## Bugs
