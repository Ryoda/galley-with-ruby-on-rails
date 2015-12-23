class ArticlesController < ApplicationController

	before_action :set_article, except: [:index, :new, :create]
	#authentications 
	before_action :authenticate_user!, except: [:show, :index]
	before_action :authenticate_moderator!, only:[:delete, :destroy]
	before_action :authenticate_admin!, only:[:publish, :destroy]
	def index
		@articles = Article.paginate(page: params[:page], per_page: 15).publicados.ultimos
	end
	def show
		@article.update_visits_count
		@comments = Comment.paginate(page: params[:page], per_page: 10).where(article_id: @article.id)
		@comment = Comment.new
	end
	def new
		@article = Article.new 
		@tags = Tag.all
	end
	def create
		@article = current_user.articles.new(article_params)
		@article.tags = params[:tags]
		if @article.save
			redirect_to @article
		else
			@tags = Tag.all
			render :new
		end
	end
	def edit
		@tags = Tag.all
	end
	def update
		if @article.update(article_params)
			redirect_to @article
		else
			@tags = Tag.all
			render :edit
		end
	end
	def publish
		@article.publish!
		redirect_to @article
	end
	def destroy
		@article.destroy
		redirect_to articles_path
	end

	private

	def article_params
		params.require(:article).permit(:title, :cover, :body)
	end
	def set_article
		@article = Article.find(params[:id])
	end

end