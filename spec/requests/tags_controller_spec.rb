require 'rails_helper'

RSpec.describe "Tags", type: :request do
  #let(:valid_attributes) { FactoryBot.create(:category) }
  let(:valid_attributes) { attributes_for(:tag) }
  let(:invalid_attributes) { { name_of_tag: '' } }
  let!(:articles) { create_list(:article, 3, tags: [tag]) }
  let!(:tag) { create(:tag) }

  let(:non_admin) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }

  describe "GET /index" do
    before{get tags_path}
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end
    it "assigns @tags" do
      expect(assigns(:tags)).to eq([tag])
    end
    it "renders the :index view" do
      expect(response).to render_template(:index)
    end
  end
  describe "GET #new" do
    context "when user is admin" do
      before{ 
      sign_in admin 
      admin.confirm 
      get new_tag_path }
      
      it "assigns @tag" do
        expect(assigns(:tag)).to be_instance_of(Tag)
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
  
  
  
  describe "POST #create" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      context "success" do
        it "adds new tag to a list of tag " do
          expect {
            post tags_path,params: { tag: valid_attributes  }
          }.to change(Tag, :count).by(1)
        end

        it "redirects to 'tag_path,' after successful create" do
          post tags_path,params: { tag: valid_attributes  }
          expect(response.status).to be(302)
          expect(response.location).to match(/\/tags\/\d+/)
        end
      end

      context "failure" do
        it "new tag is not added to current_user" do
          expect {
            post tags_path, params: { tag: invalid_attributes }
          }.to change(Tag, :count).by(0)
        end
        
        it "redirects to 'new_tag_path' after unsuccessful create" do
          post  tags_path, params:  { tag: invalid_attributes }
          expect(response).to render_template(:new)
        end
        
      end
    end
    context "when ordinary user is signed in" do 
      before{ 
        sign_in non_admin 
        non_admin.confirm 
        post tags_path,params: { tag: valid_attributes  }}
        it 'redirects to tags_path with an alert' do
          expect(response).to redirect_to(tags_path)
          expect(flash[:alert]).to match(/Only admins can perform that action/)
        end
    end
  end

  describe "GET #show" do
    before{get tag_path(tag)}
    it "test tag that the same as tag passed " do      
      expect(assigns(:tag)).to eq(tag)  
    end
    it "get the all articles " do      
      expect(assigns(:articles)).to eq(tag.articles)  
    end
    it "renders the :show view" do
      expect(response).to render_template(:show)
    end
  end

  describe "DELETE #destroy" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      it 'removes existing tag from table' do
        expect {  delete tag_path(tag) }.to change { Tag.count }.by(-1)
      end
      it 'renders index template' do
        delete tag_path(tag)
        expect(flash[:notice]).to match(/Tag is Deleted succesfully*/)
        expect(response).to redirect_to(tags_path)
      end
    end
    context "when ordinary user is signed in" do 
      before{ 
        sign_in non_admin 
        non_admin.confirm 
        delete tag_path(tag)}
        it 'redirects to categories_path with an alert' do
          expect(response).to redirect_to(tags_path)
          expect(flash[:alert]).to match(/Only admins can perform that action/)
        end
    end
  end

  describe "GET #edit" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      it "get the @article" do
        get edit_tag_path(tag)
        expect(assigns(:tag)).to eq(tag)
      end
      it "renders the :edit view" do
        get edit_tag_path(tag)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH or PUT #update" do
    context 'when admin user is signed in' do
      before{ 
        sign_in admin 
        admin.confirm }
      context 'with valid parameters' do
        let(:new_attributes) { { name_of_tag: 'Updated Name' } }
        it "updated the @article" do
          patch tag_path(tag), params: { tag: new_attributes }
          tag.reload 
          expect(tag.name_of_tag).to eq('Updated Name')
        end
        it "renders flash message and redirects to 'article_path' after successful updation" do
          patch tag_path(tag),  params: { tag: new_attributes }
          tag.reload 
          expect(flash[:notice]).to be_present
          expect(response.status).to be(302)
          expect(response.location).to match(/\/tags\/\d+/)
        end

        it "renders alert message and renders edit after unsucceesful article upadation" do
          patch tag_path(tag),  params: { tag: invalid_attributes }
          tag.reload 
          expect(flash[:alert]).to match(/Tag Updation Error Occured!*/)
          expect(response).to render_template(:edit)
        end
      end
    end
  end
 
 

end

