module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_url)

    def self.load(environment)
      file = Schnitzelpress.config_path.join("#{environment}.yml")
      config = YAML.load(ERB.new(File.new(file).read).result)

      new(postgres_url: config['postgres_url'])
    end
  end
end
