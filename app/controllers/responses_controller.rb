class ResponsesController < ApplicationController

  def index
    @question = Question.find(params[:question_id])
    @responses = @question.responses
  end

  def show
    @question = Question.find(params[:question_id])
    @response = @question.responses.find(params[:id])
  end

  private 
  
  def question_params
    params[:question].permit(:question)
   end
end
