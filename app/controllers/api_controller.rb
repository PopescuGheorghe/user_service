class ApiController < ActionController::Base
  include Swagger::Blocks
  include SwaggerSession

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Swagger Petstore'
      key :description, 'A sample API that uses a petstore as an example to ' \
                        'demonstrate features in the swagger-2.0 specification'
      key :termsOfService, 'http://helloreverb.com/terms/'
      contact do
        key :name, 'Wordnik API Team'
      end
      license do
        key :name, 'MIT'
      end
    end
    tag do
      key :name, 'session'
      key :description, 'Pets operations'
      externalDocs do
        key :description, 'Find more info here'
        key :url, 'https://swagger.io'
      end
    end
    key :host, 'localhost:3000'
    key :basePath, '/api'
    key :schemes, ['http']
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end


  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    SessionsController,
    Session,
    ErrorModel,
    self,
  ].freeze
  
  def generate_json
    swagger_data = Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
    File.open('public/swagger.json', 'w') { |file| file.write(swagger_data.to_json) }
  end
end