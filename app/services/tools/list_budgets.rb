class Tools::ListBudgets
  def initialize(budgets:)
    @budgets = budgets
  end

  def call
    budgets.limit(10).pluck(:code)
  end

  private

  attr_reader :budgets
end