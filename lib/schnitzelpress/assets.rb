module Schnitzelpress

  assets_dir        = Schnitzelpress.root.join('assets')
  assets_repository = Assets::Repository::Directory.new(assets_dir)

  Compass.configuration do |config|
    config.http_path = "/assets"
    config.project_path = assets_dir
    config.css_dir = "stylesheets"
    config.sass_dir = "stylesheets"
    config.images_dir = "images"
    config.javascripts_dir = "javascripts"
    config.fonts_dir = "fonts"
    config.http_javascripts_dir = "javascripts"
    config.http_stylesheets_dir = "stylesheets"
    config.http_images_dir = "images"
    config.http_fonts_dir = "fonts"
  end

  # Ugly hack for Vagrant on Windows hosts
  #
  # On Windows hosts the SASS cache cannot be in the shared directory of Vagrant
  # SASS throws an error that cache files are busy due to shared folder behaviour of Virtual Box
  # and SASS cannot compile the stylesheets

  if ENV['VAGRANT_WINDOWS_HOST']
    options = Sass::Engine::DEFAULT_OPTIONS.dup
    options[:cache_location] = '/tmp/.sass-sache'
    Sass::Engine::DEFAULT_OPTIONS = options.freeze
  end

  Sass.load_paths.concat(Compass::Configuration::Data.new('foo').sass_load_paths)
  Sass.load_paths << assets_dir.join('stylesheets')

  application_css = Assets::Builder.run('application.css') do |builder|
    builder.append assets_repository.compile('stylesheets/schnitzelpress.sass')
  end

  application_js = Assets::Builder.run('application.js') do |builder|
    builder.append assets_repository.file('javascripts/jquery-1.7.1.js')
    builder.append assets_repository.file('javascripts/jquery.cookie.js')
    builder.append assets_repository.file('javascripts/schnitzelpress.js')
    builder.append assets_repository.file('javascripts/jquery-ujs.js')
  end

  rules = []
  rules << application_css
  rules << application_js

  Pathname.glob(assets_dir.join('images/**/*')).each do |name|
    rules << assets_repository.file(name.relative_path_from(assets_dir))
  end

  Pathname.glob(assets_dir.join('images/**/*.{jpg,png,gif,ico}')).each do |name|
    rules << assets_repository.file(name.relative_path_from(assets_dir))
  end

  Pathname.glob(assets_dir.join('fonts/*.woff')).each do |name|
    rules << assets_repository.file(name.relative_path_from(assets_dir))
  end

  assets_environment = Assets::Environment::Cache.build(rules)

  ASSETS_HANDLER = Assets::Handler.new(assets_environment, '/assets/')
end