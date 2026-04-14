class ChatController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    answer = Chat::BudgetQueryService.new(params[:message]).call

    render json: { answer: answer }
  end
end