require 'rails_helper'

RSpec.describe 'Homes', type: :request do

  describe 'GET /top' do
    it 'redirects to /top0' do
      get root_path
      aggregate_failures do
        expect(response).to have_http_status '302'
        expect(response).to redirect_to top_path
      end
    end
  end

  describe 'GET /top0' do
    it 'responds successfully' do
      get top_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'GET /about' do
    # 正常にレスポンスを返すこと
    it 'responds successfully ' do
      get about_path
      expect(response).to be_successful
    end
  end
end
