class StartRoundTimerJob < ApplicationJob
  queue_as :default
  ROUND_LENGTH = 100

  def perform(room_code, round)
    elapsed_time = 1 

    while elapsed_time <= ROUND_LENGTH && !canceled?(room_code, round)
      ActionCable.server.broadcast(room_code, {
        type: 'ROUND_TIMER',
        round: round,
        elapsed_time: elapsed_time
      })

      elapsed_time += 1

      sleep(1)

      handle_timer_end(room_code) if elapsed_time == ROUND_LENGTH
    end
  end

  private

  def canceled?(room_code, round)
    REDIS.get("round_timer_#{room_code}_#{round}_canceled").present?
  end

  def handle_timer_end(room_code)
    Game.by_room_code(room_code).handle_timer_ended! 
  end
end
