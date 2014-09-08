module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_url, :developer_login)

    def self.load(environment)
      file = Schnitzelpress.config_path.join("#{environment}.yml")
      config = YAML.load(ERB.new(File.new(file).read).result)

      new(
        postgres_url:    config['postgres_url'],
        developer_login: config['developer_login']
      )
    end

    alias_method :developer_login?, :developer_login
  end
end
