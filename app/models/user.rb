class User < ActiveRecord::Base

  attr_accessor :password

  EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i

  validates :first_name, :presence => true, :length => { :maximum => 50 }
  validates :last_name, :presence => true, :length => { :maximum => 50 }
  validates :email, :presence => true, :length => { :maximum => 100 },
    :format => EMAIL_REGEX, :confirmation => true

  validates_length_of :password, :within => 8..25, :on => :create

  before_save :create_hashed_password
  after_save :clear_password

  def name
    "#{first_name} #{last_name}"
  end

  def list_name
    "#{last_name}, #{first_name}"
  end

  def self.inherited(child)
    child.instance_eval do
      def model_name
        User.model_name
      end
    end
    super
  end

  def self.authenticate(email="", password="")
    user = self.find_by_email(email)
    if user && user.password_match?(password)
      return user
    else
      return false
    end
  end

  # The same password string with the same hash method and salt
  # should always generate the same hashed_password.
  def password_match?(password="")
    hashed_pass == self.class.hash_with_salt(password, salt)
  end

  def self.make_salt(email="")
    Digest::SHA1.hexdigest("Use #{email} with #{Time.now} to make salt")
  end

  def self.hash_with_salt(password="", salt="")
    Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end

  protected

  def create_hashed_password
    # Whenever :password has a value hashing is needed
    unless password.blank?
      self.salt = self.class.make_salt(email) if salt.blank?
      self.hashed_pass = self.class.hash_with_salt(password, salt)
    end
  end

  def clear_password
    # for security and b/c hashing is not needed
    self.password = nil
  end

end