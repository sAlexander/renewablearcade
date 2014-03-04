##########
# USERS
##########
migration "create the games table" do
  database.create_table :games do
    primary_key :id
    String :firstname
    String :email
    String :token
    Float :power
    DateTime :created_at
  end
end
