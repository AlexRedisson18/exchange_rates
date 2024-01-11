# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
ExchangeRate.destroy_all

minimal_days_count = 28
days_offset = minimal_days_count + (Date.today.wday - 1)
days_range = days_offset.days.ago.to_date..Date.today
ExchangeRatesImportService.new(days_range).call
