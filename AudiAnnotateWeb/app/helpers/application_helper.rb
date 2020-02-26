module ApplicationHelper

	def logged_in?
		@github_client && @github_client.user_authenticated?
	end

end
