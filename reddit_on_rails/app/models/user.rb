# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :password_digest, :session_token, presence: true
    validates :username, uniqueness: true
    validates :password, length: { minimum: 6, allow_nil: true }

    has_many :subs,
    foreign_key: :moderator_id,
    class_name: 'Sub'

    has_many :posts,
    foreign_key: :author_id,
    class_name: 'Post'

    attr_reader :password
    after_initialize :ensure_session_token


    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        return nil unless user
        user.is_password?(password) ? user : nil
    end

    def reset_session_token!
        self.session_token = self.class.generate_session_token
        self.save!
        self.session_token
    end

    private

    def self.generate_session_token
        SecureRandom::urlsafe_base64
        # SecureRandom.base64(64)
    end

    def ensure_session_token
        self.session_token ||= self.class.generate_session_token
    end
end
