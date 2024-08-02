require 'rails_helper'

RSpec.describe "Articles", type: :request do

  let(:author) { FactoryBot.create(:user) }
  let(:non_author) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:article) { FactoryBot.create(:article,user:author) } 
  let(:valid_attributes) { attributes_for(:article) }
  let(:invalid_attributes) { { name: " ", description: "" } }
  let(:category) { create(:category) }
  let(:category2) { create(:category) }
  let(:tag) { create(:tag) }
  let(:tag2) { create(:tag) }
 
 

  describe "GET #new" do
    context "when user is an author" do
      let(:user) { author }
      it_behaves_like "signed in user GET #new"
    end
    context "when user is a non-author" do
      let(:user) { non_author }
      it_behaves_like "signed in user GET #new"
    end
    context "when user is an admin" do
      let(:user) { admin }
      it_behaves_like "signed in user GET #new"
    end
    context "when user is not signed in" do
      before { get new_article_path }  

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #edit" do
    context "when user is an author" do
      let(:user) { author }
      it_behaves_like "signed in user GET #edit"
    end
    context "when user is a non-author" do
      let(:user) { non_author }
      it_behaves_like "non author GET #edit"
 
    end
    context "when user is an admin" do
      let(:user) { admin }
      it_behaves_like "signed in user GET #edit"
    end
    context "when user is not signed in" do
      before { get edit_article_path(article) }

      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #create" do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
      author.confirm
    end
    context "success" do
      before { sign_in author }
      it "adds new article to current_user" do
        articles_count = author.articles.count
        post articles_path, params: { article: valid_attributes ,category_ids: [category.id, category2.id],tag_ids:[tag.id,tag2.id] }
        expect(author.articles.count).to eq(articles_count + 1)
      end
      it "redirects to 'article_path' after successful create" do
        post articles_path,params: { article: valid_attributes }
        expect(response.status).to be(302)
        expect(response.location).to match(/\/articles\/\d+/)
      end
    end
    context "failure" do
      before { sign_in author }
      it "new article is not added to current_user" do
        articles_count = author.articles.count
        post articles_path, params: { article: invalid_attributes }
        expect(author.articles.count).not_to eq(articles_count + 1)
      end
      it "redirects to 'new_article_path' after unsuccessful create" do
        post articles_path,params: { article: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
    context "when user is not signed in" do
      before { post articles_path,params: { article: valid_attributes } }  

      it "redirects to the sign in page" do
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "PATCH or PUT #update" do
    context "when user signedin and is owning the article" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
        author.confirm
        sign_in author 
      end
      context "success" do
        before {   
          form_params = {name: "new",description: "changed Patch applied title"}
          patch article_path(article), params: { article: form_params,user:author }
          article.reload }

        it "updated the @article" do
          expect(article.name).to eq('new')
          expect(article.description).to eq('changed Patch applied title')
        end
        it "renders flash message and redirects to 'article_path' after successful updation" do
          expect(flash[:notice]).to be_present
          expect(response.status).to be(302)
          expect(response.location).to match(/\/articles\/\d+/)
        end
      end
      context "failure" do
        before {  
          form_params = {name:"",description: "df"}
          patch article_path(article), params: { article: form_params }
          article.reload
        }
        it "renders alert message and renders edit after unsucceesful article upadation" do
          expect(flash[:alert]).to match(/Article is not Updated!*/)
          expect(response).to render_template(:edit)
        end
      end
    end
    context "when user signedin and not owning the article " do 
      before{     
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(non_author)
      non_author.confirm
      sign_in non_author
      form_params = {name: "new",description: "changed Patch applied title"}
      patch article_path(article), params: { article: form_params,user:author }}
      it_behaves_like "restricted unauthorize users for articles"
    end
    context "when user is not signed in" do
      before { post articles_path,params: { article: valid_attributes } }  
      it "redirects to the sign in page" do
        expect(response).to redirect_to(user_session_path)
      end
    end
  end
 
  describe "DELETE #destroy" do
    let!(:article) { FactoryBot.create(:article, user: author) }
    context "when user signedin and is owning the article" do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
        author.confirm
        sign_in author 
        end
      it 'removes existing article from table' do
        expect {  delete article_path(article) }.to change { Article.count }.by(-1)
      end
      it 'renders index template' do
        delete article_path(article)
        expect(flash[:notice]).to match(/Article is Deleted succesfully*/)
        expect(response).to redirect_to(articles_path)
      end
    end
    context "when user signedin and not owning the article " do 
      before{     
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(non_author)
        non_author.confirm 
        sign_in non_author
        delete article_path(article)}
     it_behaves_like "restricted unauthorize users for articles"

    end
    context "when user is admin " do 
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
        admin.confirm
        sign_in admin 
        end
      it 'removes existing article from table' do
        expect {  delete article_path(article) }.to change { Article.count }.by(-1)
      end
      it 'renders index template' do
        delete article_path(article)
        expect(flash[:notice]).to match(/Article is Deleted succesfully*/)
        expect(response).to redirect_to(articles_path)
      end
    end
    context "when user is not signed in" do
      before {  delete article_path(article)}  
      it "redirects to the sign in page" do
        expect(response).to redirect_to(user_session_path)
      end
    end
  end

  describe "GET #index" do
    before {get articles_path}
    it "assigns @articles" do
      all_articles = Article.all
      expect(assigns(:articles)).to eq(all_articles)
    end
    it_behaves_like "render_template", :index
  end
  describe "GET #show" do
    before{ get article_path(article)}
    it "get the @article" do
      expect(assigns(:article)).to eq(article)
    end
    it_behaves_like "render_template", :show
  end

  describe 'GET #article_verification' do
    let!(:draft_articles) { FactoryBot.create_list(:article, 3, status: :draft, user:author) }
    let(:published_articles) { FactoryBot.create_list(:article, 2, status: :published, user:author) }

    context "when user is an author" do
      before do
        admin.confirm 
        sign_in admin
        get article_verification_articles_path
      end
      it 'assigns @articles with draft articles' do
        expect(assigns(:articles)).to eq(draft_articles)
      end
    
      it 'does not include published articles in @articles' do
        expect(assigns(:articles)).not_to include(*published_articles)
      end
    
      it 'renders the index template' do
        expect(response).to render_template(:index)
      end
    end
    
  end

  describe 'POST #approve' do
    let!(:draft_article) { FactoryBot.create(:article, status: :draft, user:author) }

    context 'when user is admin' do
      before do
        admin.confirm 
        sign_in admin
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
        post approve_article_path(draft_article)
      end

      it 'updates the article status to published' do
        draft_article.reload
        expect(draft_article.status).to eq('published')
      end

      it 'sets a flash notice' do
        expect(flash[:notice]).to eq('Article has been approved and published.')
      end

      it 'redirects to article_verification path' do
        expect(response).to redirect_to(article_verification_articles_path)
      end
    end

    context 'when the article fails to update' do
      before do
        admin.confirm 
        sign_in admin
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
        allow_any_instance_of(Article).to receive(:update).and_return(false)
        post approve_article_path(draft_article)
      end

      it 'sets a flash alert' do
        expect(flash[:alert]).to eq('There was an error approving the article.')
      end

      it 'redirects to article_verification path' do
        expect(response).to redirect_to(article_verification_articles_path)
      end
    end

    context 'when user is not admin' do
      before do
        author.confirm
        sign_in author
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
        allow_any_instance_of(Article).to receive(:update).and_return(false)
        post approve_article_path(draft_article)
      end

      it 'sets a flash alert' do
        expect(flash[:alert]).to eq('You are not authorized for this action!')
      end

      it 'redirects to article_verification path' do
        expect(response).to redirect_to(root_path)
      end
    end 
  end
  describe 'GET #filter' do
  let!(:category) { FactoryBot.create(:category) }
  let!(:tag) { FactoryBot.create(:tag) }
  let!(:article1) { FactoryBot.create(:article, :published, categories: [category], tags: [tag], created_at: 1.day.ago) }
  let!(:article2) { FactoryBot.create(:article, :published, created_at: 2.days.ago) }
  let!(:draft_article) { FactoryBot.create(:article, status: :draft) }

  before do
    non_author.confirm
    sign_in non_author
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(non_author)
    get filter_articles_path, params: params
  end

  context 'without any filters' do
    let(:params) { {} }

    it 'assigns @articles with all published articles' do
      expect(assigns(:articles)).to match_array([article1, article2])
    end
  end

  context 'with date filters' do
    let(:params) { { start_date: 2.days.ago.to_date, end_date: Time.zone.today } }

    it 'filters articles by created_at date range' do
      expect(assigns(:articles)).to match_array([article1, article2])
    end
  end

  context 'with category filter' do
    let(:params) { { category_id: category.id } }

    it 'filters articles by category' do
      expect(assigns(:articles)).to match_array([article1])
    end
  end

  context 'with tag filter' do
    let(:params) { { tag_id: tag.id } }

    it 'filters articles by tag' do
      expect(assigns(:articles)).to match_array([article1])
    end
  end
end



end
