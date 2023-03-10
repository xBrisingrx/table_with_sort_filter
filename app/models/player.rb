class Player < ApplicationRecord
  belongs_to :team

  FILTER_PARAMS = %i[name column direction].freeze

  scope :by_name, ->(query) { where('players.name like ?', "%#{query}%") }

  def self.filter(filters)
    # sql = "SELECT players.name, players.seasons, teams.name as team FROM 'players' 
    #   INNER JOIN teams ON teams.id = players.team_id 
    #     WHERE players.name like '%#{filters['name']}%' 
    #     OR players.seasons like '%#{filters['name']}%' 
    #     OR teams.name like '%#{filters['name']}%'"
    # players = ActiveRecord::Base.connection.execute(sql)
    Player.joins(:team)
          .select('players.id', 'players.name', 'players.seasons', 'teams.name as team_name')
          .by_name(filters['name'])
          .or(Player.where( 'players.seasons like ?', "%#{filters['name']}%" ))
          .or(Team.where( 'teams.name like ?', "%#{filters['name']}%" ))
          .order("#{filters['column']} #{filters['direction']}")
  end
end