RSpec.shared_examples "render_template" do |action_name|
  it "renders the #{action_name} template" do
    expect(response).to render_template(action_name)
  end
end