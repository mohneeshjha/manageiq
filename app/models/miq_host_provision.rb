class MiqHostProvision < MiqRequestTask
  include_concern 'Configuration'
  include_concern 'PostInstallCallback'
  include_concern 'Ipmi'
  include_concern 'OptionsHelper'
  include_concern 'Placement'
  include_concern 'Pxe'
  include_concern 'Rediscovery'
  include_concern 'StateMachine'
  include_concern 'Tagging'

  alias_attribute :provision_type,             :request_type
  alias_attribute :miq_host_provision_request, :miq_request
  alias_attribute :host,                       :source

  validates :request_type,
            :inclusion => { :in      => %w(host_pxe_install),
                            :message => "should be 'host_pxe_install'"
                          }
  validates :state,
            :inclusion => { :in      => %w(pending queued active provisioned finished),
                            :message => 'should be pending, queued, active, provisioned or finished' }

  virtual_column :provision_type, :type => :string

  AUTOMATE_DRIVES = true

  def self.get_description(prov_obj)
    prov_obj.description
  end

  def self.base_model
    MiqHostProvision
  end

  def deliver_to_automate
    super("host_provision")
  end

  def do_request
    signal :create_destination
  end

  delegate :name, :to => :host, :prefix => true

  def self.display_name(number = 1)
    n_('Host Provision', 'Host Provisions', number)
  end
end
