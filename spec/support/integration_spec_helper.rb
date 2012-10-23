module IntegrationSpecHelper
  def login_with_oauth(service = :mygov)
    visit "/auth/#{service}"
  end
end