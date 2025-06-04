class RaffleSetting < ActiveRecord::Base
  self.table_name = "raffle_settings"
end

# 迁移文件 (db/migrate/xxx_create_raffle_settings.rb)
class CreateRaffleSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :raffle_settings do |t|
      t.integer :topic_id, null: false, index: true
      t.integer :prize_count, default: 1
      t.datetime :draw_at, null: false
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
