require 'test_helper'

class PaperclipDragonflyTest < ActiveSupport::TestCase
  def setup
    @file_path = Rails.root.join( '../fixtures/image/Unknown.jpg')
    @file2_path = Rails.root.join('../fixtures/image/Jump away.jpg')
    config = Rails.configuration
    FileUtils::rm_rf config.paperclip_dragonfly.assets_path
    @tools = ::PaperclipDragonfly::StoringScope::Tools
  end

  test "truth" do
    assert_kind_of Module, PaperclipDragonfly
  end

  test "Get application configuration" do
    config = Rails.configuration
    assert_equal('hello', config.paperclip_dragonfly.security_key)
    assert_equal(true, config.paperclip_dragonfly.protect_from_dos_attacks)
    assert_equal('photos', config.paperclip_dragonfly.route_path)
  end

  test "Get time_partition path" do
    partition = @tools::time_partition
    assert(/\d{4}\/\d{2}\/\d{2}\/\d{2}\/\d{2}\/\d{2}\/\d{2,3}/.match(partition))
  end

  test "Get id_partition path" do
    assert_equal('000/000/001', @tools::id_partition(1))
    assert_equal('000/001/000', @tools::id_partition(1000))
  end
  test "Custom path style" do
    #config.paperclip_dragonfly.path_style = ''
    partition = @tools::generate_custom_style(':scope/:id/:inherited_size', {:scope => 'avatar', :id => 1, :inherited_size => 'original'})
    assert_equal('avatar/1/original', partition)
  end
  test "Get filename" do
    assert_equal('hello_my_world.jpg', @tools::filename_for('hello my world.jpg'))
  end

  test "have image_accessor, dragonfly_for class methods(User)" do
    assert(User.respond_to?(:image_accessor))
    assert(User.respond_to?(:dragonfly_for))
  end

  test "have image_accessor, dragonfly_for class methods(Image)" do
    assert(Image.respond_to?(:image_accessor))
    assert(Image.respond_to?(:dragonfly_for))
  end

  test "have partion_style instace method" do
    assert(User.new.respond_to?(:path_style))
  end

  test "find defined scope" do
    assert_equal('avatars', User.df_scope)
  end

  test "have generate_path instance method" do
    params = { :name => 'Ricard', :email => 'ricard@wuaki.tv', :avatar => File.open(@file_path) }
    user =  User.new(params)
    assert( user.respond_to?(:avatar))
  end

  test "Get user avatar uid(with custom scope)" do
    params = { :name => 'Ricard', :email => 'ricard@wuaki.tv', :avatar => File.open(@file_path) }
    user = User.new(params)
    path_style = user.path_style
    assert_equal(:id_partition, path_style)
    user.save
    assert_equal('avatars/000/000/001/Unknown.jpg', user.avatar_uid)
  end

  test "Get image uid(with default scope)" do
    params = { :image => File.open(@file_path) }
    user = Image.new(params)
    path_style = user.path_style
    assert_equal(:id_partition, path_style)
    user.save
    assert_equal('images/000/000/001/Unknown.jpg', user.image_uid)
  end

  test "Get image uid(with custom path style)" do
    params = { :custom_image => File.open(@file_path) }
    user = CustomImage.new(params)
    assert_equal(:custom, user.path_style)
    assert(user.save)
    assert_equal('custom_images/1/original/Unknown.jpg', user.custom_image_uid)
  end
end