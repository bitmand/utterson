require 'rubygems'
require 'bundler/setup'
require 'tilt/erb'
require 'open3'
require 'shellwords'

Bundler.require(:default)

# Lib
require_relative 'lib/commandline'

# Models
require_relative 'models/site.rb'
require_relative 'models/post.rb'

# Routes
require_relative 'routes/hyde.rb'
require_relative 'routes/site.rb'
require_relative 'routes/page.rb'
require_relative 'routes/post.rb'

# Enable sessions
# FIXME: The secret is random enough for now
use Rack::Session::Cookie, :expire_after => 3600, :secret => 'lbmjgwktggceepkuomsduvysqbuvhxbu'

class Utterson < Sinatra::Application

	set :sites_dir, 'sites/'

	before do
		unless ['/','/hyde/sites','/hyde/create','/hyde/select'].include? request.path_info
			redirect '/hyde/sites' if session[:site_id].nil?
		end
	end

	get '/' do
		redirect '/hyde/sites'
	end

end

