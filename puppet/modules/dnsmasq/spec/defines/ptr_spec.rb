require 'spec_helper'

describe 'dnsmasq::ptr', :type => 'define' do
  let :title  do 'foo.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with no params' do
    it 'should raise error due no params' do
      expect { should compile }.to raise_error(Puppet::Error,/Must pass/)
    end
  end

  context 'with value' do
    let :params do { :value => 'example.com' } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-ptr-foo.com').with(
        :order   => '09',
        :target  => 'dnsmasq.conf',
        :content => "ptr-record=foo.com,example.com\n",
      )
    end
  end

end
