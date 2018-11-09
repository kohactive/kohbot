class Api::V1::BotsController < Api::V1::ApiController
  # Bot Controller
  ################
  skip_before_action :verify_authenticity_token  

  def index
    render :json => { test: "ok"}, :status => :ok    
  end

  def create
    response = params[:challenge]
    if response
      render :json => {challenge: response}, :status => :ok     
    else
      render :json => {message: "error"}, :status => :not_implemented
    end
  end
end