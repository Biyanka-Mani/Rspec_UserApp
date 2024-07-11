require 'rails_helper'

RSpec.describe "Categories", type: :request do
  #let(:valid_attributes) { FactoryBot.create(:category) }
  let(:valid_attributes) { attributes_for(:tag) }
  let(:invalid_attributes) { { name_of_tag: '' } }
  let!(:tag) { create(:tag) }

 
  describe "GET /index" do
    it "returns http success" do
      get tags_path
      expect(response).to have_http_status(:success)
    end
    it "assigns @tags" do
      get  tags_path
      expect(assigns(:tags)).to eq([tag])
    end
    it "renders the :index view" do
      get tags_path
      expect(response).to render_template(:index)
    end
  end
  describe "GET #new" do
    it "assigns @tag" do
      get new_tag_path
      expect(assigns(:tag)).to be_instance_of(Tag)
    end
    it "renders the :new view" do
      get new_tag_path
      expect(response).to render_template(:new)
    end
  end
  
  # describe "POST #create" do
  #   context "success" do
  #     it "adds new tag to a list of tag " do
  #       expect {
  #         post categories_path,params: { category: valid_attributes  }
  #       }.to change(Category, :count).by(1)
  #     end

  #     it "redirects to 'category_path,' after successful create" do
  #       post categories_path,  params: { category: valid_attributes }
  #       expect(response.status).to be(302)
  #       expect(response.location).to match(/\/categories\/\d+/)
  #     end
  #   end

  #   context "failure" do
  #     it "new article is not added to current_user" do
  #       expect {
  #         post categories_path, params: { category: invalid_attributes }
  #       }.to change(Category, :count).by(0)
  #     end
      
  #     it "redirects to 'new_category_path' after unsuccessful create" do
  #       post categories_path, params: { category: invalid_attributes }
  #       expect(response).to render_template(:new)
  #     end
      
  #   end
  # end

  # describe "GET #show" do
  #   it "test category that the same as category passed " do      
  #     get category_path(category)
  #     expect(assigns(:category)).to eq(category)  
  #   end
  #   it "get the all articles " do      
  #     get category_path(category)
  #     expect(assigns(:articles)).to eq(category.articles)  
  #   end
  #   it "renders the :show view" do
  #     get category_path(category)
  #     expect(response).to render_template(:show)
  #   end
  # end

  # describe "GET #edit" do
  #   it "get the @article" do
  #     get edit_category_path(category)
  #     expect(assigns(:category)).to eq(category)
  #   end
  #   it "renders the :edit view" do
  #     get edit_category_path(category)
  #     expect(response).to render_template(:edit)
  #   end
  # end

  # describe "PATCH or PUT #update" do
  #   context 'with valid parameters' do
  #     let(:new_attributes) { { name_of_category: 'Updated Name' } }
  #     it "updated the @article" do
  #       patch category_path(category), params: { category: new_attributes }
  #       category.reload 
  #       expect(category.name_of_category).to eq('Updated Name')
  #     end
  #     it "renders flash message and redirects to 'article_path' after successful updation" do
  #       patch category_path(category),  params: { category: new_attributes }
  #       category.reload 
  #       expect(flash[:notice]).to be_present
  #       expect(response.status).to be(302)
  #       expect(response.location).to match(/\/categories\/\d+/)
  #     end

  #     it "renders alert message and renders edit after unsucceesful article upadation" do
  #       patch category_path(category),  params: { category: invalid_attributes }
  #       category.reload 
  #       expect(flash[:alert]).to match(/Category Updation Error Occured!*/)
  #       expect(response).to render_template(:edit)
  #     end
  #   end
  # end
 
  # describe "DELETE #destroy" do
    
  #   it 'removes existing category from table' do
  #     expect {  delete category_path(category) }.to change { Category.count }.by(-1)
  #   end
  #   it 'renders index template' do
  #     delete category_path(category)
  #     expect(flash[:notice]).to match(/Article is Deleted succesfully*/)
  #     expect(response).to redirect_to(categories_path)
  #   end

  # end

end

