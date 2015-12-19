class Utterson < Sinatra::Application

    get '/hyde/sites' do
        @sites = Site.all
        erb :'hyde/list'
    end

    get '/hyde/select' do
        redirect '/site/list' unless site = Site.get( params[:id] )
        session[:site_id] = site.id
        session[:site_title] = site.config['title']
        redirect '/post/list'
    end

    get '/hyde/create' do
        erb :'hyde/create'
    end

    post '/hyde/create' do
        site = Site.new
        site.id = params['name']
        redirect '/hyde/select?id=' + site.id if site.create
        erb :'hyde/create', :locals => { :errors => site.error_messages }
    end

end
