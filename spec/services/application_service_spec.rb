require 'rails_helper'

RSpec.describe ApplicationService do
  it 'when call raise error' do
    expect { described_class.call }.to raise_error NotImplementedError
  end
end
