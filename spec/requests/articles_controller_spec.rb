require 'rails_helper'

RSpec.describe "Articles", type: :request do

  let(:signed_in_user) { FactoryBot.create(:user) }
  let(:valid_attributes) { attributes_for(:article) }
  let(:invalid_attributes) { { name: " ", description: "" } }
  let(:category) { create(:category) }

 

  describe "GET #new" do
    context "when user is an author" do
      let(:user) { author }
      it_behaves_like "signed in user GET #new"
    end

  describe "GET #index" do
    it "assigns @articles" do
      all_articles = Article.all
      get articles_path
      # expect(response).to have_http_status(:success)
      expect(assigns(:articles)).to eq(all_articles)
    end
    it "renders the :index view" do
      get articles_path
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "assigns @article" do
      get new_article_path
      expect(assigns(:article)).to be_instance_of(Article)
    end
    it "renders the :new view" do
      get new_article_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "success" do
      it "adds new article to current_user" do
        articles_count = signed_in_user.articles.count
        post articles_path, params: { article: valid_attributes ,category: category }
        expect(signed_in_user.articles.count).to eq(articles_count + 1)
      end

      it "redirects to 'article_path' after successful create" do
        post articles_path,params: { article: valid_attributes }
        expect(response.status).to be(302)
        expect(response.location).to match(/\/articles\/\d+/)
      end
    end

    context "failure" do
      it "new article is not added to current_user" do
        articles_count = signed_in_user.articles.count
        post articles_path, params: { article: invalid_attributes }
        expect(signed_in_user.articles.count).not_to eq(articles_count + 1)
      end
      
      it "redirects to 'new_article_path' after unsuccessful create" do
        post articles_path,params: { article: invalid_attributes }
        expect(response).to render_template(:new)
      end
      
    end
  end

  describe "GET #show" do
    it "get the @article" do
      post articles_path,params: { article: valid_attributes }
      article=Article.last
      get article_path(article)
      expect(assigns(:article)).to eq(article)
    end
    it "renders the :show view" do
      post articles_path,params: { article: valid_attributes }
      article=Article.last
      get article_path(article)
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "get the @article" do
      post articles_path,params: { article: valid_attributes }
      article=Article.last
      get edit_article_path(article)
      expect(assigns(:article)).to eq(article)
    end
    it "renders the :edit view" do
      post articles_path,params: { article: valid_attributes }
      article=Article.last
      get edit_article_path(article)
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH or PUT #update" do
    
    before do 
      @current_article = FactoryBot.create(:article,user:signed_in_user) 
    end
    it "updated the @article" do
      form_params = {name: "new",description: "changed Patch applied title"}
      patch article_path(@current_article), params: { article: form_params }

      @current_article.reload 

      expect(@current_article.name).to eq('new')
      expect(@current_article.description).to eq('changed Patch applied title')
    end
    it "renders flash message and redirects to 'article_path' after successful updation" do
      form_params = {name: "new",description: "changed Patch applied title"}
      patch article_path(@current_article), params: { article: form_params }
      expect(flash[:notice]).to be_present
      expect(response.status).to be(302)
      expect(response.location).to match(/\/articles\/\d+/)
    end

    it "renders alert message and renders edit after unsucceesful article upadation" do
      form_params = {name:"",description: "df"}
      patch article_path(@current_article), params: { article: form_params }
      expect(flash[:alert]).to match(/Article is not Updated!*/)
      expect(response).to render_template(:edit)
    end
  end
 
  describe "DELETE #destroy" do
    let!(:new_article){FactoryBot.create(:article,user:signed_in_user)}
    
    it 'removes existing article from table' do
      expect {  delete article_path(new_article) }.to change { Article.count }.by(-1)
    end
    it 'renders index template' do
      delete article_path(new_article)
      expect(flash[:notice]).to match(/Article is Deleted succesfully*/)
      expect(response).to redirect_to(articles_path)
    end

  end

end
