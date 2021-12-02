class User < ApplicationRecord

	has_secure_password
	validates :name, presence: true,  format: {with: /\A[\p{L} ]+\z/, message: 'Can have only letters'},
							uniqueness: {case_sensitive: false}
	validates :email, presence: true, uniqueness: {case_sensitive: false}, 
							format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :cpf, :cpf => true, presence: true, uniqueness: true
	validates :password, presence: true


end