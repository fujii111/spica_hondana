class PropertyController < ApplicationController
  before_action :check_admin

  def show
    @property = Property.find(1)
  end

  def edit
    @property = Property.find(1)
  end

  def update
    property_params = params.require(:property).permit(:inquiry_mail, :clickpost_url, :request_limit, :default_point)
    @property = Property.find(1)
    if @property.update(property_params)
      redirect_to action: "show"
    else
      render action: "edit"
    end
  end

end
