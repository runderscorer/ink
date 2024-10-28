class StartRoundTimerJob < ApplicationJob
  queue_as :default

  def perform(room_code, round)
    elapsed_time = 1 

    while elapsed_time <= 100 && !canceled?(room_code, round)
      ActionCable.server.broadcast(room_code, {
        type: 'ROUND_TIMER',
        round: round,
        elapsed_time: elapsed_time
      })

      elapsed_time += 1

      sleep(1)
    end
  end

  private

  def canceled?(room_code, round)
    REDIS.get("round_timer_#{room_code}_#{round}_canceled").present?
  end
end
