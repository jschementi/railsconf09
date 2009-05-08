require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  def setup
    @person = Person.new(:password => "whatever", :email => "x@x", :first_name => "Chad", :last_name => "Whatever")  
  end
  def test_requires_password_confirmation
    @person.password_confirmation = "wrong!"
    assert !@person.valid?, "Person should not be valid with incorrect password confirmation"
    @person.password_confirmation = "whatever"
    assert @person.valid?, "Person should be valid when password is confirmed: #{@person.errors.full_messages}"
  end

  def test_password_is_hashed_when_person_is_created
    assert_nil @person.salt
    @person.save    
    assert @person.password != "whatever"
    assert_not_nil @person.salt
  end
  
  def test_can_authenticate_with_email_and_password
    person = Person.authenticate("person@example.org", "secret")
    assert_equal "Simple Guy", person.name
  end
  
  def test_failed_authentication_returns_nil
    assert_nil Person.authenticate("person@example.org", "wrong password")
    assert_nil Person.authenticate("wrong_email@example.org", "wrong password")    
  end
end
