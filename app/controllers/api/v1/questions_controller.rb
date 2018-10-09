class Api::V1::QuestionsController < Api::V1::ApiController
  # Questions Controller
  ################
  
  def index
    render(
      json: Question.all
    )
  end
end