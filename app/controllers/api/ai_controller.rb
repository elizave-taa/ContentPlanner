module Api
  class AiController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:chat]

    # POST /api/ai/chat
    def chat
      # Получаем сообщение пользователя из параметров
      user_message = params[:message]

      if user_message.blank?
        render json: { error: 'Message is required' }, status: :bad_request
        return
      end

      # API ключ OpenAI из переменных окружения
      api_key = ENV['OPENAI_API_KEY']

      if api_key.blank?
        render json: { error: 'OpenAI API key not configured' }, status: :internal_server_error
        return
      end

      begin
        # Отправляем запрос к OpenAI API
        response = HTTP.headers(
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{api_key}"
        ).post('https://api.openai.com/v1/chat/completions', json: {
          model: 'gpt-4.1-nano',
          messages: [
            { role: 'system', content: 'Вы — полезный ассистент smm-менеджера.' },
            { role: 'user', content: user_message }
          ]
        })

        # Возвращаем ответ OpenAI без изменений
        render json: response.body.to_s, status: response.code
      rescue => e
        render json: { error: 'Failed to communicate with OpenAI API', details: e.message }, status: :internal_server_error
      end
    end
  end
end
