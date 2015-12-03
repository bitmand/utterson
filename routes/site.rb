class MisterHyde < Sinatra::Application

    get '/site/configuration' do
        erb :'site/config', :locals => { :site => Site.get( session['site_id'] ) }
    end

    post '/site/configuration' do
        site = Site.get( session['site_id'] )
        site.update_config( params )
        if site.save
            session[:site_title] = site.config['title']
            Commandline.git_add( site.id, site.git_config_filename , 'Updating config' )
        end
        erb :'site/config', :locals => { :site => site }
    end

    get '/site/rename' do
        erb :'site/rename', :locals => { :site => Site.get( session['site_id'] ) }
    end

    post '/site/rename' do
        site = Site.get( session['site_id'] )
        session[:site_id] = site.id if site.rename( params['siteid'] )
        erb :'site/rename', :locals => { :site => site }
    end

end
