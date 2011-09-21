class CustomImage < ActiveRecord::Base
  dragonfly_for :custom_image, :custom_path_style => '/:scope/:id/original'
end