module PaperclipDragonfly
  module StoringScope
    attr_reader :custom_scope
    module Tools
      def self.id_partition *options
        model_id = options.first
        ("%09d" % model_id).scan(/\d{3}/).join("/")
      end

      def self.time_partition *options
        ::File.join(Time.now.strftime('%Y/%m/%d/%H/%M/%S'), rand(1000).to_s)
      end

      def self.filename_for(file)
        file.gsub(/[^\w.]+/, '_')
      end

      def self.generate_custom_style(path, values)
        values.each{ |key,value| path.gsub!(":#{key}", value.to_s) }
        path
      end
    end

    def values_for_custom_path
      {
        :id_partition => Tools::id_partition(@model.id),
        :scope => @custom_scope,
        :id => @model.id,
        :inherited_size => 'original'
      }
    end

    def scope_for=(model_object)
      @model = model_object
      scoped_path = @model.class.respond_to?('df_scope') && @model.class.df_scope ? @model.class.df_scope : @model.class.table_name
      @custom_scope = scoped_path
    end

    def path
      raise "Path must be defined on the class where I'll be included to(File, S3, Mongo, etc)!!!!"
    end

    # Generate path as id_partition or time_partition
    # depending on @model.partition_style method
    def generate_path(filename)
      path_style = @model.path_style
      filename = Tools::filename_for(filename)
      if [:id_partition, :time_partition].include?(path_style)
        uid = eval("Tools::#{path_style}(@model[:id])")
        ::File.join(custom_scope, uid, filename)
      elsif path_style == :custom
        uid = Tools::generate_custom_style(@model.class.custom_path_style, values_for_custom_path)
        ::File.join(uid, filename)
      end
    end
  end
end