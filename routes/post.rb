class MisterHyde < Sinatra::Application

    get '/post/list' do
        posts = Post.all( session[:site_id] )
        erb :'post/list', :locals => { :posts => posts }
    end

    get '/post/create' do
        site = Site.get( session[:site_id] )
        post = Post.new
        erb :'post/create', :locals => { :site => site, :post => post }
    end

    post '/post/create' do
        site = Site.get( session[:site_id] )
        post = Post.new
        post.settings['title'] = params['title'].strip
        post.settings['published'] = params['published'].strip
        post.settings['layout'] = params['layout'].strip
        post.settings['date'] = params['date'].strip
        post.content = params['content']
        if post.create( site.id, params['name'].strip.downcase.gsub(' ', '-') )
            Commandline.git_add( site.id, post.git_filename, 'Creating post: ' + post.id.shellescape )
            redirect '/post/edit/' + post.id + '?created=true'
        end
        erb :'post/create', :locals => { :site => site, :post => post }
    end

    get '/post/edit/:id' do
        site = Site.get( session[:site_id] )
        post = Post.get( session[:site_id], params['id'] )
        erb :'post/edit', :locals => { :site => site, :post => post }
    end

    post '/post/edit/:id' do
        site = Site.get( session[:site_id] )
        post = Post.get( session[:site_id], params['id'] )
        post.settings['title'] = params['title'].strip
        post.settings['published'] = params['published'].strip
        post.settings['layout'] = params['layout'].strip
        post.settings['date'] = params['date'].strip
        post.content = params['content']
        if post.save
            Commandline.git_add( site.id, post.git_filename , 'Updating post: ' + post.id.shellescape )
        end
        erb :'post/edit', :locals => { :site => site, :post => post }
    end

    get '/post/delete/:id' do
        site = Site.get( session[:site_id] )
        post = Post.get( session[:site_id], params['id'] )
        erb :'post/delete', :locals => { :site => site, :post => post }
    end

    post '/post/delete/:id' do
        site = Site.get( session[:site_id] )
        post = Post.get( session[:site_id], params['id'] )
        Commandline.git_rm( site.id, post.git_filename, 'Deleting post: ' + post.id.shellescape )
        erb :'post/delete', :locals => { :site => site, :post => post }
    end

end
