# frozen_string_literal: true

ActiveRecord::Schema.define(version: 1) do
  create_table :events do |t|
    t.string :name
    t.time :start_at
    t.binary :content
  end
end
