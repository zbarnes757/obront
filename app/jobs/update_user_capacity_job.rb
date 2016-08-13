class UpdateUserCapacityJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.current_capacity = user.next_capacity
    user.save
    add_monthly_comment(user)
  end

  private

  def freelancer_board
    Trello::Board.find(ENV['FREELANCER_BOARD'])
  end

  def add_monthly_comment(user)
    freelancer_board.cards.each do |card|
      if card.name == user.full_name
        card.add_comment(user.monthly_comment)
        break
      end
    end
  end
end
