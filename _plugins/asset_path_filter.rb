module Jekyll
  module AssetPathFilter
    def assetpathify(input, slug = "FOO")
      input.gsub(/\{%\s*asset_path\s+([^\s]+)\s*%\}/, "/img/posts/#{slug}/\\1")
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetPathFilter)
