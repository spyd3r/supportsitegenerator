# == Schema Information
#
# Table name: bugs
#
#  id          :integer         primary key
#  number      :integer
#  kb          :string(255)
#  description :string(255)
#  details     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Bug < ActiveRecord::Base
  attr_accessible :number, :kb, :description, :details, :product_family
  def self.search(search, product)
    if search && product != "All"
      find(:all, :conditions => ['(number ILIKE ? OR product_family ILIKE ? OR kb ILIKE ? OR description ILIKE ? OR details ILIKE ?) AND product_family = ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "#{product}"])
#    else
#      find(:all)
    else
      find(:all, :conditions => ['(number ILIKE ? OR product_family ILIKE ? OR kb ILIKE ? OR description ILIKE ? OR details ILIKE ?)' , "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    end
  end
end
