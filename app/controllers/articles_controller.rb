class ArticlesController < ApplicationController
	#before_action :validate_user, except: [:show,:index]
	#before_action :authenticate_user!, only: [:create,:new]
	before_action :authenticate_user!, except: [:show,:index]
	before_action :set_article, except: [:index,:new,:create]
	before_action :authenticate_editor!, only: [:new,:create,:update]
	before_action :authenticate_admin!,only: [:destroy,:publish]

	#GET /articles
	def index
		# Todos registros SELECT * FROM articles
		#@articles = Article.all
		#@articles = Article.where(state: "published")
		#@articles = Article.published
		#@articles = Article.publicados
		#@articles = Article.publicados.ultimos
		@articles = Article.paginate(page: params[:page],per_page:5).publicados.ultimos
	end

	#GET /articles/:id
	def show
		#Encontrar un registro por id
		#@article = Article.find(params[:id])
		#where
		#Article.where( " body LIKE ? ", "%mundo%")		
		#Article.where( " id = ? AND title = ? ", params[:id],params[:title])		
		#Article.where( " id = ? OR title = ? ", params[:id],params[:title])		
		#Article.where.not("id = ?", params[:id])
		@article.update_visits_count
		@comment = Comment.new
	end

	#GET /articles/new
	def new
		@article = Article.new
		@categories = Category.all
	end	

	def edit
		#@article = Article.find(params[:id])
	end

	#POST /articles
	def create
		#INSERT INTO
		#@article = Article.new(title: params[:article][:title],
		#						body: params[:article][:body])
		
		#@article = Article.new(article_params)
		
		@article = current_user.articles.new(article_params)
		#raise params.to_yaml
		@article.categories = params[:categories]

		if @article.save
			redirect_to @article
		else
			render :new
		end
	end

	#DELETE /articles/:id
	def destroy
		#DELETE FROM articles
		#@article = Article.find(params[:id])
		@article.destroy	#Destroy elimina el objeto de la BD

		redirect_to articles_path		
	end

	#PUT /articles/:id
	def update
		# UPDATE
		# @article.update_attributes({title: 'Nuevo titulo'})
		#@article = Article.find(params[:id])
		if @article.update(article_params)
			redirect_to @article
		else
			render :edit
		end
	end

	def publish
		@article.publish!
		redirect_to @article
	end

	private

	def validate_user
		redirect_to new_user_session_path, notice: "Necesitas iniciar sesión"
	end

	def set_article
		@article = Article.find(params[:id])
	end

	def article_params
		params.require(:article).permit(:title,:body,:cover,:categories)
	end
	
end