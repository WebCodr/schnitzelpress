module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_url, :developer_login, :tracking)

    def self.load(environment)
      file = Schnitzelpress.config_path.join("#{environment}.yml")
      config = YAML.load(ERB.new(File.new(file).read).result)

      new(
        postgres_url:    config['postgres_url'],
        developer_login: config['developer_login'],
        tracking:        config['tracking']
      )
    end

    alias_method :developer_login?, :developer_login
    alias_method :tracking?, :tracking
  end
end
