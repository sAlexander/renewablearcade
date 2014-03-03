##########
# USERS
##########
migration "create the games table" do
  database.create_table :games do
    primary_key :id
    String :name
    String :email
    String :token
    DateTime :created_at
  end
end
