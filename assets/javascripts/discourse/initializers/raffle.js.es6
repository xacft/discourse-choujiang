import { withPluginApi } from "discourse/lib/plugin-api";

function initRaffle(api) {
  const currentUser = api.getCurrentUser();
  
  api.modifyClass("component:topic-post", {
    didInsertElement() {
      this._super(...arguments);

      if (this.post.post_number === 1 && this.post.can_edit) {
        const element = document.querySelector(".topic-post:first-child");
        
        // 插入抽奖设置UI
        element.insertAdjacentHTML(
          "beforeend",
          `<div class="raffle-container">
            <h3>🎁 设置回帖抽奖</h3>
            <div class="raffle-form">
              奖品数量: <input type="number" id="raffle-count" min="1" value="3">
              开奖时间: <input type="datetime-local" id="raffle-time">
              <button class="btn btn-primary" id="start-raffle">确认设置</button>
            </div>
          </div>`
        );

        document.getElementById("start-raffle").addEventListener("click", () => {
          const count = document.getElementById("raffle-count").value;
          const time = document.getElementById("raffle-time").value;
          
          // 调用API保存设置
          api.ajax("/raffle/save", {
            type: "POST",
            data: {
              topic_id: this.post.topic_id,
              prize_count: count,
              draw_at: new Date(time).toISOString()
            }
          }).then(() => {
            bootbox.alert("抽奖已设置！将在指定时间自动开奖");
          });
        });
      }
    }
  });
}

export default {
  name: "discourse-raffle",
  initialize() {
    withPluginApi("1.6.0", initRaffle);
  }
};
