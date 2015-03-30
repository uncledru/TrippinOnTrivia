class PlayController < ApplicationController
  def index

  end

  def display_spinner
    current_user.active_player.update_attribute(:going_for_trophy, false)
    if (current_user.active_player.isActivePlayer)
    @rotations = rand(80000...100000)
    @category_number = @rotations%360
    case @category_number
      when 0..53
        @random_category = Category.all[1]
      when 54..104
        @random_category = Category.all[2]
      when 105..155
        @random_category = Category.all[3]
      when 156..206
        @random_category = Category.all[4]
      when 207..257
        @random_category = Category.all[5]
      when 258..308
        @random_category = Category.all[0]
      when 309..359
        current_user.active_player.update_attribute(:meter, 3)
    end
      current_user.active_player.current_category = @random_category
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  def display_new_game_page
    current_user.active_player = current_user.players.create(meter: 0, isActivePlayer: true)

    User.all.each do |user|
      if (user.uid != current_user.uid)
      user.players.each do |player|
        if (player.opponent.nil? && !player.isActivePlayer)
          current_user.active_player.opponent = player
          player.opponent = current_user.active_player
          break
        end
      end
        if (current_user.active_player.opponent != null)
          break
        end
      end
    end
  end

  def display_questions
    @question = current_user.active_player.current_category.questions.all.shuffle[0]
    current_user.active_player.current_question = @question

    def true_answer

      if (current_user.active_player.going_for_trophy)
        current_user.active_player.trophies << current_user.active_player.current_question.category.trophy
        current_user.active_player.update_attribute(:going_for_trophy, false)
      else
        current_user.active_player.update_attribute(:meter, current_user.active_player.meter + 1)
      end
    end

    def false_answer
      current_user.active_player.update_attribute(:going_for_trophy, false)
      current_user.active_player.update_attribute(:isActivePlayer, false)
      current_user.active_player.opponent.update_attribute(:isActivePlayer, true)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def display_trophy_select
    @categories = Category.all
    current_user.active_player.update_attribute(:going_for_trophy, true)
    current_user.active_player.update_attribute(:meter, 0)
  end

  def get_trophy_category
    current_user.active_player.current_category = Category.find(params[:category_id])
  end

  def get_selected_player
    current_user.active_player = current_user.players.find(params[:player_id])
  end

end
