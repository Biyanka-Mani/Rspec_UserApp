class CategoriesController < ApplicationController
  before_action :find_category,only: [:show,:edit,:update,:destroy]
  def index
    @categories=Category.all
  end

  def show
    @articles=@category.articles
  end

  def new
    @category = Category.new
  end

  def create
    @category=Category.create(category_params)
    if @category.save
        flash[:notice]="Category Created Successfully"
        redirect_to category_path(@category)
    else
        flash.now[:alert]="Category Creation Error Occured"
        render :new,status: :unprocessable_entity
    end
  end

  def edit
        
  end
  def update
    if @category.update(category_params)
      flash[:notice]="Category is Updated"
      redirect_to category_path(@category)
  else
    flash[:alert]="Category Updation Error Occured"
      render :edit,status: :unprocessable_entity
  end
end
  def destroy
    @category.destroy
    flash[:notice]="Article is Deleted succesfully"
    redirect_to categories_path 
  end

      

  private 

    def category_params
        params.require(:category).permit(:name_of_category)
    end
    def find_category
        @category=Category.find(params[:id])
    end
end
