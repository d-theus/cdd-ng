include Devise::TestHelpers
include Warden::Test::Helpers
Warden.test_mode!

module ControllerHelpers
  def sign_in(admin = double('admin'))
    if admin.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_return(nil) #throw(:warden, {:scope => :admin})
      allow(controller).to receive(:current_admin).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(admin)
      allow(controller).to receive(:current_admin).and_return(admin)
    end
  end
end
