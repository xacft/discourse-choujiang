class RaffleController < ApplicationController
  requires_login

  def save
    # 权限验证 (仅楼主)
    topic = Topic.find(params[:topic_id])
    unless guardian.can_edit?(topic)
      return render_json_error(I18n.t("raffle.permission_denied"), status: 403)
    end

    # 保存抽奖设置
    setting = RaffleSetting.find_or_initialize_by(topic_id: params[:topic_id])
    setting.update!(
      prize_count: params[:prize_count],
      draw_at: params[:draw_at],
      completed: false
    )

    # 调度抽奖任务
    Jobs.enqueue_at(
      setting.draw_at,
      :raffle_draw,
      raffle_id: setting.id
    )

    render json: success_json
  end
end
