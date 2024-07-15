class ArticlesController < ApplicationController
    before_action :authenticate_user!,except: [:show,:index]
    before_action :find_article,only: [:show,:edit,:update,:destroy]
    before_action :require_user,except: [:show,:index]
    before_action :authorize_user!,only: [:edit,:update,:destroy]
    before_action :only_admin,only:[:article_verification,:approve]

    def article_verification
        @articles = Article.draft
        render :index
    end
    def approve
        @article = Article.find(params[:id])
        if @article.update(status: :published)
          flash[:notice] = "Article has been approved and published."
        else
          flash[:alert] = "There was an error approving the article."
        end
        redirect_to  article_verification_articles_path
    end

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
    def filter
        
        @articles = Article.includes(:categories, :tags).where(status: :published).order(created_at: :desc)
        
        if params[:start_date].present? && params[:end_date].present?
          @articles = @articles.where(created_at: params[:start_date]..params[:end_date])
        end
        if params[:category_id].present?
          @articles = @articles.joins(:categories).where(categories: { id: params[:category_id] })
        end
     
        if params[:tag_id].present?
          @articles = @articles.joins(:tags).where(tags: { id: params[:tag_id] })
        end
     
        render :index
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
        params.require(:article).permit(:name,:description,:main_image,category_ids:[ ],tag_ids:[ ])
        
    end
    def  authorize_user!
        unless current_user == @article.user || current_user.is_admin?
            flash[:alert]="You are not authorized to edit this article."
            redirect_to articles_path(@articles)
        end
    end
    def only_admin
        unless current_user&.is_admin?
            flash[:alert]="You are not authorized for this action!"
            redirect_to root_path
        end
    end

end
