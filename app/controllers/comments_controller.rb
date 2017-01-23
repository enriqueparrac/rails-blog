class CommentsController < ApplicationController
  #before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy, :show]
  before_action :set_article
  before_action :authenticate_user!

  def show
  end
=begin
  respond_to :html

  def index
    @comments = Comment.all
    respond_with(@comments)
  end

  def show
    respond_with(@comment)
  end

  def new
    @comment = Comment.new
    respond_with(@comment)
  end

  def edit
  end
=end

  def create
    #@comment = Comment.new(comment_params)
    @comment = current_user.comments.new(comment_params)
    @comment.article = @article

    @comment.save
    #respond_with(@comment)
    redirect_to @comment.article
  end

  def update
    @comment.update(comment_params)
    #respond_with(@comment)
    redirect_to @comment.article
  end

  def destroy
    @comment.destroy
    #respond_with(@comment)
    redirect_to @article
  end

  private
    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:user_id, :article_id, :body)
    end
end
