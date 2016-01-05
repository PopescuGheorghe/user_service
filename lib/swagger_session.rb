module SwaggerSession
  class SessionsController
    include Swagger::Blocks
    swagger_path '/sessions' do
      operation :post do
        key :description, 'Creates a new pet in the store.  Duplicates are allowed'
        key :operationId, 'addPet'
        key :produces, [
          'application/json'
        ]
        parameter do
          key :name, :email
          key :in, :query
          key :description, 'Pet to add to the store'
          key :required, true
          schema do
            key :'$ref', :SessionInput
          end
        end
        parameter do
          key :name, :password
          key :in, :query
          key :description, 'pass'
          key :required, true
          schema do
            key :'$ref', :SessionInput
          end
        end
        response 200 do
          key :description, 'pet response'
          schema do
            # Wrong form here, but checks that #/ strings are not transformed.
            key :'$ref', :Session
          end
        end
        response :default do
          key :description, 'unexpected error'
          schema do
            key :'$ref', :ErrorModel
          end
        end
      end
    end
  end

  class Session
    include Swagger::Blocks

    swagger_schema :Session do
      key :required, [:id, :name]
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :name do
        key :type, :string
      end
      property :colors do
        key :type, :array
        items do
          key :type, :string
        end
      end
    end

    swagger_schema :SessionInput do
      allOf do
        schema do
          key :'$ref', :Session
        end
        schema do
          key :required, [:email, :password]
          property :email do
           key :type, :string
          end
          property :password do
            key :type, :string
          end
        end
      end
    end
  end

  class ErrorModel
    include Swagger::Blocks

    swagger_schema :ErrorModel do
      key :required, [:code, :message]
      property :code do
        key :type, :integer
        key :format, :int32
      end
      property :message do
        key :type, :string
      end
    end
  end
end