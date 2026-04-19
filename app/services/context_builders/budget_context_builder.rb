class ContextBuilders::BudgetContextBuilder
  def initialize(budgets)
    @budgets = budgets
  end

  def call
    {
      count: Tools::CountBudgets.new(budgets: budgets).call,
      total_value: Tools::SumBudgetValues.new(budgets: budgets).call,
      average_value: budgets.average(:total_value),
      codes: Tools::ListBudgets.new(budgets: budgets).call,
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