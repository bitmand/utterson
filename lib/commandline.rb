class Commandline

    attr_reader :last_output, :last_status, :full_output, :commands, :error_messages

    def initialize
        @error_messages = Array.new
        @commands = Array.new
        @full_output = Array.new
    end

    def add( command, path = String.new )
        command = 'cd ' + path.shellescape + ' && ' + command if path.length > 0
        @commands << command
    end

    def execute
        @commands.each do |command|
            @full_output << '$ ' + command
            @last_output, @last_status = Open3.capture2e( command ) # , stdin_data: stdin
            @full_output << @last_output
            unless @last_status.success?
                @error_messages << 'Command failed with: ' + @last_output
                puts 'ERROR: Commandline run failed! Command was "' + command + '" and error was: "' + @last_output + '"'
                return false
            end
        end
        return true
    end

    def Commandline.jekyll_new( site_id )
        site_path = ( Utterson.settings.sites_dir + site_id ).shellescape
        cmd = Commandline.new
        cmd.add( 'jekyll new ' + site_path )
        cmd.add( 'git init', site_path )
        cmd.add( 'git add . ', site_path )
        cmd.add( 'git commit -am "New Jekyll site"', site_path )
        cmd.execute
        return cmd
    end

    def Commandline.git_add( site_id, filename, message )
        site_path = ( Utterson.settings.sites_dir + site_id ).shellescape
        cmd = Commandline.new
        cmd.add( 'git add ' + filename.shellescape, site_path )
        cmd.add( 'git commit -am "' + message + '"', site_path )
        cmd.execute
        return cmd
    end

    def Commandline.git_rm( site_id, filename, message )
        site_path = ( Utterson.settings.sites_dir + site_id ).shellescape
        cmd = Commandline.new
        cmd.add( 'git rm ' + filename.shellescape, site_path )
        cmd.add( 'git commit -am "' + message + '"', site_path )
        cmd.execute
        return cmd
    end

    def Commandline.deploy( site_id, commands )
        site_path = ( Utterson.settings.sites_dir + site_id ).shellescape
        cmd = Commandline.new
        commands.each do |command|
            cmd.add( command, site_path )
        end
        cmd.execute
        return cmd
    end

end
