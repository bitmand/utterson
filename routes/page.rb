class Utterson < Sinatra::Application

    get '/page/list' do
        erb :'page/list'
    end

end
