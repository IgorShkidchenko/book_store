class AuthorDecorator < Draper::Decorator
  delegate_all

  def assosiated_books_quantity
    books.size
  end
end
