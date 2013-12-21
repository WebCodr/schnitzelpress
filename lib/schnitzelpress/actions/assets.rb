module Schnitzelpress
  class JavascriptPacker
    def self.pack_javascripts!(files)
      files.map do |file|
        File.read(Schnitzelpress.root.join('assets').join('javascript').join(file))
      end.join("\n")
    end
  end

  module Actions
    module Assets
      extend ActiveSupport::Concern

      ASSET_TIMESTAMP = Time.now.to_i
      JAVASCRIPT_ASSETS = ['jquery-1.7.1.js', 'jquery.cookie.js', 'schnitzelpress.js', 'jquery-ujs.js']

      included do
        get '/assets/schnitzelpress.:timestamp.css' do
          cache_control :public, :max_age => 1.year.to_i
          scss :blog
        end

        get '/assets/schnitzelpress.:timestamp.js' do
          cache_control :public, :max_age => 1.year.to_i
          content_type 'text/javascript; charset=utf-8'
          JavascriptPacker.pack_javascripts!(JAVASCRIPT_ASSETS)
        end
      end
    end
  end
end
