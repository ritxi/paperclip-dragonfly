module PaperclipDragonfly
  module CustomPathExtension
    TO_BE_MIGRATE=true
    PATH_STYLES = [:id_partition, :time_partition, :custom]

    def path_style=(style)
      raise "Unknown path_style: #{style}" unless PATH_STYLES.include?(style)
      @path_style = style
    end
    def path_style
      @path_style ||= ((self.class.custom_path_style and :custom) or :id_partition)
    end

    def create_dragonfly_uid(df_uid_field,paperclip_accessor, options = {})
      options = {:original_size => :original}.merge(options)

      path = send(paperclip_accessor).path(options[:original_size])
      require_custom_path_style(path, options)
      if send(df_uid_field).nil? && path
        new_path = case path_style
        when :id_partition then path[%r{\w{1,}\/(\d{3}\/){3}.*}]
        when :time_partition then path[%r{(\d{4}\/)(\d{2}\/){5}(\d{3}\/).*}]
        when :custom then path[options[:replacement_regex]]
        end
        update_attribute(df_uid_field, new_path)
        raise "#{self.class.name.to_s}.#{df_uid_field} it should have some value!" if send(df_uid_field).nil?
      end
    end
    private
    def require_custom_path_style(path, options)
      if path_style == :custom
        if self.class.custom_path_style
          @custom_path_style = path
        else raise "style_path= :custom requires custom_path_style to be defined" end
        raise "options[:replacement_regex] param is required" unless options[:replacement_regex]
        raise "options[:replacement_regex] should be a regular expression" unless options[:replacement_regex].is_a?(Regexp)
      end
    end
  end
end