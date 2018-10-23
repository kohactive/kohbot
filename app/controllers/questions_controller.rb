class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    redirect_to question_responses_path(@question)
  end

  private 
  
  def question_params
    params[:question].permit(:question)
   end
end
