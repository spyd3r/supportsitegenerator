class Tip < ActiveRecord::Base
validates :url, :format => { :with => /^http\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(\/\S*)?$/, :message => "Invalid URL Format - Ensure http(s):// is included" }
end
