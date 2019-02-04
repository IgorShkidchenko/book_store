class BookDecorator < Draper::Decorator
  delegate_all

  def authors_as_string
    authors.map(&:name).join(', ')
  end

  def short_description
    description[0..150]
  end

  def medium_description
    description[0..250]
  end

  def the_rest_of_description
    description[250..-1]
  end

  def approved_reviews_count
    reviews.approved.count
  end

  def dimensions
    "H: #{book.width} x W: #{book.height} x D: #{book.depth}"
  end

  def main_book_cover
    covers = book.covers

    if covers.present?
      h.image_tag covers.first.image_url(:w500), alt: I18n.t('book.cover_alt', title: book.title),
                                                 class: 'img-shadow general-thumbnail-img'
    else
      h.image_tag 'w500_default.png', alt: I18n.t('book.cover_default'), class: 'general-thumbnail-img'
    end
  end
end
