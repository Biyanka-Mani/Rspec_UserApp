# shared_examples "successful users GET #index" do
#   before do
#     user.confirm 
#     sign_in user
#     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
#     get users_path
#   end
#   it_behaves_like "successful index"
# end
# shared_examples "successful index" do
#   before{ get users_path}
#   it_behaves_like "render_template",:index

#   it 'assigns @users' do
#     expect(assigns(:users)).to include(user, admin)
#   end
# end


shared_examples "restricted unauthorize users" do
  it "redirects to the root path" do
    expect(response).to redirect_to(root_path)
  end

  it "sets a flash alert" do
    expect(flash[:alert]).to eq("Only admins can perform that action")
  end
end