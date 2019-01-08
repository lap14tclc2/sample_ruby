
module ApplicationHelper
 #return the full title on per-pages basis
  def full_title(page_title='')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def test_ceaser_cipher(input_string, fixed_number)
    ceaser_cipher(input_string, fixed_number)
  end
end
