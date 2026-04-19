class Tools::CountBudgets
  def initialize(budgets:)
    @budgets = budgets
  end

  def call
    budgets.count
  end

  private

  attr_reader :budgets
end