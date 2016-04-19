require 'spec_helper'

describe RenuoCmsRails do
  describe RenuoCmsRails::Configuration do
    [
      [:RENUO_CMS_API_HOST, :api_host, 'custom.host', 'new.host',],
      [:RENUO_CMS_API_KEY, :api_key, 'custom-api-key', 'new-key',],
      [:RENUO_CMS_PRIVATE_API_KEY, :private_api_key, 'custom-private-api-key', 'new-pk']
    ].each do |env_variable_name, method, default_value, new_value|
      describe "##{method}" do
        it 'is the default value from the ENV variable' do
          ClimateControl.modify env_variable_name => default_value do
            config = RenuoCmsRails::Configuration.new
            expect(config.send(method)).to eq(default_value)
          end
        end
      end

      describe "##{method}=" do
        it 'can set value without an env variable' do
          config = RenuoCmsRails::Configuration.new
          config.send("#{method}=", new_value)
          expect(config.send(method)).to eq(new_value)
        end

        it 'can set value when an env variable is defined' do
          ClimateControl.modify env_variable_name => default_value do
            config = RenuoCmsRails::Configuration.new
            config.send("#{method}=", new_value)
            expect(config.send(method)).to eq(new_value)
          end
        end
      end

      describe "#reset (#{method})" do
        it "resets the #{method}" do
          ClimateControl.modify env_variable_name => default_value do
            RenuoCmsRails.configure do |config|
              config.send("#{method}=", new_value)
            end

            expect(RenuoCmsRails.configuration.send(method)).to eq(new_value)
            RenuoCmsRails.reset
            expect(RenuoCmsRails.configuration.send(method)).to eq(default_value)
          end
        end
      end
    end
  end
end
