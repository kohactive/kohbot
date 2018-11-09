class Api::V1::BotsController < Api::V1::ApiController
  # Bot Controller
  ################

  def index
    render :json => { test: "ok"}, :status => :ok    
  end

  def create
    @token = JSON.parse(params[:challenge])
    if @token
      render :json => {challenge: @token}, :status => :ok     
    else
      render :status => :not_implemented
    end
  end
end