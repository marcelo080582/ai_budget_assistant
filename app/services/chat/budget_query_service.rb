class Chat::BudgetQueryService
  def initialize(message)
    @message = message.to_s.downcase.strip
  end

  def call
    return unknown_question unless action

    budgets = filtered_budgets

    case action
    when :count
      "Foram encontrados #{budgets.count} orçamento(s) #{status_label}#{period_label}."
    when :sum
      total = budgets.sum(:total_value)
      "O valor total dos orçamentos #{status_label}#{period_label} é R$ #{format('%.2f', total)}."
    when :average
      average = budgets.average(:total_value)
      return no_budgets_message if average.blank?

      "O valor médio dos orçamentos #{status_label}#{period_label} é R$ #{format('%.2f', average)}."
    when :list
      return no_budgets_message if budgets.none?

      codes = budgets.limit(10).pluck(:code).join(", ")
      "Os orçamentos #{status_label}#{period_label} são: #{codes}."
    when :top_workshop
      result = budgets.group(:workshop_name).count.max_by { |_workshop, total| total }
      return no_budgets_message if result.blank?

      workshop, total = result
      "#{workshop} foi a oficina com mais orçamentos #{status_label}#{period_label}, com #{total} orçamento(s)."
    else
      unknown_question
    end
  end

  private

  attr_reader :message

  def unknown_question
    "Ainda não sei responder essa pergunta."
  end

  def period
    return :yesterday if message.include?("ontem")

    :today
  end

  def period_range
    case period
    when :yesterday
      Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day
    else
      Time.current.beginning_of_day..Time.current.end_of_day
    end
  end

  def status
    return "aprovado" if message.include?("aprovado") || message.include?("aprovados")
    return "aberto" if message.include?("aberto") || message.include?("abertos")
  end

  def filtered_budgets
    budgets = Budget.where(created_at: period_range)
    budgets = budgets.where(status: status) if status.present?
    budgets
  end

  def mentions_workshop_ranking?
    message.include?("qual oficina teve mais orçamentos") ||
      (message.include?("oficina") && message.include?("mais orçamentos"))
  end

  def mentions_average?
    message.include?("valor médio") ||
      message.include?("media") ||
      message.include?("média")
  end

  def mentions_sum?
    message.include?("valor total") ||
      message.include?("soma") ||
      message.include?("somatório")
  end

  def mentions_list?
    message.include?("listar") ||
      message.include?("liste") ||
      message.include?("mostrar") ||
      message.include?("mostre")
  end

  def mentions_count?
    message.include?("quantos") ||
      message.include?("quantidade") ||
      message.include?("total de orçamentos")
  end

  def action
    return :top_workshop if mentions_workshop_ranking?
    return :average if mentions_average?
    return :sum if mentions_sum?
    return :list if mentions_list?
    return :count if mentions_count?
  end

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