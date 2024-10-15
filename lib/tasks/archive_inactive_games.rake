  desc 'Archive games that are inactive'
  task archive_inactive_games: :environment do
    Game.where('created_at < ?', 1.day.ago).where(archived: false).update_all(archived: true)
  end
