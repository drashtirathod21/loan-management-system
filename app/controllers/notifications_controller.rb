class NotificationsController < ApplicationController
  def mark_as_read
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    redirect_to root_path
  end
end
