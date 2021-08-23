require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DemoShrine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Use SuckerPunch for background jobs.
    config.active_job.queue_adapter = :sucker_punch

    config.autoload_paths += %w[app/uploaders lib]

    config.upload_server = if ENV["UPLOAD_SERVER"].present?
                             ENV["UPLOAD_SERVER"].to_sym
                           elsif Rails.env.production?
                             :s3
                           else
                             :app
                           end
  end
end
