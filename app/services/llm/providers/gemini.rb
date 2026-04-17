class Llm::Providers::Gemini
  include HTTParty

  def initialize(prompt:)
    @prompt = prompt
  end

  def call
    return fallback_response if api_key.blank?

    response = self.class.post(
      api_url,
      headers: { "Content-Type" => "application/json" },
      body: request_body.to_json
    )

    return fallback_response unless response.success?

    parsed_text(response) || fallback_response
  rescue StandardError => e
    Rails.logger.error("Llm::Providers::Gemini error: #{e.message}")
    fallback_response
  end

  private

  attr_reader :prompt

  def fallback_response
    Llm::Providers::Fake.new(prompt: prompt).call
  end

  def api_key
    ENV["GEMINI_API_KEY"]
  end

  def model
    ENV["LLM_MODEL"].presence || "gemini-flash-latest"
  end

  def api_url
    "https://generativelanguage.googleapis.com/v1beta/models/#{model}:generateContent?key=#{api_key}"
  end

  def request_body
    {
      contents: [
        {
          parts: [
            { text: prompt }
          ]
        }
      ]
    }
  end

  def parsed_text(response)
    body = response.parsed_response
    candidates = body["candidates"] || []
    first_candidate = candidates.first || {}
    content = first_candidate["content"] || {}
    parts = content["parts"] || []
    first_part = parts.first || {}

    first_part["text"]
  end
end