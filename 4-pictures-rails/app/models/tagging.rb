class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :person
  belongs_to :taggable, :polymorphic => true
end
