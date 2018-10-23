class ResponsesController < ApplicationController
  before_action :get_question

  def index
    @responses = @question.responses
  end

  def show
    @response = @question.responses.find(params[:id])
  end

  def new
    @response = Response.new()
  end

  def create
    @response = @question.responses.new(response_params)
    if @response.save
      redirect_to question_responses_path(@question)
    end
  end

  private 

  def get_question
    @question = Question.find(params[:question_id])
  end
  
  def response_params
    params[:response].permit(:answer, :user)
   end
end
