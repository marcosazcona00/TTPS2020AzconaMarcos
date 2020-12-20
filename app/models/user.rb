class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :books
  has_many :notes
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  def exists_book?(id)
    return books.exists?(id: id)
  end

  def exists_title_book?(title)
    return books.exists?(title: title)
  end
end
