class Api::QuestionsController < Api::ApiController
  # Questions Controller
  ################
  
  def index
    @questions = Question.all
    render(
      json: @questions
    )
  end
end