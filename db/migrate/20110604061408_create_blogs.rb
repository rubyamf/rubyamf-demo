class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.integer :user_id
      t.string  :title
      t.string  :tagline
      t.string  :author
      t.string  :bio
      t.text    :detail
      t.binary  :byte_content

      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
