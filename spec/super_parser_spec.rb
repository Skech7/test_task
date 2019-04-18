RSpec.describe SuperParser do

  let(:watir) { instance_double('Watir::Browser') }
  let(:parser) { instance_double('SuperParser') }

  describe 'Watir' do
    it 'go to base url' do
      link = SuperParser::BASE_URL
      allow(watir).to receive(:goto).with(link)
    end

    it 'visits profile account page' do
      allow(parser).to receive(:visit_profile_account_page)
    end
  end

  describe 'SuperParser' do
    let(:json_res) { File.open('spec/fixtures/accounts.json') }

    it 'returns accounts' do
      allow(parser).to receive(:account_details).and_return(json_res)
    end

    it 'returns transactions' do
      allow(parser).to receive(:last_transactions)
    end
  end

  describe 'Accounts' do
    let(:accounts) { double('Accounts') }
    let(:accounts_instance) { instance_double('Accounts') }

    it 'returns accounts' do
      allow(accounts).to receive(:get_from).with(:browser)
    end

    it '.available_accounts_block' do
      allow(accounts_instance).to receive(:available_accounts_block)
    end

    it '.list' do
      allow(accounts_instance).to receive(:list).and_return([])
    end

    it '.get_account_data' do
      allow(accounts_instance).to receive(:get_account_data)
    end
  end

  describe 'Transactions' do
    let(:transactions) { double('Transactions') }
    let(:transactions_instance) { instance_double('Transactions') }

    it 'returns transactions' do
      allow(transactions).to receive(:get_last_five).with(:browser)
    end

    it '.list' do
      allow(transactions_instance).to receive(:list)
    end
  end
end
