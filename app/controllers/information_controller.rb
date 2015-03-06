class InformationController < ApplicationController
  skip_before_action :check_logined
  before_action :check_admin, only: :admin
end
