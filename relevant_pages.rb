class RelevantPages
  attr_reader :pages, :queries
  attr_accessor :result

  def initialize(pages, queries)
    @pages = pages
    @queries = queries
  end

  def eval_pages
    queries.each_with_index do |query, query_index|
      page_weights = []
      pages.each_with_index do |page, idx|
        weight = calc_weight(page, query, query_index)
        page_weights << ["P#{idx + 1}", weight] if weight > 0
      end
      display_relevant_pages(page_weights, query_index)
    end
  end

  def display_relevant_pages(page_weights, query_index)
    pages_to_display = page_weights.sort { |(page1, weight1), (page2,weight2)|  weight2 <=> weight1 }.
                                    map { |pw| pw[0] }.slice(0,5).
                                    join(" ")
    p "Q#{query_index+1}: #{pages_to_display}"
  end

  private

  def calc_weight(page, query, query_index)
    w = 0
    query.each_with_index do |kw, idx|
      page_index = page.find_index { |item| item.downcase == kw.downcase }
      page_index = page_index.nil? ? 0 : (page_index - 8)
      w += page_index*(idx-8)
    end
    w
  end
end


pages = []
queries = []

while (user_input  = gets.chomp)
  case user_input
  when ""
    next
  when "exit"
    break
  else
    if user_input[0].casecmp?("p")
      pages << user_input.split(" ")[1..-1]
    elsif user_input[0].casecmp?("q")
      queries << user_input.split(" ")[1..-1]
    end
  end
end

relevant_pages = RelevantPages.new(pages, queries)
relevant_pages.eval_pages

