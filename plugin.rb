# plugin.rb
module DiscourseRaffle
  class Engine < ::Rails::Engine
    engine_name "discourse_raffle"
    isolate_namespace DiscourseRaffle
  end
end

after_initialize do
  # 注册路由
  Discourse::Application.routes.append do
    post "raffle/save" => "raffle#save"
  end
end
