class CategoryDecorator < Draper::Decorator
  delegate_all

  def assosiated_books_quantity
    books.count
  end
end
