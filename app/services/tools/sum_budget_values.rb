class Tools::SumBudgetValues
  def initialize(budgets:)
    @budgets = budgets
  end

  def call
    budgets.sum(:total_value)
  end

  private

  attr_reader :budgets
end