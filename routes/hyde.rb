class MisterHyde < Sinatra::Application

    get '/hyde/sites' do
    	@sites = Site.all
        erb :'hyde/list'
    end

    get '/hyde/select' do
        redirect '/site/list' unless site = Site.get( params[:id] )
        session[:site_id] = site.id
        session[:site_title] = site.title
        redirect '/post/list'
    end

    get '/hyde/new' do
    	erb :'hyde/new'
    end

    post '/hyde/new' do
    	site = Site.new
    	site.title = params['name']
    	site.create
    	erb :'hyde/new', :locals => { :errors => site.error_messages }
    end

end
