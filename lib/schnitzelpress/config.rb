module Schnitzelpress
  # Configuration class
  class Config
    include Anima.new(:postgres_url, :developer_login, :tracking)
    extend Morpher::NodeHelpers

    def self.load(environment)
      file = Schnitzelpress.config_path.join("#{environment}.yml")
      config = YAML.load(ERB.new(File.new(file).read).result)

      transform(config)
    end

    alias_method :developer_login?, :developer_login
    alias_method :tracking?, :tracking

  private

    def self.transform(vaLues)
      boolean = s(:or,
        s(:primitive, TrueClass),
        s(:primitive, FalseClass)
      )

      transformer = s(:block,
        s(:guard, s(:primitive, Hash)),
        s(:hash_transform,
          s(:key_symbolize, :postgres_url,
            s(:guard, s(:primitive, String))
          ),
          s(:key_symbolize, :developer_login,
            boolean
          ),
          s(:key_symbolize, :tracking,
            boolean
          )
        ),
        s(:load_attribute_hash, s(:param, Config))
      )

      evaluator = Morpher.compile(transformer)

      evaluator.call(vaLues)
    end
  end
end
