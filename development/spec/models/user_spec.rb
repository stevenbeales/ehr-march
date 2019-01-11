describe User do
  context 'validations' do
    it { should validate_presence_of(:email) }
  end

  context 'relations' do
    it { should have_one :provider }
    it { should have_one :patient  }
    it { should have_one :practice }

    it { should define_enum_for :role }
  end

  describe 'private methods' do
    let!(:user) { create(:user) }

    it 'generate captcha' do
      captcha = user.captcha
      user.send(:generate_captcha)
      user.save
      expect(user.captcha).to_not eq(captcha)
    end

    it 'unlock' do
      user.update_attributes(locked: true)
      user.send(:unlock)
      expect(user.locked).to eq(false)
    end
  end
end
