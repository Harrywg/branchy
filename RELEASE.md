# Release guide

Steps / reference for manual release, this is here as I struggled to consistently clear the release / build cache consistently. There may be a better way, but here I'm having to make a release without environment vars, run a command on that release, then run a new release with env vars.

Use `mix branchy.release` to use mix alias.

> [!NOTE]  
> This was the only way I could find to consistently clear burrito output cache and re-release, there may be a better way but this works for now. I've found some inconsistency with the behaviour of mix release with the ---overwrite flag, if this occurs try to run without.

## Steps:

```
rm -rf ./burrito_out && rm -rf ./\_build

mix clean

mix compile

mix release --overwrite

./burrito_out/branchy_macos cache_clear

BURRITO_LOG_LEVEL=silent BURRITO_TARGET=macos MIX_ENV=prod mix release --overwrite
```
