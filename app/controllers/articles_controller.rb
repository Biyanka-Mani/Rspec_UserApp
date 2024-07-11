class ArticlesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_article,only: [:show,:edit,:update,:destroy]
    def index 
        @articles=Article.all
    end
    def new
        @article=Article.new
    end
    def create 
        @article = current_user.articles.new(articles_params)
        if @article.save
            flash[:notice]="Article is saved successfully"
            redirect_to article_path(@article)
        else
            render :new, status: :unprocessable_entity
        end
    end
    def  show
        
    end
    def edit
       
    end
    def update
      
        if @article.update(articles_params)
            flash[:notice]="Article is updated succesfully"
            redirect_to article_path(@article)
        else
            flash[:alert]="Article is not Updated!"
            render :edit, status: :unprocessable_entity
        end

    end
    def destroy
        @article.destroy
        flash[:notice]="Article is Deleted succesfully"
        redirect_to articles_path 
    end


    private 
    def find_article
        @article=Article.find(params[:id])
    end
    def articles_params
        params.require(:article).permit(:name,:description,category_ids:[ ])
        
    end

end
