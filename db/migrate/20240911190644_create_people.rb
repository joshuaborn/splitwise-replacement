class CreatePeople < ActiveRecord::Migration[7.2]
  def change
    create_table :people do |t|
      t.string :name
      t.boolean :is_administrator

      t.timestamps
    end
  end
end
