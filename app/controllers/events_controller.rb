class EventsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in

  def index

  end

  def new
    @event = current_user.event.build
  end

  def create
    build_params = event_params

    build_params[:event_at] = Date.strptime(
          "%s %s" % [ format_date_string( build_params[:event_at_date]),  build_params[:event_at_time]],
          "%Y/%m/%d %H:%M %p")

    build_params[:deadline_at] = Date.strptime(
          "%s %s" % [ format_date_string( build_params[:deadline_at_date]), build_params[:deadline_at_time]],
          "%Y/%m/%d %H:%M %p")

    build_params[:status]  = Event::STATUS_NORMAL

    @event = current_user.event.build( build_params )

    if @event.save
      redirect_to events_path, notice:  I18n.t("layouts.notice.create_event")
    else
      @event.event_at_date = build_params[:event_at_date]
      @event.event_at_time = build_params[:event_at_time]
      @event.deadline_at_date = build_params[:deadline_at_date]
      @event.deadline_at_time = build_params[:deadline_at_time]

      render :new
    end
  end


  private
  def format_date_string( date_string )
    date_string.gsub( /([0-9]+)年([0-9]+)月([0-9]+)日/, '\1/\2/\3' )
  end

  def event_params
    params.require(:event).permit(:name, :event_at_date, :event_at_time, :deadline_at_date, :deadline_at_time, :comment, :max_paticipants)
  end
end
