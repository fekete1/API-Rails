class User < ApplicationRecord
	
	PASSWORD_FORMAT = /\A
		(?=.{6,})          # Must contain 8 or more characters
		(?=.*\d)           # Must contain a digit
	/x

	has_secure_password
	validates :name, presence: true,  format: {with: /\A[\p{L} ]+\z/, message: 'Can have only letters'}
	validates :email, presence: true, uniqueness: {case_sensitive: false}, 
							format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :cpf, :cpf => true, presence: true, uniqueness: true
	validates :password, presence: true, format: { with: PASSWORD_FORMAT}


end