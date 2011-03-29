class Task < ActiveRecord::Base
    validates_presence_of :description
end
