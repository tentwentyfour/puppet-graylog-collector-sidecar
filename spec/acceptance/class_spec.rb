require 'spec_helper_acceptance'

describe 'gcs class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'gcs': server_url => 'http://127.0.0.1:9000/api/', ensure => 'stopped' }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end

    describe package('collector-sidecar') do
      it { is_expected.to be_installed }
    end

    describe file('/etc/graylog/collector-sidecar/collector_sidecar.yml') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 640 }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_owned_by 'root' }
    end

    describe service('collector-sidecar') do
      it { is_expected.to be_enabled }
    end
  end
end
