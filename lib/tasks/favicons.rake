namespace :favicon do
  require 'mini_magick'

  FAVICONS_DIR = File.join(Rails.root, 'app', 'assets', 'images', 'favicons')
  VARIANTS = {
    'apple-touch-icon' => [[57,57], [72,72], [114,114], [120,120], [144,144], [152,152]],
    'mstile' => [[144,144]],
    'favicon' => [[16,16], [32,32]]
  }
  L = Logger.new(STDOUT)

  desc %Q{Generate various versions of favicon. Original file should be app/assets/images/favicons/orig.png and be at least 152x152px. }
  task :generate => File.join(FAVICONS_DIR, 'orig.png') do
    Dir.chdir(FAVICONS_DIR) do
      img = MiniMagick::Image.open('orig.png')
      fail "Image is too small" unless img.dimensions.all? { |dim, all| dim >= 152 }
      VARIANTS.each do |name, dims|
        dims.each do |dim|
          img = MiniMagick::Image.open('orig.png')
          img.resize dim.join('x')
          img.density 150
          img.quality 100
          oname = "#{name}-#{dim.join('x')}.png"
          img.write oname
          L.info "Written: #{File.join(FAVICONS_DIR, oname)}"
        end
      end
    end
  end
end
