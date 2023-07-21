class LineBotController < ApplicationController
    # CSRF対策無効化
    protect_from_forgery except: [:callback]

    def callback

      body = request.body.read

      # 悪意のあるサーバーからのリクエストを検証する↓
      signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
        return head :bad_request
      end

      # LINEの送信メッセージのボディを配列に変換↓
      events = client.parse_events_from(body)
      #送信されたメッセージがテキストメッセージかどうかの検証↓
      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
            when Line::Bot::Event::MessageType::Text
              #返信メッセージ↓を作成
              message = {
                type: 'text',
                text: event.message['text']
              }
              client.reply_message(event['replyToken'], message)
          end
        end
      end
      head :ok
    end



    # LINE Messaging API SDKのLine::Bot::Clientクラスをインスタンス化
    private
 
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end

end
