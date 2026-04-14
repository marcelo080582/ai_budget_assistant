class Chat::BudgetQueryService
  def initialize(message)
    @message = message.to_s.downcase.strip
  end

  def call
    return unknown_question unless action

    budgets = filtered_budgets
    context = ContextBuilders::BudgetContextBuilder.new(budgets).call

    Responders::BudgetResponder.new(
      action: action,
      context: context,
      status: status,
      period: period
    ).call
  end

  private

  attr_reader :message

  def unknown_question
    "Ainda não sei responder essa pergunta."
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

  def status
    return "aprovado" if message.include?("aprovado") || message.include?("aprovados")
    return "aberto" if message.include?("aberto") || message.include?("abertos")
  end

  def period
    return :yesterday if message.include?("ontem")

    :today
  end

  def filtered_budgets
    Retrievers::BudgetRetriever.new(
      period: period,
      status: status
    ).call
  end
end