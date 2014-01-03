require 'spec_helper'

feature Schnitzelpress::App, '/assets' do
  scenario 'requesting application.js' do
    visit('/assets/application.js')
    expect(page.status_code).to be 200
    expect(body.empty?).to be(false)
  end

  scenario 'requesting application.css' do
    visit('/assets/application.css')
    expect(page.status_code).to be 200
    expect(body.empty?).to be(false)
  end

  scenario 'requesting admin_application.js' do
    visit('/assets/admin_application.js')
    expect(page.status_code).to be 200
    expect(body.empty?).to be(false)
  end
end