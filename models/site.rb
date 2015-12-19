class Site

    attr_accessor :id, :config
    attr_reader :error_messages

    def initialize
        @error_messages = Array.new
    end

    def config_filename
        Utterson.settings.sites_dir + @id + '/' + self.git_config_filename
    end

    def git_config_filename
        '_config.yml'
    end

    def layouts_directory
        Utterson.settings.sites_dir + @id + '/_layouts'
    end

    def errors
        @error_messages.length > 0
    end

    def update_config( new_config )
        @config.each do |name, value|
            @config[ name ] = new_config[ name ] unless new_config[ name ].nil?
        end
    end

    def load( site_id )
        @id = site_id
        return false unless File.exists? self.config_filename
        @config = YAML::load_file( self.config_filename )
    end

    def save
        return false unless self.validate
        self.write
    end

    def create
        return false unless self.validate_id

        cmd = Commandline.jekyll_new( @id )
        if cmd.error_messages.length > 0
            @error_messages = cmd.error_messages
            return false
        end

        return true
    end

    def rename( site_id )
        old_id = @id
        @id = site_id
        return false unless self.validate_id
        FileUtils.mv( Utterson.settings.sites_dir + old_id, Utterson.settings.sites_dir + @id )
        return true
    end

    def validate
        # FIXME: Validate config
        return true
    end

    def validate_id
        unless @id =~ /^[a-z0-9][a-z0-9_\-\.]+[a-z0-9]$/
            @error_messages << 'Invalid site name. Can only use a-z 0-9 _ - . and min. 3 characters.'
            return false
        end
        if File.exists? Utterson.settings.sites_dir + @id
            @error_messages << 'Site allready exists with that name.'
            return false
        end
        return true
    end

    def write
        begin
            file = File.open( self.config_filename, "w")
            file.write( @config.to_yaml )
        rescue IOError => e
            @errors_messages << 'Could not write post to ' + self.config_filename
            return false
        ensure
            file.close unless file.nil?
        end
        return true
    end

    def layouts
        layouts = Array.new
        Dir.entries( self.layouts_directory ).each do |layout|
            layouts << layout.gsub!(/\.html$/, '') unless File.directory? self.layouts_directory + '/' + layout
        end
        return layouts
    end

    def Site.get site_id
        site = Site.new
        return false unless site.load( site_id )
        return site
    end

    def Site.all
        sites = Array.new
        Dir.entries( Utterson.settings.sites_dir ).each do |site_id|
            if site = Site.get( site_id )
                sites << site
            end
        end
        return sites
    end

end
