class CreateGame < BaseService
  def call
    create_game

    self
  end

  private

  def create_game
    ActiveRecord::Base.transaction do
      game = Game.create(room_code: room_code)
      
      unless game.valid?
        error = game.errors.full_messages.last
        fail!(error)
        raise ActiveRecord::Rollback, game.errors.full_messages.last
      end

      player = Player.create(name: host_name, game: game, host: true)

      unless player.valid?
        error = player.errors.full_messages.last
        fail!(error)
        raise ActiveRecord::Rollback, player.errors.full_messages.last
      end
    end
  end
end
