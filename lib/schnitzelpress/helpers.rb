module Schnitzelpress
  # Helper method collection
  module Helpers
    FONT_AWESOME_CHAR_MAP = {
      glass: 'f000',
      music: 'f001',
      search: 'f002',
      envelope: 'f003',
      heart: 'f004',
      star: 'f005',
      star_empty: 'f006',
      user: 'f007',
      film: 'f008',
      th_large: 'f009',
      th: 'f00a',
      th_list: 'f00b',
      ok: 'f00c',
      remove: 'f00d',
      zoom_in: 'f00e',
      zoom_out: 'f010',
      off: 'f011',
      signal: 'f012',
      cog: 'f013',
      trash: 'f014',
      home: 'f015',
      file: 'f016',
      time: 'f017',
      road: 'f018',
      download_alt: 'f019',
      download: 'f01a',
      upload: 'f01b',
      inbox: 'f01c',
      play_circle: 'f01d',
      repeat: 'f01e',
      refresh: 'f021',
      list_alt: 'f022',
      lock: 'f023',
      flag: 'f024',
      headphones: 'f025',
      volume_off: 'f026',
      volume_down: 'f027',
      volume_up: 'f028',
      qrcode: 'f029',
      barcode: 'f02a',
      tag: 'f02b',
      tags: 'f02c',
      book: 'f02d',
      bookmark: 'f02e',
      print: 'f02f',
      camera: 'f030',
      font: 'f031',
      bold: 'f032',
      italic: 'f033',
      text_height: 'f034',
      text_width: 'f035',
      align_left: 'f036',
      align_center: 'f037',
      align_right: 'f038',
      align_justify: 'f039',
      list: 'f03a',
      indent_left: 'f03b',
      indent_right: 'f03c',
      facetime_video: 'f03d',
      picture: 'f03e',
      pencil: 'f040',
      map_marker: 'f041',
      adjust: 'f042',
      tint: 'f043',
      edit: 'f044',
      share: 'f045',
      check: 'f046',
      move: 'f047',
      step_backward: 'f048',
      fast_backward: 'f049',
      backward: 'f04a',
      play: 'f04b',
      pause: 'f04c',
      stop: 'f04d',
      forward: 'f04e',
      fast_forward: 'f050',
      step_forward: 'f051',
      eject: 'f052',
      chevron_left: 'f053',
      chevron_right: 'f054',
      plus_sign: 'f055',
      minus_sign: 'f056',
      remove_sign: 'f057',
      ok_sign: 'f058',
      question_sign: 'f059',
      info_sign: 'f05a',
      screenshot: 'f05b',
      remove_circle: 'f05c',
      ok_circle: 'f05d',
      ban_circle: 'f05e',
      arrow_left: 'f060',
      arrow_right: 'f061',
      arrow_up: 'f062',
      arrow_down: 'f063',
      share_alt: 'f064',
      resize_full: 'f065',
      resize_small: 'f066',
      plus: 'f067',
      minus: 'f068',
      asterisk: 'f069',
      exclamation_sign: 'f06a',
      gift: 'f06b',
      leaf: 'f06c',
      fire: 'f06d',
      eye_open: 'f06e',
      eye_close: 'f070',
      warning_sign: 'f071',
      plane: 'f072',
      calendar: 'f073',
      random: 'f074',
      comment: 'f075',
      magnet: 'f076',
      chevron_up: 'f077',
      chevron_down: 'f078',
      retweet: 'f079',
      shopping_cart: 'f07a',
      folder_close: 'f07b',
      folder_open: 'f07c',
      resize_vertical: 'f07d',
      resize_horizontal: 'f07e',
      bar_chart: 'f080',
      twitter_sign: 'f081',
      facebook_sign: 'f082',
      camera_retro: 'f083',
      key: 'f084',
      cogs: 'f085',
      comments: 'f086',
      thumbs_up: 'f087',
      thumbs_down: 'f088',
      star_half: 'f089',
      heart_empty: 'f08a',
      signout: 'f08b',
      linkedin_sign: 'f08c',
      pushpin: 'f08d',
      external_link: 'f08e',
      signin: 'f090',
      trophy: 'f091',
      github_sign: 'f092',
      upload_alt: 'f093',
      lemon: 'f094'
    }.freeze

    def h(*args)
      escape_html(*args)
    end

    def find_template(views, name, engine, &block)
      Array(views).each { |v| super(v, name, engine, &block) }
    end

    def base_url
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}/"
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

    def production?
      Schnitzelpress.env.production?
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

      partial(
        'form_field',
        object: object,
        attribute: attribute,
        options: options
      )
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
      name = name.gsub('-', '_').to_sym
      char = FONT_AWESOME_CHAR_MAP.fetch(name, 'f06a')

      "<span class=\"font-awesome\">&#x#{char};</span>"
    end

    def link_to(title, target = '', options = {})
      options[:href] = target.respond_to?(:to_url) ? target.to_url : target
      options[:data] ||= {}
      [:method, :confirm].each { |a| options[:data][a] = options.delete(a) }

      slim "a(href=\"#{options[:href]}\" data-method=\"#{options[:data][:method]}\" data-confirm=\"#{options[:data][:confirm]}\") #{title}"
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
