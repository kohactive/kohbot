class ResponsesController < ApplicationController
  before_action :get_question

  def index
    @responses = @question.responses
  end

  def edit
    @response = @question.responses.find(params[:id])
  end

  def update
    @response = Response.find(params[:id])
    @response.update(response_params)
    if @response.save
      redirect_to question_responses_path(@question)
    end
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
