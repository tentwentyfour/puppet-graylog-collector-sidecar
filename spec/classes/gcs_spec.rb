require 'spec_helper'

describe 'gcs', :type => :class do
  let(:title) { 'gcs' }
  let(:facts) { { } }
  let(:service_name) { 'collector-sidecar' }
  let(:collector_config) { '/etc/graylog/collector-sidecar/collector_sidecar.yml' }
  let(:server_url) { 'http://127.0.0.1:9000/api/' }
  let(:puppet_cache) { '/var/cache/puppet' }
  let(:archive_dir) { '/var/cache/puppet/archives' }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts.merge(super())
        end

        context 'default' do
          let(:params) { { :server_url => server_url } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('gcs::params') }

          it { is_expected.to contain_anchor('::gcs::begin') }
          it { is_expected.to contain_anchor('::gcs::end') }

          describe "gcs::install" do
            it { is_expected.to contain_class('gcs::install') }

            it { is_expected.to contain_remote_file('retrieve_gcs') }
            it { is_expected.to contain_exec('install_gcs_service') }

            it { should contain_file(puppet_cache).with_ensure('directory') }
            it { should contain_file(puppet_cache).with_owner('root') }
            it { should contain_file(puppet_cache).with_group('root') }
            it { should contain_file(puppet_cache).with_mode('0755') }

            it { should contain_file(archive_dir).with_ensure('directory') }
            it { should contain_file(archive_dir).with_owner('root') }
            it { should contain_file(archive_dir).with_group('root') }
            it { should contain_file(archive_dir).with_mode('0755') }

            it { should contain_package(service_name) }
          end
          describe "gcs::config" do
            it { is_expected.to contain_class('gcs::config') }

            it { should contain_file(collector_config).with_ensure('file') }
            it { should contain_file(collector_config).with_owner('root') }
            it { should contain_file(collector_config).with_group('root') }
            it { should contain_file(collector_config).with_mode('0640') }
          end
          describe "gcs::service" do
            it { is_expected.to contain_class('gcs::service') }
            it { is_expected.to contain_service(service_name) }
          end
        end
      end
    end
  end
end
