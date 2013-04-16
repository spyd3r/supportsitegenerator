class Version < ActiveRecord::Base
attr_accessible :product_family, :release, :build, :details, :kernel
def self.search(search, product)
    if search && product != "All"
      find(:all, :conditions => ['(release ILIKE ? OR product_family ILIKE ? OR details ILIKE ? OR build ILIKE ? OR kernel ILIKE ?) AND product_family = ?', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "#{product}"])
#    else
#      find(:all)
    else
      find(:all, :conditions => ['(release ILIKE ? OR product_family ILIKE ? OR details ILIKE ? OR build ILIKE ? OR kernel ILIKE ?)', "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%"])
    end
  end
end
