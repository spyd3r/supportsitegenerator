# == Schema Information
#
# Table name: fmrs
#
#  id          :integer         not null, primary key
#  number      :integer
#  description :string(255)
#  details     :text
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Fmr < ActiveRecord::Base
  attr_accessible :number, :description, :details, :product_family
  def self.search(search, product)
    if search && product != "All"
      find(:all, :conditions => ['(number ILIKE ? OR product_family ILIKE ? OR description ILIKE ? OR details ILIKE ?) AND product_family = ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "#{product}"])
#    else
#      find(:all)
    else
      find(:all, :conditions => ['(number ILIKE ? OR product_family ILIKE ? OR description ILIKE ? OR details ILIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    end
  end
end
