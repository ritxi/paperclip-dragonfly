module PaperclipDragonfly
  module DataStorage
    class FileDataStore
      include ::PaperclipDragonfly::StoringScope
      def path
        ::Rails.configuration.dragonfly_rails.assets_path.to_s
      end
      def relative_path_for(filename)
        generated_path = generate_path(filename)
        generated_path
      end
    end
  end
end