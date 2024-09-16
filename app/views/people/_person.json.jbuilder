json.extract! person, :id, :name, :is_administrator, :created_at, :updated_at
json.url person_url(person, format: :json)
