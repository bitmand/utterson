class Post

    attr_reader :id, :site_id, :settings, :error_messages
    attr_accessor :content

    def initialize
        @content = String.new
        @error_messages = Array.new
        @settings = {
            'layout' => 'post',
            'title' => String.new,
            'date' => DateTime.now.strftime('%F %T'),
            'categories' => Array.new,
            'published' => true
        }
    end

    def filename
        return Utterson.settings.sites_dir + @site_id + '/_posts/' + @id
    end

    def git_filename
        return '_posts/' + @id
    end

    def load site_id, post_id
        @id = post_id
        @site_id = site_id
        return false unless File.exists? self.filename
        raw_post = File.read( self.filename )

        # Set date from filename here, it may be overridden if
        # specified in the YAML front matter too
        @settings['date'] = DateTime.parse(post_id[0..9]).strftime('%F %T')

        YAML::load( raw_post ).each do |name, value|
            case name
            when 'category'
                @settings['categories'] << value
            when 'categories'
                if value.is_a? Array
                    @settings['categories'] += value
                else
                    value.split(',').each do |category|
                        @settings['categories'] << category.strip
                    end
                end
            else
                @settings[ name ] = value
            end
        end

        @content = raw_post.gsub!( /---(.*)---/m, '' ).strip

        return true
    end

    def save
        return false unless self.validate
        self.write
    end

    def create site_id, short_post_id
        @id = short_post_id
        @site_id = site_id
        return false unless self.validate_id( short_post_id )
        return false unless self.validate
        @id = @settings['date'][0, 10] + '-' + @id + '.markdown'
        self.write
    end

    def validate
        @error_messages << 'Title is mandatory' if @settings['title'].length == 0

        if @settings['published'].is_a? String
            @settings['published'] = ( @settings['published'] == 'true' ? true : false )
        end

        @settings['categories'].uniq!

        begin
            DateTime.strptime( @settings['date'].to_s, '%Y-%m-%d %H:%M:%S')
        rescue
            @error_messages << 'Date is not in valid format: YYYY-MM-DD HH:MM:SS'
        end

        @error_messages.length == 0
    end

    def validate_id( short_post_id )
        unless short_post_id =~ /^[a-z0-9][a-z0-9\-]+[a-z0-9]$/
            @error_messages << "Post name is not valid ( use only a-z 0-9 and - )"
            return false
        end
        return true
    end

    def write
        begin
            file = File.open( self.filename, "w")
            file.write( @settings.to_yaml )
            file.write( "---\n" )
            file.write( @content )
        rescue IOError => e
            @errors_messages << 'Could not write post to ' + self.filename
            return false
        ensure
            file.close unless file.nil?
        end
        return true
    end

    def all_categories
        categories = Array.new
        Post.all(@site_id).each do |post|
            post.settings['categories'].each do |category|
                categories << category
            end
        end
        return categories.uniq.sort
    end

    def Post.get site_id, post_id
        post = Post.new
        post.load( site_id, post_id )
        return post
    end

    def Post.all site_id
        # FIXME: This loads _ALL_ posts into one array, which is BAD!
        #        We should have some sort of lazy loading of the blog post content
        posts_dir = Utterson.settings.sites_dir + site_id + '/_posts'
        posts = Array.new
        Dir.entries( posts_dir ).reverse.each do |post_id|
            unless post_id =~ /~$/
              yaml_config = posts_dir + '/' + post_id
              posts << Post.get( site_id, post_id) unless File.directory? yaml_config
            end
        end
        return posts
    end

end
