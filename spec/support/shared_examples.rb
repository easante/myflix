shared_examples "require_redirect" do |page, id|
  it "redirects to the #{page} page" do
    expect(response).to redirect_to path(id)
  end
end
