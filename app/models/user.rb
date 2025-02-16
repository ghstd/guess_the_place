class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  # , :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :game_players
  has_many :games, through: :game_players
  has_many :games_statistics, dependent: :destroy
end
