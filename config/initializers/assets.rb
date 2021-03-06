# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( order_page.css price_page.css)
Rails.application.config.assets.precompile += %w( order_page.js price_list_update.js costume_price_list_update.js)
Rails.application.config.assets.precompile += %w( invitations_list.scss)
Rails.application.config.assets.precompile += %w( invitation_states_switcher.js)