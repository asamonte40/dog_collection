class AddDetailsToBreeds < ActiveRecord::Migration[8.0]
  def change
    add_column :breeds, :description, :text
    add_column :breeds, :temperament, :string
    add_column :breeds, :life_span, :string
    add_column :breeds, :image_url, :string
  end
end
