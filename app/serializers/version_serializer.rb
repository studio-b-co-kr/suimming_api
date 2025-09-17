class VersionSerializer < ActiveModel::Serializer
  attributes :latest_version, :minimum_version, :released_at
end
