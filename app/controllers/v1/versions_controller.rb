class V1::VersionsController < ApplicationController
  skip_before_action :authenticate_request!

  def latest
    @latest = Version.last
    render json: @latest
  end
end
