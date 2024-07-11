require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # subject{User.new(first_name:"TestUser1",last_name:"Testing",email:"testuser1@gmail.com",password:"password")}
 

    subject{User.new(first_name:"TestUser1",last_name:"Testing",email:"testuser1@gmail.com",password:"password")}
    it{is_expected.to have_attributes(first_name:"TestUser1",last_name:"Testing",email:"testuser1@gmail.com",password:"password")}

    it 'checks for object attributes and its values' do 
      expect(subject).to have_attributes(first_name:'TestUser1')
      expect(subject).to have_attributes(last_name:'Testing',email:'testuser1@gmail.com')
      expect(subject).to have_attributes(password:'password')
    end


    it 'should have first_name' do 
      subject.first_name=nil
      expect(subject).not_to be_valid
    end 
    it 'should have last_name' do 
      subject.last_name=nil
      expect(subject).not_to be_valid
    end
    it 'should have email' do 
      subject.email=nil
      expect(subject).not_to be_valid
    end

    it 'should have a valid email format'do 
      invalid_emails=['test@gl','testl','testl@','testl@gamilcom','testusergmil.com']
      invalid_emails.each do |email|
        subject.email=email 
        expect(subject).not_to be_valid
      end
      subject.email='testuser@gmil.com'
      expect(subject).to be_valid
    end

    it { is_expected.to have_many(:articles) }

    describe 'email uniqueness' do
      before do
        User.create!(first_name: "ExistingUser", last_name: "Existing", email: "testuser1@gmail.com", password: "password1!")
      end
  
      it 'should have a unique email' do
        subject.email = 'testuser1@gmail.com'
        expect(subject).not_to be_valid
      end
  
      it 'should be case insensitive' do
        subject.email = 'TestUser1@gmail.com'
        expect(subject).not_to be_valid
      end
    end
    
    describe 'associations' do 
      it { is_expected.to have_many(:articles) }
    end
  

end


  


