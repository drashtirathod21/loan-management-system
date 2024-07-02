class HomeController < ApplicationController
  def welcome
    if user_signed_in?
      @notifications = current_user.notifications.where(read: false)
    end
  end
end
