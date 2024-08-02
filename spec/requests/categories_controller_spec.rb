require 'rails_helper'

RSpec.describe "Categories", type: :request do
  #let(:valid_attributes) { FactoryBot.create(:category) }
  let(:valid_attributes) { attributes_for(:category) }
  let(:invalid_attributes) { { name_of_category: '' } }
  let!(:articles) { create_list(:article, 3, categories: [category]) }
  let!(:category) { create(:category) }

  let(:non_admin) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }
 
  describe "GET /index" do
    before{ get categories_path}
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @categories" do
      expect(assigns(:categories)).to eq([category])
    end
    it_behaves_like "render_template",:index
  end
  describe "GET #new" do
    context "when user is admin" do
      before{ 
      sign_in admin 
      admin.confirm 
      get new_category_path }
      
      it "assigns @category" do
        expect(assigns(:category)).to be_instance_of(Category)
      end
      it "renders the :new view" do
        expect(response).to render_template(:new)
      end
      it_behaves_like "render_template",:new
    end
    context "when user is not admin"do
      before{ 
        sign_in non_admin
        non_admin.confirm 
        get new_category_path }
      it 'redirects to categories_path with an alert' do
        expect(response).to redirect_to(categories_path)
        expect(flash[:alert]).to match(/Only admins can perform that action/)
      end
    end
  end
  
  describe "GET #show" do
    before{ get category_path(category)}
    it "test category that the same as category passed " do      
      expect(assigns(:category)).to eq(category)  
    end
    it "get the all articles " do      
      expect(assigns(:articles)).to eq(category.articles)  
    end
    it "renders the :show view" do
      expect(response).to render_template(:show)
    end
  end
  describe "POST #create" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      context "success" do
        it "adds new category to a list of category " do
          expect {
            post categories_path,params: { category: valid_attributes  }
          }.to change(Category, :count).by(1)
        end

        it "redirects to 'category_path,' after successful create" do
          post categories_path,  params: { category: valid_attributes }
          expect(response.status).to be(302)
          expect(response.location).to match(/\/categories\/\d+/)
        end
      end

      context "failure" do
        it "new article is not added to current_user" do
          expect {
            post categories_path, params: { category: invalid_attributes }
          }.to change(Category, :count).by(0)
        end
        
        it "redirects to 'new_category_path' after unsuccessful create" do
          post categories_path, params: { category: invalid_attributes }
          expect(response).to render_template(:new)
        end
        
      end
    end
    context "when ordinary user is signed in" do 
      before{ 
        sign_in non_admin 
        non_admin.confirm 
        post categories_path,params: { category: valid_attributes  }}
        it 'redirects to categories_path with an alert' do
          expect(response).to redirect_to(categories_path)
          expect(flash[:alert]).to match(/Only admins can perform that action/)
        end
    end
  end



  describe "GET #edit" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm 
        get edit_category_path(category)}
      it "get the @article" do
        expect(assigns(:category)).to eq(category)
      end
      it "renders the :edit view" do
        expect(response).to render_template(:edit)
      end
    end
    context "when ordinary user is signed in" do 
      before{ 
        sign_in non_admin 
        non_admin.confirm 
        post categories_path,params: { category: valid_attributes  }}
        it 'redirects to categories_path with an alert' do
          expect(response).to redirect_to(categories_path)
          expect(flash[:alert]).to match(/Only admins can perform that action/)
        end
    end
  end

  describe "PATCH or PUT #update" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      context 'with valid parameters' do
        let(:new_attributes) { { name_of_category: 'Updated Name' } }
        it "updated the @article" do
          patch category_path(category), params: { category: new_attributes }
          category.reload 
          expect(category.name_of_category).to eq('Updated Name')
        end
        it "renders flash message and redirects to 'article_path' after successful updation" do
          patch category_path(category),  params: { category: new_attributes }
          category.reload 
          expect(flash[:notice]).to be_present
          expect(response.status).to be(302)
          expect(response.location).to match(/\/categories\/\d+/)
        end

        it "renders alert message and renders edit after unsucceesful article upadation" do
          patch category_path(category),  params: { category: invalid_attributes }
          category.reload 
          expect(flash[:alert]).to match(/Category Updation Error Occured!*/)
          expect(response).to render_template(:edit)
        end
      end
    end
  end
 
  describe "DELETE #destroy" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      it 'removes existing category from table' do
        expect {  delete category_path(category) }.to change { Category.count }.by(-1)
      end
      it 'renders index template' do
        delete category_path(category)
        expect(flash[:notice]).to match(/Article is Deleted succesfully*/)
        expect(response).to redirect_to(categories_path)
      end
    end
    context "when ordinary user is signed in" do 
      before{ 
        sign_in non_admin 
        non_admin.confirm 
        delete category_path(category)}
        it 'redirects to categories_path with an alert' do
          expect(response).to redirect_to(categories_path)
          expect(flash[:alert]).to match(/Only admins can perform that action/)
        end
    end

  end


  

end
