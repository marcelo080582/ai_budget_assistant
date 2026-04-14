class ChatController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  
  def create
    question = params[:message]

    ask = "Você perguntou: #{question}"

    render json: { response: ask }
  end
end