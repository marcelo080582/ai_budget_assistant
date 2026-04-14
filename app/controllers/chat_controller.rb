class ChatController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
     message = params[:message].to_s.downcase.strip
     
     answer =
      if message.include?("quantos orçamentos hoje")
        total = Budget.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).count
        "Hoje foram encontrados #{total} orçamento(s)."
      elsif message.include?("qual o valor total dos orçamentos hoje")
        total = Budget.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).sum(:total_value)
        "O valor total dos orçamentos de hoje é R$ #{format('%.2f', total)}."
      else
        "Ainda não sei responder essa pergunta."
      end

    render json: { answer: answer }
  end
end