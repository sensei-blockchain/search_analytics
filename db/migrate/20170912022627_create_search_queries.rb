class CreateSearchQueries < ActiveRecord::Migration[5.1]
  def change
    create_table :search_queries do |t|
      t.string :query
      t.integer :hits, default: 0
      t.timestamps
    end
  end
end
