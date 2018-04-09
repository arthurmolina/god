require 'rails_helper'

RSpec.describe 'AuthorizeApiRequest', type: :command do
  describe AuthorizeApiRequest do
    subject(:context) { 
      @user ||= FactoryBot.create(:user)
      #@user = User.first
      described_class.call(headers) }

    describe '.call' do
      context 'when the context is successful' do
        let(:headers) { {'Authorization' => get_authentication_token } }
        
        it 'succeeds' do
          expect(context).to be_success
        end
      end

      context 'when the context is not successful' do
        let(:headers) { {'Authorization' => 'wrong.token.fails' } }

        it 'fails' do
          expect(context).to be_failure
        end
      end
    end
  end
end