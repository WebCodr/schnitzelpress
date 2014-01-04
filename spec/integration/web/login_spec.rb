require 'spec_helper'

feature Schnitzelpress::App, '/login' do
  include FactoryHelper

  context 'developer login' do

    specify do
      visit('/login')
      click_on('Developer Login')

      expect(page).to have_content('User Info')
      within('form') do
        fill_in('Email', with: 'schnitzel@press.de')
        click_on('Sign In')
      end

      expect(page).to have_content('Admin Area')
    end

  end

end
