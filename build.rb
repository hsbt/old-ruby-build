#/usr/bin/env ruby
require 'json'

class Downloader
  require "open-uri"

  def self.download(files)
    files.each do |file|
      URI.open(file) do |f|
        File.write("build/" + File.basename(file), f.read)
      end
    end
  end
end

class Builder
  CONFIG_FILES = %w[
    https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.guess
    https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.sub
  ]

  def self.load_package_info
    package_file = File.join(File.dirname(__FILE__), 'package.json')
    package_data = JSON.parse(File.read(package_file))
    
    # Convert string keys to symbols for before/after keys
    packages = {}
    package_data['packages'].each do |version, info|
      packages[version] = {
        before: info['before'],
        after: info['after'],
        full_version: info['full_version']
      }
    end
    
    packages
  end
  
  PACKAGES = load_package_info

  def self.build(version, prefix, requested_version=nil)
    system("brew install rbenv/tap/openssl@1.0 openssl@1.1")
    system("brew uninstall bison")
    system("brew unlink openssl@3")

    require "fileutils"
    FileUtils.mkdir_p("build")

    Downloader.download(CONFIG_FILES)
    [:before, :after].each do |key|
      Downloader.download(PACKAGES[version][key])
    end

    # Display warning if a different version than requested will be installed
    if requested_version && requested_version != PACKAGES[version][:full_version]
      puts "WARNING: You requested Ruby #{requested_version}, but installing #{PACKAGES[version][:full_version]} instead."
    end

    Dir.chdir("build") do
      system("tar -xf ruby-#{PACKAGES[version][:full_version]}.tar.*")
      Dir.chdir("ruby-#{PACKAGES[version][:full_version]}") do
        config_target = version < "1.9" ? "." : "tool/"
        CONFIG_FILES.each do |file|
          FileUtils.cp("../#{File.basename(file)}", config_target)
        end
        PACKAGES[version][:before][1..-1].each do |patch|
          system("patch -p0 < ../#{File.basename(patch)}")
        end
        openssl_version = version <= "2.3" ? "1.0" : "1.1"
        system("./configure CFLAGS='-Wno-error=implicit-int -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion -Wno-error=implicit-function-declaration' --with-openssl-dir=$(brew --prefix openssl@#{openssl_version}) --with-gdbm-dir=$(brew --prefix gdbm) --with-readline-dir=$(brew --prefix readline) --with-gmp-dir=$(brew --prefix gmp) --with-yaml-dir=$(brew --prefix libyaml) --disable-install-doc --without-tk --with-arch=arm64 --enable-shared --prefix=#{prefix}/#{PACKAGES[version][:full_version]}")
        PACKAGES[version][:after].each do |patch|
          system("patch -p0 < ../#{File.basename(patch)}")
        end
        system("make -j$(sysctl -n hw.logicalcpu)")
        system("make install")
      end
    end

    FileUtils.rm_rf("build")

    system("brew link openssl@3")
    system("brew install bison")
  end
end

abort if (ARGV[0].nil? && ARGV[1].nil?)
requested_version = ARGV[0]
prefix = ARGV[1]

if requested_version == "all"
  Builder::PACKAGES.keys.each do |version|
    Builder.build(version, prefix)
  end
else
  # Extract major.minor version from the requested version
  version_match = requested_version.match(/^(\d+\.\d+)/)
  if version_match
    version_key = version_match[1]
    if Builder::PACKAGES.key?(version_key)
      Builder.build(version_key, prefix, requested_version)
    else
      puts "Unsupported Ruby version: #{requested_version}"
      puts "Supported major.minor versions: #{Builder::PACKAGES.keys.join(', ')}"
      abort
    end
  else
    puts "Invalid Ruby version format: #{requested_version}"
    puts "Please specify a version in the format X.Y or X.Y.Z"
    abort
  end
end
