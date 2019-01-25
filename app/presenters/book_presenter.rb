class BookPresenter < Rectify::Presenter
  attribute :book, Book

  def main_book_cover
    if book.covers.present?
      image_tag book.covers.first.image_url(:w500), alt: t('book.cover_alt', title: book.title),
                                                    class: 'img-shadow general-thumbnail-img'
    else
      image_tag 'w500_default.png', alt: t('book.cover_default'),
                                    class: 'img-shadow general-thumbnail-img'
    end
  end
end
