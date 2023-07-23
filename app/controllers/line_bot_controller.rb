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

      ####################おうむ返しBOT####################
      events = client.parse_events_from(body)
      events.each do |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text

            # 入力した文字をinputに格納
            input = event.message['text']
            # search_and_create_messageメソッド内で、楽天APIを用いた商品検索、メッセージの作成を行う
            message = search_and_create_message(input)
            client.reply_message(event['replyToken'], message)

          end
        end
      end
      head :ok
      ####################おうむ返しBOT####################


    end



    # LINE Messaging API SDKのLine::Bot::Clientクラスをインスタンス化
    private
 
      def client
        @client ||= Line::Bot::Client.new { |config|
          config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
          config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
        }
      end


        def search_and_create_message(input)
          RakutenWebService.configure do |c|
          c.application_id = ENV['RAKUTEN_APPID']
          c.affiliate_id = ENV['RAKUTEN_AFID']
        end

        res = RakutenWebService::Ichiba::Item.search(keyword: input, hits: 5,formatVersion: 2,availability: 1,orFlag: 0)
        items = []
        items = res.map{|item| item}
        # make_reply_content(items)

        #############################################################################
          text = ''
            items.each do |item|
            text <<
              item['mediumImageUrls'].first + "\n" +
              item['itemName'] + "\n" +
              item['itemPrice'].to_s+ '円'  + "\n" +
              item['itemUrl'] + "\n" +
              # item['itemCaption'] + "\n" + #####7/23キャプションこの部分がエラー出る #####
              item['shopName'] + "\n" +
              "\n"
          end

        message = {
          type: 'text',
          text: text
        }

        #############################################################################

    end

    # def make_reply_content(items)
    #   {
    #     type: 'flex',
    #     altText: '楽天商品検索の結果です。',
    #     contents:set_carousel(response['items'])
    #   }
    # end

    # def set_carousel(items)
    #   bubbles = []
    #   items.each do |item|
    #     bubbles.push set_bubble(item)
    #   end
    #   {
    #     type: 'carousel',
    #     contents: bubbles
    #   }
    # end

    # def set_bubble(item)
    #   {
    #     type: 'bubble',
    #     hero: set_hero(item),
    #     body: set_body(item),
    #     footer: set_footer(item)
    #   }
    # end

    # def set_hero(item)
    #   {
    #     type: "image",
    #     size: "full",
    #     aspectRatio: "20:17",
    #     aspectMode: "cover",
    #     url: item['mediumImageUrls'].first
    #   }
    # end

    # def set_body(hotel)
    #   {
    #     "type": "box",
    #     "layout": "vertical",
    #     "spacing": "sm",
    #     "contents": [
    #       {
    #         "type": "text",
    #         "text": item['itemName'],
    #         "wrap": false,
    #         "weight": "bold",
    #         "size": "lg",
    #         "color": "#0068E9"
    #       },
    #       {
    #         "type": "box",
    #         "layout": "baseline",
    #         "contents": [
    #           {
    #             "type": "text",
    #             "text": item['itemPrice'].to_s,
    #             "wrap": true,
    #             "weight": "bold",
    #             "size": "xxl",
    #             "flex": 0
    #           },
    #           {
    #             "type": "text",
    #             "text": "円",
    #             "wrap": true,
    #             "weight": "bold",
    #             "size": "sm",
    #             "flex": 0
    #           }
    #         ]
    #       },
    #       {
    #         "type": "box",
    #         "layout": "vertical",
    #         "contents": [
    #           {
    #             "type": "text",
    #             "text": item['shopName'],
    #             "margin": "none"
    #           },
    #           # {
    #           #   "type": "text",
    #           #   "text": item['itemCaption'],
    #           #   "margin": "sm",
    #           #   "size": "sm",
    #           #   "wrap": true,
    #           #   "maxLines": 4
    #           # }
    #         ],
    #         "margin": "md"
    #       }
    #     ]
    #   }
    # end

    # def set_footer(hotel)
    #   {
    #     "type": "box",
    #     "layout": "vertical",
    #     "spacing": "sm",
    #     "contents": [
    #       {
    #         "type": "button",
    #         "style": "primary",
    #         "action": {
    #           "type": "uri",
    #           "label": "商品ページへGO！",
    #           "uri":  item['itemUrl']
    #         }
    #       }
    #     ],
    #     "margin": "xl"
    #   }
    # end


end
