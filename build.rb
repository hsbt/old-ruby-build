#/usr/bin/env ruby

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

config_files = %w[
  https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.guess
  https://raw.githubusercontent.com/gcc-mirror/gcc/master/config.sub
]

packages = {
  "2.6" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.6/ruby-2.6.10.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby26/files/patch-sources.diff
    ],
    after: %w[
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby26/files/patch-generated.diff
    ],
    full_version: "2.6.10"
  },
  "2.5" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.9.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby25/files/patch-tiger.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby25/files/patch-osversions.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby25/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby25/files/patch-test-fiddle-helper.rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby25/files/patch-ext-openssl-extconf.rb.diff
    ],
    after: %w[
    ],
    full_version: "2.5.9"
  },
  "2.4" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.4/ruby-2.4.10.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby24/files/patch-configure.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby24/files/patch-tiger.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby24/files/patch-osversions.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby24/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby24/files/patch-ext-openssl-extconf.rb.diff
    ],
    after: %w[
    ],
    full_version: "2.4.10"
  },
  "2.3" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.8.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby23/files/patch-ext_openssl_ossl.h.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby23/files/patch-tiger.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby23/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby23/files/patch-openssl_pkgconfig.diff
    ],
    after: %w[
    ],
    full_version: "2.3.8"
  },
  "2.2" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.10.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby22/files/patch-ext_openssl_ossl.h.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby22/files/patch-internal.h.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby22/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby22/files/patch-openssl_pkgconfig.diff
    ],
    after: %w[
    ],
    full_version: "2.2.10"
  },
  "2.1" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.10.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby21/files/patch-ext_openssl_ossl.h.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby21/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby21/files/patch-openssl_pkgconfig.diff
    ],
    after: %w[
    ],
    full_version: "2.1.10"
  },
  "2.0" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p648.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby20/files/patch-ext-tk-extconf.rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby20/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby20/files/implicit.patch
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby20/files/patch-openssl_pkgconfig.diff
    ],
    after: %w[
    ],
    full_version: "2.0.0-p648"
  },
  "1.9" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p551.tar.xz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/patch-lib-rubygems-specification.rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/patch-configure_cxx11.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/patch-ext-openssl-openssl_missing.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/patch-ext_openssl_ossl_x509ext.c.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/implicit.patch
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby19/files/patch-openssl_pkgconfig.diff
    ],
    after: %w[
    ],
    full_version: "1.9.3-p551"
  },
  "1.8" => {
    before: %w[
      https://cache.ruby-lang.org/pub/ruby/1.8/ruby-1.8.7-p374.tar.gz
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-vendordir.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-bug3604.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-bug19050.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-bug15528.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-c99.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-lib-drb-ssl.rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-Makefile.in
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-numeric.c.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-configure.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-ext-tk-extconf.rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-ext_openssl_extconf_rb.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-ext_openssl_ossl_ssl_c.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/patch-ext_openssl_ossl.h.diff
      https://raw.githubusercontent.com/macports/macports-ports/master/lang/ruby/files/implicit.patch
    ],
    after: %w[
    ],
    full_version: "1.8.7-p374"
  }
}

abort if (ARGV[0].nil? && ARGV[1].nil?)

version, prefix = ARGV[0], ARGV[1]

system("brew install rbenv/tap/openssl@1.0 openssl@1.1")
system("brew uninstall bison")
system("brew unlink openssl@3")

require "fileutils"
FileUtils.mkdir_p("build")

Downloader.download(config_files)
[:before, :after].each do |key|
  Downloader.download(packages[version][key])
end

Dir.chdir("build") do
  system("tar -xf ruby-#{packages[version][:full_version]}.tar.*")
  Dir.chdir("ruby-#{packages[version][:full_version]}") do
    config_target = version < "1.9" ? "." : "tool/"
    config_files.each do |file|
      FileUtils.cp("../#{File.basename(file)}", config_target)
    end
    packages[version][:before][1..-1].each do |patch|
      system("patch -p0 < ../#{File.basename(patch)}")
    end
    openssl_version = version <= "2.3" ? "1.0" : "1.1"
    system("./configure CFLAGS='-Wno-error=implicit-int -Wno-error=incompatible-function-pointer-types -Wno-error=int-conversion -Wno-error=implicit-function-declaration' --with-openssl-dir=$(brew --prefix openssl@#{openssl_version}) --with-gdbm-dir=$(brew --prefix gdbm) --with-readline-dir=$(brew --prefix readline) --with-gmp-dir=$(brew --prefix gmp) --with-yaml-dir=$(brew --prefix libyaml) --disable-install-doc --without-tk --with-arch=arm64 --prefix=#{prefix}/#{packages[version][:full_version]}")
    packages[version][:after].each do |patch|
      system("patch -p0 < ../#{File.basename(patch)}")
    end
    system("make -j$(sysctl -n hw.logicalcpu)")
    system("make install")
  end
end

FileUtils.rm_rf("build")

system("brew link openssl@3")
system("brew install bison")
