class Post

    attr_reader :id, :site_id, :filename, :settings, :error_messages
    attr_accessor :content

    def initialize
        @content = String.new
        @error_messages = Array.new
        @settings = {
            'layout' => 'post',
            'title' => String.new,
            'date' => DateTime.now.strftime('%F %T'),
            'categories' => String.new,
            'published' => true
        }
    end

    def load site_id, post_id
        @id = post_id
        @site_id = site_id
        @filename = MisterHyde.settings.sites_dir + @site_id + '/_posts/' + @id

        # FIXME: Check if file exists
        # FIXME: Catch IO exceptions
        raw_post = File.read( @filename )
        raw_settings = YAML::load( raw_post )

        @settings.keys.each do |setting|
            if not raw_settings[ setting ].nil?
                @settings[ setting ] = raw_settings[ setting ]
            end
        end
        @content = raw_post.gsub!( /---(.*)---/m, '' )
    end

    def save
        return false unless self.validate
        return false unless self.write
        return self.commit
    end

    def create site_id, post_id
        return false unless self.validate

        # Validate and check id ( only on create )
        if post_id =~ /^[a-z0-9][a-z0-9\-]+[a-z0-9]$/
            @id = @settings['date'][0, 10] + '-' + post_id + '.markdown'
            @site_id = site_id
            @filename = MisterHyde.settings.sites_dir + @site_id + '/_posts/' + @id
        else
            @error_messages << "Post name is not valid ( use only a-z 0-9 and - )"
            return false
        end

        return false unless self.write
        return self.commit        
    end

    def validate
        @error_messages << 'Title is mandatory' if @settings['title'].length == 0

        case @settings['published']
        when "true"
            @settings['published'] = true
        when "false"
            @settings['published'] = false
        else
            @error_messages << 'Published must be true or false'
        end

        begin
            DateTime.strptime( @settings['date'].to_s, '%Y-%m-%d %H:%M:%S')
        rescue
            @error_messages << 'Date is not in valid format: YYYY-MM-DD HH:MM:SS'
        end

        @error_messages.length == 0
    end

    def write
        begin
            file = File.open( @filename, "w")
            file.write( @settings.to_yaml )
            file.write( "---\n" )
            file.write( @content )
        rescue IOError => e
            @errors_messages << 'Could not write post to ' + @filename
            return false
        ensure
            file.close unless file.nil?
        end
        return true
    end

    def commit
        return true
    end

    def destroy
        # FIXME: Catch IO Error
        File.delete( @filename )
        return self.commit
    end

    def Post.get site_id, post_id
        post = Post.new
        post.load( site_id, post_id )
        return post
    end

    def Post.all site_id
        posts_dir = MisterHyde.settings.sites_dir + site_id + '/_posts'
        posts = Array.new
        Dir.entries( posts_dir ).reverse.each do |post_id|
            yaml_config = posts_dir + '/' + post_id
            if not File.directory? yaml_config
                config = YAML::load_file( yaml_config )
                posts << [ post_id, config['title'], ( config['published'].nil? ? true : config['published'] ), config['date'] ]
            end
        end
        return posts
    end

end
