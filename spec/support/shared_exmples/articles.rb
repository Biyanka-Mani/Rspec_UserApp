RSpec.shared_examples "successful GET #new" do
  it "assigns @article" do
    expect(assigns(:article)).to be_instance_of(Article)
  end
  it_behaves_like "render_template", :new
end
shared_examples "signed in user GET #new" do
  before do
    user.confirm 
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    get new_article_path
  end
  it_behaves_like "successful GET #new"
end
#edit

shared_examples "signed in user GET #edit" do
  before do
    user.confirm 
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    get edit_article_path(article)
  end
  it_behaves_like "successful GET #edit"
end
shared_examples "non author GET #edit" do
  before do
    user.confirm 
    sign_in user
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    get edit_article_path(article)
  end
  it_behaves_like "restricted unauthorize users for articles"

end

shared_examples "successful GET #edit" do
    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "assigns @article" do
      expect(assigns(:article)).to eq(article)
    end
end
#restrication of unauthorized users

shared_examples "restricted unauthorize users for articles" do
  it "redirects to the articles_path path" do
    expect(response).to redirect_to(articles_path)
  end

  it "sets a flash alert" do
    expect(flash[:alert]).to eq("You are not authorized to edit this article.")
  end
end
#approval
shared_examples "signed user vertification author" do
 
end

