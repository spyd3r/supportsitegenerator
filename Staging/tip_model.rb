class Tip < ActiveRecord::Base
attr_accessible :name, :description, :url
validates :url, :format => { :with => /^http\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :message => "Invalid URL Format - Ensure http(s):// is included" }
def self.search(search)
    if search
      find(:all, :conditions => ['name ILIKE ? OR description ILIKE ?', "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end
end
