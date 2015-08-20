class Product < ActiveRecord::Base

	searchkick
  
  has_many :line_items
	before_destroy :ensure_not_referenced_by_any_line_items

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :title, :description, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
 
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }



  private

  def ensure_not_referenced_by_any_line_items
  	if line_items.empty?
  		return true
  	else
  		errors.add(:base, 'Line Items present')
  		return false
  	end
  end

end
