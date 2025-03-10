# Build script for old versions of Ruby

A build script for old Ruby versions for macOS (ARM64).

## Background

Ruby versions released before Apple Silicon (M1/M2) processors do not support ARM64 architecture out of the box. This makes it difficult to build and run older Ruby versions on modern Apple Silicon Macs. This script provides necessary patches and configurations to build these older Ruby versions on Apple Silicon, enabling developers to run legacy Ruby applications or test their code across different Ruby versions on modern macOS hardware.

## Usage

```
$ ruby build.rb <version> <prefix>
```

Example:

```
$ ruby build.rb 2.7 /opt/rubies
```

This will build Ruby 2.7.8 and install it to `/opt/rubies/2.7.8`.

## Configuration

Ruby version information and source URLs are stored in `package.json`. The file contains a list of Ruby versions and their corresponding source code and patch URLs.

Each version entry in `package.json` has the following structure:

```json
"2.7": {
  "before": [
    "https://cache.ruby-lang.org/pub/ruby/2.7/ruby-2.7.8.tar.xz",
    "https://raw.githubusercontent.com/macports/macports-ports/refs/heads/master/lang/ruby27/files/patch-sources.diff"
  ],
  "after": [
    "https://raw.githubusercontent.com/macports/macports-ports/refs/heads/master/lang/ruby27/files/patch-generated.diff"
  ],
  "full_version": "2.7.8"
}
```

- `before`: Array of URLs for the Ruby source tarball and patches to apply before building
- `after`: Array of URLs for patches to apply after configuration
- `full_version`: The full version number including patch level

## Supported Versions

The following Ruby versions are available for installation:

| Major Version | Full Version |
|--------------|--------------|
| 3.0 | 3.0.7 |
| 2.7 | 2.7.8 |
| 2.6 | 2.6.10 |
| 2.5 | 2.5.9 |
| 2.4 | 2.4.10 |
| 2.3 | 2.3.8 |
| 2.2 | 2.2.10 |
| 2.1 | 2.1.10 |
| 2.0 | 2.0.0-p648 |
| 1.9 | 1.9.3-p551 |
| 1.8 | 1.8.7-p374 |

To build all supported versions:

```
$ ruby build.rb all /opt/rubies
```

## License

MIT
