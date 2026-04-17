class Llm::Providers::Fake
  def initialize(prompt:)
    @prompt = prompt
  end

  def call
    <<~TEXT.strip
      [FAKE LLM RESPONSE]

      Resposta gerada com base no prompt:

      #{prompt}
    TEXT
  end

  private

  attr_reader :prompt
end