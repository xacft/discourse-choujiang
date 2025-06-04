class RaffleDraw < ::Jobs::Scheduled
  every 1.hour # 实际触发时间由enqueue_at控制

  def execute(args)
    setting = RaffleSetting.find(args[:raffle_id])
    return if setting.completed || setting.draw_at > Time.now

    topic = Topic.find(setting.topic_id)
    
    # 获取所有符合条件的回复
    participants = Post.where(topic_id: topic.id)
                      .where("post_number > 1") # 排除首贴
                      .where.not(user_id: topic.user_id) # 排除楼主
                      .distinct.pluck(:user_id) # 去重用户ID

    # 随机抽取
    winners = participants.sample(setting.prize_count)
    setting.update!(completed: true)

    # 构造获奖通知
    winner_tags = winners.map { |id| "@#{User.find(id).username}" }.join(" ")
    raw = "🎉 抽奖结果公布！恭喜获奖用户：#{winner_tags}\n\n> 奖品将在3日内发放，请留意私信"

    # 在主题中发布结果
    PostCreator.create!(
      Discourse.system_user,
      topic_id: topic.id,
      raw: raw,
      skip_validations: true
    )
  end
end
