# Homebrew Repro Tools

A Homebrew tap for tools used to compare containers and reproduce builds.

## Formulas

- `container-diff`: builds Google's container-diff from source.
- `container-diffoscope`: installs the container-diffoscope CLI with diffoscope and Python dependencies.
- `reproductionframework`: installs the Reproduction Framework CLI from platform-specific releases.

## Install and test

For example, to audit, install, and test `container-diffoscope`:

```sh
brew audit --strict --new kkignasiak98/repro-tools/container-diffoscope
brew install --build-from-source kkignasiak98/repro-tools/container-diffoscope
brew test kkignasiak98/repro-tools/container-diffoscope
```

See [commands.md](commands.md) for additional fetch and verification commands.