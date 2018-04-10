class CreateViewBatchReport < ActiveRecord::Migration[5.1]
  def change
    create_table :view_batch_reports do |t|
      execute <<-SQL
        CREATE VIEW batch_reports AS (
          WITH orders_cto AS (
            select batch_id id,
               sum(total_value) total_value,
               count(1) orders,
               purchase_channel_id
            from orders
            where batch_id is not null
            group by batch_id, purchase_channel_id
          )
          select b.*, o.purchase_channel_id, o.total_value, o.orders
          from batches b 
          left join orders_cto o ON o.id = b.id
        );
      SQL
    end
  end
end
