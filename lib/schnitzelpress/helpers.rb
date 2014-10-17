module Schnitzelpress
  # Helper method collection
  module Helpers

    def h(*args)
      escape_html(*args)
    end

    def host
      env['HTTP_X_FORWARDED_HOST'] || env['HTTP_HOST']
    end

    def find_template(views, name, engine, &block)
      Array(views).each { |v| super(v, name, engine, &block) }
    end

    def base_url
      "#{env['rack.url_scheme']}://#{host}/"
    end

    def partial(name, locals = {})
      slim :"partials/_#{name}", locals: locals
    end

    def config
      Schnitzelpress::Model::Config.instance
    end

    def url_for(thing, options = {})
      url = thing.respond_to?(:to_url) ? thing.to_url : thing.to_s
      url = "#{base_url.sub(/\/$/, '')}#{url}" if options[:absolute]
      url
    end

    def show_disqus?
      config.disqus_id.present?
    end

    def user_logged_in?
      session[:auth].present?
    end

    def admin_logged_in?
      user_logged_in? && (session[:auth][:uid] == ENV['SCHNITZELPRESS_OWNER'])
    end

    def admin_only!
      redirect '/login' unless admin_logged_in?
    end

    def form_field(object, attribute, options = {})
      options = form_field_options(object, attribute, options)

      partial(
        'form_field',
        object: object,
        attribute: attribute,
        options: options
      )
    end

    def form_field_options(object, attribute, options)
      options = {
          label: attribute.to_s.humanize.titleize,
          value: object.send(attribute),
          errors: object.errors[attribute.to_sym],
          class_name: object.class.to_s.demodulize.underscore
      }.merge(options)

      options[:id] ||= form_field_id(object, attribute, options)
      options[:name] ||= "#{options[:class_name]}[#{attribute}]"
      options[:class] ||= "#{options[:class_name]}_#{attribute}"
      options[:type] ||= form_field_type(options[:value])

      options
    end

    def form_field_id(object, attribute, options)
      if object.new?
        "new_#{options[:class_name]}_#{attribute}"
      else
        "#{options[:class_name]}_#{object.id}_#{attribute}"
      end
    end

    def form_field_type(value)
      case value
      when DateTime, Time, Date
        :datetime
      when FalseClass, TrueClass
        :boolean
      else
        :text
      end
    end

    def icon(name)
      map = Fixture::FontAwesomeCharMap.all
      char = map.fetch(name, 'f06a')

      "<span class=\"font-awesome\">&#x#{char};</span>"
    end

    def link_to(title, target = '', options = {})
      options[:href] = target
      options[:data] ||= {}
      [:method, :confirm].each { |a| options[:data][a] = options.delete(a) }

      partial(:link_to, options: options, title: title)
    end

    def link_to_delete_post(title, post)
      link_to(
        title,
        "/admin/edit/#{post.id}",
        method: :delete,
        confirm: 'Are you sure? This can not be undone.'
      )
    end

  end
end
