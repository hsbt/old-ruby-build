# Build script for old versions of Ruby

This script is used to build old versions of Ruby for Apple Silicon. It is based on the MacPorts patch and some of the configure options and Homebrew packages.

Supported versions are as follows:

```
1.8.7-p374
1.9.3-p551
2.0.0-p648
2.1.10
2.2.10
2.3.8
2.4.10
2.5.9
2.6.10
```

Ruby 2.7+ is already supported by the official Ruby build.

## Usage

You can use the script to pass `X.Y` version and intallation path as arguments like this:

```sh
$ ruby ./build.rb 2.6 ~/.rbenv/versions
```

`all` instead of `X.Y` will build all supported versions.

```sh
$ ruby ./build.rb all ~/.rbenv/versions
```

## License

MIT
