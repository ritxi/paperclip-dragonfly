require 'rails'
module PaperclipDragonfly
  class Engine < ::Rails::Engine
    config.paperclip_dragonfly = PaperclipDragonfly
    initializer 'paperclip_dragonfly.load_datastorage_type' do |app|
      datastorage_type = app.config.paperclip_dragonfly.datastorage_type
      if %w(fs s3).include?(datastorage_type)
        require File.join %W(paperclip_dragonfly data_storage #{datastorage_type})
      else
        raise "Unknown datastorage type #{datastorage_type}"
      end
    end
    initializer 'paperclip_dragonfly.active_record' do
      ::ActiveRecord::Base.send(:extend, ::PaperclipDragonfly::Dragonfly::ActiveModelExtensions::ClassMethods)
      ::ActiveRecord::Base.send(:include, ::PaperclipDragonfly::CustomPathExtension)
    end
    initializer 'paperclip_dragonfly.load_extension', :after => 'paperclip_dragonfly.active_record' do
      if ::Rails.configuration.paperclip_dragonfly.assets_path == :default
        ::Rails.configuration.paperclip_dragonfly.assets_path = Rails.root.join('public','assets')
      end
      config = ::Rails.configuration.paperclip_dragonfly
      @app = ::Dragonfly[:images]
      @app.configure_with(:imagemagick)
      @app.configure do |c|
        c.protect_from_dos_attacks = config.protect_from_dos_attacks
        c.secret = config.security_key
        c.log = ::Rails.logger
        if ::Rails.env.production? || ::Rails.env.staging?
          @app.configure_with(:heroku, STORAGE_OPTIONS[:bucket])
        else
          if c.datastore.is_a?(::Dragonfly::DataStorage::FileDataStore)
            c.datastore.root_path = config.assets_path.to_s
            c.datastore.server_root = ::Rails.root.join('public').to_s
          end
        end
        c.url_format = "/#{config.route_path}/:job/:basename.:format"
        c.analyser.register(::Dragonfly::Analysis::FileCommandAnalyser)
      end
      @app.define_macro(::ActiveRecord::Base, :image_accessor)
    end
    initializer 'load asset dispatcher', :after => 'paperclip_dragonfly.load_extension' do |app|
      app.middleware.insert_after ::Rack::Lock, ::Dragonfly::Middleware, :images
    end
    # railtie code goes here
  end
end