require 'sinatra/base'
module AssetsHelpers
  def versioned_javascript
    "script.js?#{File.mtime('public/script.js').to_i}"
  end
end