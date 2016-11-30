require 'puppet'

Facter.add(:gcs_installed) do
    setcode do
        true
    end
end
