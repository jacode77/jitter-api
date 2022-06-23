class Message < ApplicationRecord
    belongs_to :user
    validates_presence_of :text

    # passes the back end data to front end (object method)
    def transform_message
        # can alter the id/text to different names. This can be useful for the front end
        return {
            id: self.id,
            text: self.text,
            posted: self.updated_at,
            username: self.user.username
        }
    end

    # applying to message class - searching all users messages via message class (class method). if we don't include self, it's just one object
    def self.find_by_user(username)
        # define username search as we will receive a message by a user displaying as username, not email
        # get the user object from the database
        user = User.find_by(username: username)
        print user.username
        if user
            # returns all messages from specific user
            return self.where(user: user)
        else
            return {error: 'user not found'}
        end
    end
end
