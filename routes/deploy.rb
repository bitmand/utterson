class Utterson < Sinatra::Application

    get '/deploy' do
        erb :'deploy/list', :locals => { :site => Site.get( session['site_id'] ) }
    end

    get '/deploy/to/:environment' do
        site = Site.get( session['site_id'] )
        redirect '/deploy' if site.config['utterson_deploy'][ params[:environment] ].nil?
        erb :'deploy/confirm', :locals => { :site => site }
    end

    post '/deploy/to/:environment/confirmed' do
        site = Site.get( session['site_id'] )
        redirect '/deploy' if site.config['utterson_deploy'][ params[:environment] ].nil?
        deploy = site.deploy( params[:environment] )
        erb :'deploy/deployed', :locals => { :site => site, :deploy => deploy }
    end

end
