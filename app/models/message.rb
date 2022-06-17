class Message < ApplicationRecord
    belongs_to :user
    validates_presence_of :text

    def transform_message
        # can alter the id/text to different names. This can be useful for the front end
        return {
            id: self.id,
            text: self.text,
            posted: self.updated_at,
            username: self.user.username
        }
    end
end
