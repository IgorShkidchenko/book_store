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
end
