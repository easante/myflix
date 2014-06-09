class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :comment
      t.integer :stars
      t.references :video, index: true

      t.timestamps
    end
  end
end
