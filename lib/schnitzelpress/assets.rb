module Schnitzelpress
  # Asset class
  class Assets

    ASSETS_DIR = Schnitzelpress.root.join('assets').freeze

    # Constructor
    #
    # @api private
    #
    def initialize
      configure_compass
      configure_sass
      add_css_rules
      add_js_rules
      add_image_rules
      add_font_rules
      assets_environment
      assets_handler
    end

    # Return asset handler
    #
    # @return [Assets::Handler]
    #
    # @api private
    #
    def assets_handler
      @assets_handler ||= ::Assets::Handler.new(assets_environment, '/assets/')
    end

    private

    # Return rules
    #
    # @return [Array]
    #
    # @api private
    #
    def rules
      @rules ||= []
    end

    # Return asset repository
    #
    # @return [Assets::Repository::Directory]
    #
    # @api private
    #
    def assets_repository
      @assets_repository ||= ::Assets::Repository::Directory.new(ASSETS_DIR)
    end

    # Return asset environment
    #
    # @return [Assets::Environment::Cache]
    #
    # @api private
    #
    def assets_environment
      @assets_environment ||= ::Assets::Environment::Cache.build(rules)
    end

    # Configure Compass
    #
    # @api private
    #
    def configure_compass
      Compass.configuration do |config|
        config.http_path = '/assets'
        config.project_path = ASSETS_DIR
        config.css_dir = 'stylesheets'
        config.sass_dir = 'stylesheets'
        config.images_dir = 'images'
        config.javascripts_dir = 'javascripts'
        config.fonts_dir = 'fonts'
        config.http_javascripts_dir = 'javascripts'
        config.http_stylesheets_dir = 'stylesheets'
        config.http_images_dir = 'images'
        config.http_fonts_dir = 'fonts'
      end
    end

    # Configure SASS
    #
    # @api private
    #
    def configure_sass
      # Ugly hack for Vagrant on Windows hosts
      #
      # On Windows hosts the SASS cache cannot be in the shared directory
      # of Vagrant
      # SASS throws an error that cache files are busy due to shared folder
      # behaviour of Virtual Box
      # and SASS cannot compile the stylesheets

      if ENV['VAGRANT_WINDOWS_HOST']
        options = Sass::Engine::DEFAULT_OPTIONS.dup
        options[:cache_location] = '/tmp/.sass-sache'
        Sass::Engine.const_set(:DEFAULT_OPTIONS, options.freeze)
      end

      compass_config = Compass::Configuration::Data.new('foo')

      Sass.load_paths.concat(compass_config.sass_load_paths)
      Sass.load_paths << ASSETS_DIR.join('stylesheets')
    end

    # Add Stylesheet rules
    #
    # @api private
    #
    def add_css_rules
      rules << ::Assets::Builder.run('application.css') do |builder|
        builder.append(
          assets_repository.compile('stylesheets/schnitzelpress.sass')
        )
      end
    end

    # Add JavaScript/CoffeeScript rules
    #
    # @api private
    #
    def add_js_rules
      rules << ::Assets::Builder.run('application.js') do |builder|
        builder.append assets_repository.file('javascripts/jquery-1.7.1.js')
        builder.append assets_repository.file('javascripts/jquery.cookie.js')
        builder.append assets_repository.file('javascripts/schnitzelpress.js')
        builder.append assets_repository.file('javascripts/jquery-ujs.js')
      end
    end

    # Add image rules
    #
    # @api private
    #
    def add_image_rules
      image_paths = ASSETS_DIR.join('images/**/*.{jpg,png,gif,ico}')
      Pathname.glob(image_paths).each do |name|
        rules << assets_repository.file(name.relative_path_from(ASSETS_DIR))
      end
    end

    # Add web font rules
    #
    # @api private
    #
    def add_font_rules
      Pathname.glob(ASSETS_DIR.join('fonts/*.woff')).each do |name|
        rules << assets_repository.file(name.relative_path_from(ASSETS_DIR))
      end
    end

  end
end
