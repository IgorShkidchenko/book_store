class BookDecorator < Draper::Decorator
  SHORT_DESCRIPTION_LETTERS_QUANTITY = 150
  MEDIUM_DESCRIPTION_LETTERS_QUANTITY = 250
  REST_OF_DESCRIPTION_RANGE = (250..-1).freeze

  delegate_all

  def authors_as_string
    authors.map(&:name).join(', ')
  end

  def short_description
    description.first(SHORT_DESCRIPTION_LETTERS_QUANTITY)
  end

  def medium_description
    description.first(MEDIUM_DESCRIPTION_LETTERS_QUANTITY)
  end

  def the_rest_of_description
    description[REST_OF_DESCRIPTION_RANGE]
  end

  def dimensions
    "H: #{book.width} x W: #{book.height} x D: #{book.depth}"
  end

  def main_book_cover
    if book.covers.exists?
      h.image_tag book.covers.first.image_url(:width_500), alt: I18n.t('book.cover_alt', title: book.title),
                                                           class: 'img-shadow general-thumbnail-img'
    else
      h.image_tag CoverUploader::DEFAULT_IMG_FILE_NAME, alt: I18n.t('book.cover_default'),
                                                        class: 'general-thumbnail-img'
    end
  end
end
