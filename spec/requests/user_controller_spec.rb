require 'rails_helper'

RSpec.describe "Users", type: :request do
  # let!(:user) { FactoryBot.create(:user) }
  let!(:author) { FactoryBot.create(:user) }
  let!(:non_author) { FactoryBot.create(:user) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:articles) { FactoryBot.create_list(:article, 5, user: author) }
 

  describe 'GET #index' do
    context "when user is admin" do
      before{ 
      sign_in admin 
      admin.confirm 
      get users_path }

      it_behaves_like "render_template",:index
      it 'assigns @users' do
        expect(assigns(:users)).to include(author, non_author)
      end
    end
    context "when user is non-admin signined user" do
      before{ 
      sign_in author 
      author.confirm 
      get users_path }

      it_behaves_like "restricted unauthorize users"
    end
    context "when user is not signed in" do
      before { get users_path }  

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context "when user is admin" do
      before{ 
        sign_in admin 
        admin.confirm }
  
      it 'removes existing article from table' do
        expect {  delete user_path(author) }.to change { User.count }.by(-1)
      end
      it 'renders index template' do
        delete user_path(author)
        expect(flash[:notice]).to match(/User was successfully deleted*/)
        expect(response).to redirect_to(users_path)
      end
      
    end
    context "when user is non-admin signined user" do
      before{ 
      sign_in author 
      author.confirm
      delete user_path(author)}

      it_behaves_like "restricted unauthorize users"
    end
    context "when user is not signed in" do
      before { delete user_path(author)  }  

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
  describe 'GET #SHOW' do
    context "when user is signedin user" do
        before{ 
        sign_in author 
        author.confirm 
        get user_path(author), params: { page: 1 }
      }
      it 'assigns @articles and paginates the articles' do
        expect(assigns(:articles)).to eq(author.articles.paginate(page: 1, per_page: 2))
      end

      it 'total count' do
        expect(assigns(:articles).count).to eq(5)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    
    end
    context "when user is not signed in" do
      before { get user_path(author)  }  

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end


end
