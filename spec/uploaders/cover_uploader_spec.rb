require 'rails_helper'

describe CoverUploader do
  subject(:cover_uploader) { described_class.new(book, :cover) }

  let(:book) { build(:book) }
  let(:cover_name) { 'book_cover.jpg' }
  let(:path_to_file) { "#{fixture_path}/covers/#{cover_name}" }
  let(:download_path) { "/uploads/#{cover_name}" }
  let(:main_size) { CoverUploader::MAIN_COVER_SIZE }
  let(:small_size) { CoverUploader::SMALL_COVER_SIZE }

  before do
    described_class.enable_processing = true
    File.open(path_to_file) { |file| cover_uploader.store!(file) }
  end

  after do
    described_class.enable_processing = false
    cover_uploader.remove!
  end

  it 'when resize to #width_500' do
    expect(cover_uploader.width_500).to be_no_larger_than(main_size, main_size)
  end

  it 'when resize to #width_150' do
    expect(cover_uploader.width_150).to be_no_larger_than(small_size, small_size)
  end

  it 'when #default_url' do
    expect(cover_uploader.default_url).to eq CoverUploader::DEFAULT_IMG_FILE_NAME
  end

  it 'when #download_url' do
    expect(cover_uploader.download_url(cover_name)).to eq download_path
  end
end
