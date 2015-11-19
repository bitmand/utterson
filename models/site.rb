class Site

    attr_accessor :id, :title, :description, :baseurl, :url
    attr_reader :error_messages

    def initialize
        @error_messages = Array.new
    end

    def create
        unless @title =~ /^[a-z0-9][a-z0-9_\-\.]+[a-z0-9]$/
            @error_messages << ['Invalid site name. Can only use a-z 0-9 _ - . and min. 3 characters.']
            return false
        end
        # FIXME: Fix site create
        # jekyll new sites/testhat
        # cd sites/testhat
        # git init
        # git add .
        # git commit -am "Initial commit of new site"
    end

    def layouts
        layouts = Array.new
        layout_path = MisterHyde.settings.sites_dir + @id + '/_layouts'
        Dir.entries( layout_path ).each do |layout|
            layouts << layout.gsub!(/\.html$/, '') unless File.directory? layout_path + '/' + layout
        end
        return layouts
    end

    def Site.get site_id
        yaml_config = MisterHyde.settings.sites_dir + site_id + '/_config.yml'
        return false unless File.exists? yaml_config
        config = YAML::load_file( yaml_config )
        site = Site.new
        site.id = site_id
        site.title = config['title']
        site.description = config['description']
        site.baseurl = config['baseurl']
        site.url = config['url']
        return site
    end

    def Site.all
        sites = Array.new
        Dir.entries( MisterHyde.settings.sites_dir ).each do |site_id|
            yaml_config = MisterHyde.settings.sites_dir + site_id + '/_config.yml'
            if File.exists? yaml_config
                config = YAML::load_file( yaml_config )
                sites << [ site_id, config['title'], config['url'] ]
            end
        end
        return sites
    end

end

