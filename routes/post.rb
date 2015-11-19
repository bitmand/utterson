class MisterHyde < Sinatra::Application

    get '/post/list' do
        @posts = Post.all( session[:site_id] )
        erb :'post/list'
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
            redirect '/post/edit/' + post.id + '?created=true'
        end
        erb :'post/create', :locals => { :site => site, :post => post }
    end

    get '/post/edit/:id' do
        @site = Site.get( session[:site_id] )
        @post = Post.get( session[:site_id], params['id'] )
        erb :'post/edit', :locals => { :errors => [] }
    end

    post '/post/edit/:id' do
        @site = Site.get( session[:site_id] )
        @post = Post.get( session[:site_id], params['id'] )
        @post.settings['title'] = params['title'].strip
        @post.settings['published'] = params['published'].strip
        @post.settings['layout'] = params['layout'].strip
        @post.settings['date'] = params['date'].strip
        @post.content = params['content']
        @post.save
        erb :'post/edit', :locals => { :errors => @post.error_messages }
    end

end
