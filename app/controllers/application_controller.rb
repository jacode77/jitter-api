class ApplicationController < ActionController::API
include Knock::Authenticable # all the controllers will inherit knock
end
