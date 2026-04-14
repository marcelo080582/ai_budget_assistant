class Responders::BudgetResponder
  def initialize(action:, context:, status:, period:)
    @action = action
    @context = context
    @status = status
    @period = period
  end

  def call
    case action
    when :count
      "Foram encontrados #{context[:count]} orçamento(s) #{status_label}#{period_label}."
    when :sum
      "O valor total dos orçamentos #{status_label}#{period_label} é R$ #{format('%.2f', context[:total_value])}."
    when :average
      return no_budgets_message if context[:average_value].blank?

      "O valor médio dos orçamentos #{status_label}#{period_label} é R$ #{format('%.2f', context[:average_value])}."
    when :list
      return no_budgets_message if context[:codes].blank?

      "Os orçamentos #{status_label}#{period_label} são: #{context[:codes].join(', ')}."
    when :top_workshop
      return no_budgets_message if context[:top_workshop].blank?

      "#{context[:top_workshop][:name]} foi a oficina com mais orçamentos #{status_label}#{period_label}, com #{context[:top_workshop][:total]} orçamento(s)."
    else
      "Ainda não sei responder essa pergunta."
    end
  end

  private

  attr_reader :action, :context, :status, :period

  def status_label
    return "" if status.blank?

    "#{status}s "
  end

  def period_label
    period == :yesterday ? "de ontem" : "de hoje"
  end

  def no_budgets_message
    "Nenhum orçamento #{status_label}foi encontrado #{period == :yesterday ? 'ontem' : 'hoje'}."
  end
end