require 'swagger_helper'

RSpec.describe 'images', type: :request do

  path '/images' do

    get('list images') do
      tags 'Images'
      produces 'application/json'

      response(200, 'successful') do
        schema(type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string }
          },
          required: %w[id name]
        })

        before { Image.create(name: 'ubuntu:22.04') } # Ensure at least one image exists

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        
        run_test!
      end

      response(404, 'no images found') do
        schema(type: :object, properties: {
          error: { type: :string }
        }, required: ['error'])
  
        before { Image.destroy_all } # Ensure no images exist before running the test
  
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: { error: "No image found!" } # Explicitly set an example response
            }
          }
        end
        run_test!
      end
    end
  end
end
