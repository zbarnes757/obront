class UpdateUserCapacityJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    user.current_capacity = user.next_capacity
    user.save
    update_user_description(user)
  end

  private

  def freelancer_board
    Trello::Board.find(ENV['FREELANCER_BOARD'])
  end

  def update_user_description(user)
    freelancer_board.cards.each do |card|
      if card.name == user.full_name
        card.update!({ desc: user.build_description })
        break
      end
    end
  end
end
