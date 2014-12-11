ActiveRecord::Schema.define(version: 1) do
  create_table :events do |t|
    t.string :name
    t.time :start_at
  end
end
