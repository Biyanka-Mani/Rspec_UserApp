require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:article) { create(:article, user: author) }
 
    describe 'POST /articles/:article_id/like' do
      context 'when user is not the author' do
        before do
          user.confirm 
          sign_in user
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        end
        it 'creates a like and redirects to the article' do
          expect {
            post article_like_path(article)
          }.to change(Like, :count).by(1)
          expect(response).to redirect_to(article_path(article))
          expect(flash[:notice]).to eq('Article liked.')
        end
        it 'does not create a like if already liked' do
          Like.create(user: user, article: article)
          expect {
            post article_like_path(article)
          }.not_to change(Like, :count)
          expect(response).to redirect_to(article_path(article))
          expect(flash[:alert]).to eq('Unable to like article.')
        end
      end
      context 'when user is the author' do
        before do
        author.confirm 
          sign_in author
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
        end
        it 'does not create a like and shows an alert' do
          expect {
            post article_like_path(article)
          }.not_to change(Like, :count)
          expect(response).to redirect_to(article_path(article))
          expect(flash[:alert]).to eq('You cannot like your own article.')
        end
      end
      context "when user is not signed in" do
        before { post article_like_path(article) }  
        it "redirects to the sign in page" do
          expect(response).to redirect_to(user_session_path)
        end
      end
    end
    describe 'DELETE /articles/:article_id/like' do
      context 'when user is not the author' do
        before do
          user.confirm 
          sign_in user
          allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
        end
        context 'when user has liked the article' do
          before{Like.create(user: user, article: article)}
          it 'destroys the like and redirects to the article' do
            expect {
              delete article_like_path(article)
            }.to change(Like, :count).by(-1)
            expect(response).to redirect_to(article_path(article))
            expect(flash[:notice]).to eq('Article unliked.')
          end
        end
    
        context 'when user has not liked the article' do
          it 'does not change the like count and shows an alert' do
            expect {
              delete article_like_path(article)
            }.not_to change(Like, :count)
            expect(response).to redirect_to(article_path(article))
            expect(flash[:alert]).to eq('You have not liked this article.')
          end
        end
      end
      context 'when user is the author' do
        before do
          author.confirm 
            sign_in author
            allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(author)
        end
        it 'does not create a delete like ' do
          expect { post article_like_path(article)}.not_to change(Like, :count)
          expect(response).to redirect_to(article_path(article))
        end
      end
      context "when user is not signed in" do
        before { delete article_like_path(article) }  
        it "redirects to the sign in page" do
          expect(response).to redirect_to(user_session_path)
        end
      end
    end
end
