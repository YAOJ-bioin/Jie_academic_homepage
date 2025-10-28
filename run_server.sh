#!/usr/bin/env bash
# Ensure rbenv environment is loaded
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - bash)"
bundle exec jekyll serve  
set -euo pipefail

BUNDLER_VERSION="2.3.24"
RUBY_VERSION="$(ruby -e 'print Gem.ruby_version')"
GEM_BIN="$HOME/.gem/ruby/${RUBY_VERSION}/bin"

# Ensure the user gem bin directory is preferred over the system stub
export PATH="$GEM_BIN:$PATH"

if ! gem list -i bundler -v "$BUNDLER_VERSION" >/dev/null 2>&1; then
  echo "Installing bundler $BUNDLER_VERSION locally (requires network access)..."
  gem install --user-install bundler -v "$BUNDLER_VERSION"
fi

if [ ! -x "$GEM_BIN/bundle" ]; then
  echo "Bundler executable not found at $GEM_BIN/bundle" >&2
  exit 1
fi

"$GEM_BIN/bundle" exec jekyll serve --livereload

