require 'gossip'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: { gossips: Gossip.all }
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    gossip_author = params["gossip_author"]
    gossip_content = params["gossip_content"]
    next_id = Gossip.next_id

    new_gossip = Gossip.new(gossip_author, gossip_content)
    new_gossip.id = next_id

    new_gossip.save

    puts "OK reçu"
    redirect "/"
  end

  get '/gossips/:id' do
    gossip_id = params['id'].to_i
    gossip = Gossip.find(gossip_id)
    if gossip
      erb :show, locals: { gossip: gossip }
    else
      "Pas trouvé." 
    end
  end
end
