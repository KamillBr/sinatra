require 'csv'

class Gossip
  attr_accessor :author, :content, :id

  def initialize(author, content, id = nil)
    @content = content
    @author = author
    @id = id || Gossip.next_id
  end

  def save
    all_gossips = self.class.all  # Récupère tous les gossips existants
    all_gossips << self           # Ajoute le nouveau gossip
  
    CSV.open("./db/gossip.csv", "wb") do |csv|
      all_gossips.each do |gossip|
        csv << [gossip.author, gossip.content, gossip.id]
      end
    end
  end

  def self.all
    all_gossips = []
    CSV.foreach('./db/gossip.csv') do |row|
      all_gossips << Gossip.new(row[0], row[1], row[2].to_i)
    end
    all_gossips
  end

  def self.next_id
    last_id = CSV.read('./db/gossip.csv').map { |row| row[2].to_i }.max || 0
    last_id + 1
  end

  def self.find(id)
    all.find { |gossip| gossip.id == id }
  end
end
