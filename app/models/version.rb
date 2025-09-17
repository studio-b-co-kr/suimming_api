class Version < ApplicationRecord
  validates :latest_version, :minimum_version,
            presence: true,
            format: { with: /[0-9]+\.[0-9]+\.[0-9]+/,
                      message: 'should keep Semantic Versioning' }
  validates :latest_version, uniqueness: true
  validate :valid_version_numbering

  private

  def valid_version_numbering
    return if Gem::Version.new(latest_version) >= Gem::Version.new(minimum_version)

    errors.add(:latest_version, 'should be greater than or equal to Minimum version')
  end
end
