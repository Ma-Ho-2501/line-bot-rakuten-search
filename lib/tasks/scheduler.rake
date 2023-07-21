namespace :scheduler do
    desc "taroくんを生成する"
    task taro_create: :environment do
        User.create(name: 'taro')
    end
end
