# frozen_string_literal: true

SimpleCov.start do
  add_filter %r{^/.git/}
  add_filter %r{^/.bundle/}
  add_filter %r{^/tmp/}
  add_filter %r{^/coverage/}
  add_filter %r{^/vendor/}
  add_filter %r{^/node_modules/}
  add_filter %r{^/bin/}
  add_filter %r{^/exe/}
  add_filter %r{^/spec/}
end
