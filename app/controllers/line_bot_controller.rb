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

        res = RakutenWebService::Ichiba::Item.search(keyword: input, hits: 5,formatVersion: 2,availability: 1,orFlag: 0,imageFlag: 1)
        items = []
        items = res.map{|item| item}
        make_reply_content(items)
        end

        #############################################################################

        # text = ''
        #   items.each do |item|
        #   text <<
        #   item['shopName'] + "\n" +
        #   item['itemName'] + "\n" +
        #   item['itemPrice'].to_s+ '円'  + "\n" +
        #   item['catchcopy'] + "\n" +
        #   item['mediumImageUrls'].first + "\n" +
        #   item['itemUrl'] + "\n" +
        #     "\n"
        # end
        #############################################################################


        def make_reply_content(items)
          {
            "type": 'flex',
            "altText": 'This is a Flex Message',
            "contents":
            {
              "type": 'carousel',
              "contents": [
                make_part(items[0]),
                make_part(items[1]),
                make_part(items[2]),
                make_part(items[3]),
                make_part(items[4])
              ]
            }
          }
        end

        def make_part(item)
          image = item['mediumImageUrls'].first
          itemtitle = item['itemName']
          price = item['itemPrice'].to_s
          shoptitle = item['shopName']
          catchcopy = item['catchcopy']
          url = item['itemUrl']
          { 
            "type": "bubble",
            "hero": {
              "type": "image",
              "size": "full",
              "aspectRatio": "20:17",
              "aspectMode": "fit",
              "url": image
            },
            
            "body": {
              "type": "box",
              "layout": "vertical",
              "spacing": "sm",
              "contents": [
                {
                  "type": "text",
                  "text": itemtitle,
                  "wrap": false,
                  "weight": "bold",
                  "size": "lg"
                },
                {
                  "type": "box",
                  "layout": "baseline",
                  "contents": [
                    {
                      "type": "text",
                      "text": "価格：",
                      "size": "xxs",
                      "flex": 0
                    },
                    {
                      "type": "text",
                      "text": price,
                      "wrap": true,
                      "weight": "bold",
                      "size": "3xl",
                      "flex": 0,
                      "align": "start"
                    },
                    {
                      "type": "text",
                      "text": "円",
                      "wrap": true,
                      "weight": "bold",
                      "size": "sm",
                      "flex": 0,
                      "align": "start"
                    }
                  ],
                  "margin": "md"
                },
                {
                  "type": "box",
                  "layout": "baseline",
                  "contents": [
                    {
                      "type": "text",
                      "text": "店舗：",
                      "size": "xxs",
                      "flex": 0
                    },
                    {
                      "type": "text",
                      "text": shoptitle,
                      "weight": "bold",
                      "flex": 1
                    }
                  ],
                  "margin": "none"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": catchcopy,
                      "wrap": true,
                      "size": "xxs",
                      "style": "normal",
                      "maxLines": 5
                    }
                  ],
                  "backgroundColor": "#EEEEEE",
                  "cornerRadius": "3px",
                  "paddingTop": "lg",
                  "paddingBottom": "lg",
                  "paddingStart": "md",
                  "paddingEnd": "md"
                }
              ]
            },
            "footer": {
              "type": "box",
              "layout": "vertical",
              "spacing": "sm",
              "contents": [
                {
                  "type": "button",
                  "style": "primary",
                  "action": {
                    "type": "uri",
                    "label": "商品ページへGO！",
                    "uri": url
                  }
                }
              ]
            }
           }
        end



end
