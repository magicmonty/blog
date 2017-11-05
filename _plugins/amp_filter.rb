require 'nokogiri'
require 'fastimage'

module Jekyll
  module AmpFilter
    def amp_youtube(input)
      input.gsub /\{%\s*youtube\s+"https:\/\/youtu.be\/(.*)"\s*%\}/, '<div class="embed-container"> <amp-iframe width="300" height="300" sandbox="allow-scripts allow-same-origin allow-popups allow-popups-to-escape-sandbox" layout="responsive" frameborder="0" src="https://www.youtube.com/embed/\1"></amp-iframe></div>'
    end

    def amp_twitter(input)
      input.gsub /\{%\s*twitter\s+https:\/\/twitter.com\/[^\/]+\/status\/(\d+).*%\}/,
      '<amp-twitter layout="responsive" data-tweetid="\1" data-cards="hidden" width=486 height=657 />'
    end

    # Converts elements to 'amp-img' and adds additional attributes
    # Parameters:
    #   input       - the content of the post
    #   responsive  - boolean, whether to add layout=responsive, true by default
    def amp_images(input, responsive = true, wi = nil, he = nil)
      doc = Nokogiri::HTML.fragment(input);
      # Add width and height to img elements lacking them
      doc.css('img:not([width])').each do |image|
        if wi && he
          image['width']  = wi
          image['height'] = he
        else
          if image['src'].start_with?('http://', 'https://')
            src = image['src']
          else
            # FastImage doesn't seem to handle local paths when used with Jekyll
            # so let's just force the path
            src = File.join(Dir.pwd, image['src'])
          end
          # Jekyll generates static assets after the build process.
          # This causes problems when trying to determine the dimensions of a locally stored image.
          # For now, the only solution is to skip the build and generate the AMP files after the site has beem successfully built.
          # TODO: find a better solution.
          begin
            size = FastImage.size(src)
            image['width']  = size[0]
            image['height'] = size[1]
          rescue Exception => e
            puts 'Unable to get image dimensions for "' + src + '". For local files, build the site with \'--skip-initial-build\' for better results. [Error: ' + e.to_s + ']'
          end
        end
      end
      # Change 'img' elements to 'amp-img', add responsive attribute when needed
      doc.css('img').each do |image|
        image.name = "amp-img"
        image['layout'] = "responsive" if responsive
      end
      # Return the html as plaintext string
      doc.to_s
    end
  end
end

Liquid::Template.register_filter(Jekyll::AmpFilter)
