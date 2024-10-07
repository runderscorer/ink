class CreateGame < BaseService
  attr_accessor :game

  def call
    return fail!('Player name is required') if host_name.blank?
    create_game(room_code, host_name)

    self
  end

  private

  def create_game(room_code, host_name)
    ActiveRecord::Base.transaction do
      room_code = room_code || Random.alphanumeric.first(8)
      @game = Game.create(room_code: room_code)
      
      unless game.valid?
        error = game.errors.full_messages.last
        fail!(error)
        raise ActiveRecord::Rollback, game.errors.full_messages.last
      end

      player = Player.create(name: host_name, game: @game, host: true)

      unless player.valid?
        error = player.errors.full_messages.last
        fail!(error)
        raise ActiveRecord::Rollback, player.errors.full_messages.last
      end
    end
  end
end
