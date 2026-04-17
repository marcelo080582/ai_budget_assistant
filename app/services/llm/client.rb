class Llm::Client
  def initialize(prompt:)
    @prompt = prompt
  end

  def call
    provider.call
  end

  private

  attr_reader :prompt

  def provider
    case ENV["LLM_PROVIDER"]
    when "gemini"
      Llm::Providers::Gemini.new(prompt: prompt)
    else
      Llm::Providers::Fake.new(prompt: prompt)
    end
  end
end