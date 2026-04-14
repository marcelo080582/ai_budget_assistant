class ContextBuilders::BudgetContextBuilder
  def initialize(budgets)
    @budgets = budgets
  end

  def call
    {
      count: budgets.count,
      total_value: budgets.sum(:total_value),
      average_value: budgets.average(:total_value),
      codes: budgets.limit(10).pluck(:code),
      top_workshop: top_workshop_data
    }
  end

  private

  attr_reader :budgets

  def top_workshop_data
    result = budgets.group(:workshop_name).count.max_by { |_workshop, total| total }
    return unless result

    workshop, total = result

    {
      name: workshop,
      total: total
    }
  end
end