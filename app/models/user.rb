class User < ApplicationRecord
	
	PASSWORD_FORMAT = /\A
		(?=.{6,})          # Must contain 6 or more characters
		(?=.*\d)           # Must contain a digit
		(?=.*[a-zA-Z])	   # Must contain a letter
	/x

	has_secure_password
	validates :name, presence: true,  format: {with: /\A[\p{L} ]+\z/, message: 'can have only letters'}
	validates :email, presence: true, uniqueness: {case_sensitive: false}, 
							format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :cpf, :cpf => true, presence: true, uniqueness: true
	validates :password, presence: true, format: { with: PASSWORD_FORMAT, message: 'must contain 6 or more characters, a digit and a letter'}


end