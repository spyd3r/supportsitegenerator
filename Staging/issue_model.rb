# == Schema Information
#
# Table name: issues
#
#  id          :integer         primary key
#  kb          :text
#  description :string(255)
#  details     :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Issue < ActiveRecord::Base
  attr_accessible :kb, :description, :details, :product_family
  def self.search(search, product)
    if search && product != "All"
      find(:all, :conditions => ['(kb ILIKE ? OR product_family ILIKE ? OR description ILIKE ? OR details ILIKE ?) AND product_family = ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%","#{product}"])
#    else
#      find(:all)
    else
      find(:all, :conditions => ['(kb ILIKE ? OR product_family ILIKE ? OR description ILIKE ? OR details ILIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    end
  end
end
