class PromptBuilders::BudgetPromptBuilder
  def initialize(message:, context:)
    @message = message
    @context = context
  end

  def call
    <<~PROMPT
      Você é um assistente especializado em orçamentos automotivos.

      Pergunta do usuário:
      "#{message}"

      Contexto recuperado:
      - Quantidade de orçamentos: #{context[:count]}
      - Valor total: #{formatted_total_value}
      - Valor médio: #{formatted_average_value}
      - Códigos encontrados: #{formatted_codes}
      - Oficina com mais orçamentos: #{formatted_top_workshop}

      Gere uma resposta curta e clara em português.
    PROMPT
  end

  private

  attr_reader :message, :context

  def formatted_total_value
    format('R$ %.2f', context[:total_value] || 0)
  end

  def formatted_average_value
    average = context[:average_value]
    return "não disponível" if average.blank?

    format('R$ %.2f', average)
  end

  def formatted_codes
    codes = context[:codes]
    return "nenhum" if codes.blank?

    codes.join(", ")
  end

  def formatted_top_workshop
    workshop = context[:top_workshop]
    return "nenhuma" if workshop.blank?

    "#{workshop[:name]} (#{workshop[:total]} orçamento(s))"
  end
end