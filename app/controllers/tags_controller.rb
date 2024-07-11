class TagsController < ApplicationController
  before_action :find_tag,only: [:show,:edit,:update,:destroy]
  def index
    @tags=Tag.all
  end

  def show
    @articles=@tag.articles
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag=Tag.create(tag_params)
    if @tag.save
        flash[:notice]="Tag Created Successfully"
        redirect_to tag_path(@tag)
    else
        flash.now[:alert]="Tag Creation Error Occured"
        render :new,status: :unprocessable_entity
    end
  end

  def edit
        
  end
  def update
    if @tag.update(tag_params)
      flash[:notice]="Tag is Updated"
      redirect_to tag_path(@tag)
    else
      flash[:alert]="Tag Updation Error Occured"
      render :edit,status: :unprocessable_entity
    end
end
  def destroy
    @tag.destroy
    flash[:notice]="Tag is Deleted succesfully"
    redirect_to tags_path 
  end

      

  private 

    def tag_params
        params.require(:tag).permit(:name_of_tag)
    end
    def find_tag
        @tag=Tag.find(params[:id])
    end
end


