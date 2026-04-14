class Retrievers::BudgetRetriever
  def initialize(period:, status: nil)
    @period = period
    @status = status
  end

  def call
    budgets = Budget.where(created_at: period_range)
    budgets = budgets.where(status: status) if status.present?
    budgets
  end

  private

  attr_reader :period, :status

  def period_range
    case period
    when :yesterday
      Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day
    else
      Time.current.beginning_of_day..Time.current.end_of_day
    end
  end
end