class ExchangeRate < ApplicationRecord
  CURRENCIES = %w[USD EUR CNY].freeze

  validates :currency, presence: true
  validates :currency, inclusion: { in: CURRENCIES }
  validates :currency, uniqueness: { scope: :date, message: 'only one price for currency per day' }
  validates :date, presence: true
  validates :price, presence: true
  validates :price, numericality: { only_numeric: true,
                                    greater_than_or_equal_to: 0,
                                    less_than: BigDecimal(10**3),
                                    format: { with: /\A\d{1,4}(\.\d{1,2})?\z/ } }
end
