class CreateOrderListDefs < ActiveRecord::Migration
  def change
    create_table :order_list_defs do |t|
      t.string   :namep
      t.integer  :qtd
      t.string   :prato_price
      t.string  :total
      t.integer  :manage_id
      t.string   :mesa_n
      t.integer  :n_order
      t.string  :pedido_total_price
      t.integer  :status  
    end
  end
end
