class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    redirect_to questions_path()
  end


  def destroy
    Question.destroy(params[:id])
    redirect_to questions_path()
  end

  private 
  
  def question_params
    params[:question].permit(:question).merge(user: User.first)
   end
end
