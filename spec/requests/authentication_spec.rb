require 'rails_helper'

RSpec.describe 'Authentication via GraphQL', type: :request do
  # Test suite for POST /authenticate
  describe 'POST authentication' do
    context 'with right credentials' do
      before { 
        user ||= FactoryBot.create(:user)
        post '/graphql', params: {
          "operationName" => "login",
          "query" => "mutation login($email: String, $password: String){  login(email: $email, password: $password) {    name    token  }}",
          "variables" => { "email" => user.email, "password" => user.password} 
        }
      }

      it 'returns auth token' do
        expect(json).not_to be_empty
        expect(json['data']['login']['token']).not_to be_empty
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with wrong credentials' do
      before { post '/graphql', params: {
          "operationName" => "login",
          "query" => "mutation login($email: String, $password: String){  login(email: $email, password: $password) {    name    token  }}",
          "variables" => { "email" => "error", "password" => "wrong password"}
        }
      }

      it 'returns error' do
        expect(json).not_to be_empty
        expect(json['errors']).not_to be_empty
        expect(json['errors'][0]['message']).to eq("Invalid email or password")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'with no info' do
      before { post '/graphql' }
      it 'returns error' do
        expect(json).not_to be_empty
        expect(json['errors']).not_to be_empty
        expect(json['errors'][0]['message']).to eq("No query string was present")
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
    
  end

end