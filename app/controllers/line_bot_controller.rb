class LineBotController < ApplicationController
    # CSRF対策無効化
    protect_from_forgery except: [:callback]

    def callback
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
