class ParticipantsController < ApplicationController
  before_filter :redirect_login_page_unless_logged_in
end
