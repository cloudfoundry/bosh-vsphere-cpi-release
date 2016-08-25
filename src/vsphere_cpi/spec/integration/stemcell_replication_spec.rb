require 'integration/spec_helper'

context 'Replicating stemcells across datastores', external_cpi: false do
  before (:all) do
    @cluster_name = fetch_and_verify_cluster('BOSH_VSPHERE_CPI_CLUSTER')
    @datastore_pattern = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_DATASTORE_PATTERN', @cluster_name)
    @second_datastore = fetch_and_verify_datastore('BOSH_VSPHERE_CPI_SECOND_DATASTORE', @cluster_name)
    verify_non_overlapping_datastores(
      cpi_options,
      @datastore_pattern,
      'BOSH_VSPHERE_CPI_DATASTORE_PATTERN',
      @second_datastore,
      'BOSH_VSPHERE_CPI_SECOND_DATASTORE'
    )
  end

  let(:second_cpi) do
    options = cpi_options(
      datacenters: [{
        clusters: [@cluster_name]
      }],
    )
    VSphereCloud::Cloud.new(options)
  end

  let(:destination_cluster) { @cpi.datacenter.clusters[@cluster_name] }

  it 'raises an error when no stemcell exists for the given stemcell id' do
    expect {
      @cpi.replicate_stemcell(destination_cluster, @cpi.datacenter.accessible_datastores.values.first, 'abc123')
    }.to raise_error('Could not find VM for stemcell \'abc123\'')
  end

  context 'when a stemcell exists for the given stemcell id' do
    before do
      @orig_stemcell_id = nil
      Dir.mktmpdir do |temp_dir|
        stemcell_image = stemcell_image(@stemcell_path, temp_dir)
        @orig_stemcell_id = @cpi.create_stemcell(stemcell_image, nil)
        @original_stemcell_vm = @cpi.client.find_vm_by_name(@cpi.datacenter.mob, @orig_stemcell_id)
      end
    end

    after do
      @cpi.delete_stemcell(@orig_stemcell_id)
    end

    it 'creates and returns the new stemcell unless it already exists' do
      # NOTE: using a singe rspec example to tests multiple contexts since
      # creating the original stemcell to run the test against is very expensive
      # and all of the contexts we are testing can be run on same setup state

      original_datastore = @cpi.datacenter.accessible_datastores[@cpi.vm_datastore_name(@original_stemcell_vm)]
      other_datastore = @cpi.datacenter.accessible_datastores[@second_datastore]

      #Test:        replicate into original datastore
      #Expectation: returns original stemcell vm and does not create a replica
      expect {
        same_stemcell_vm = @cpi.replicate_stemcell(destination_cluster, original_datastore, @orig_stemcell_id)
        expect(same_stemcell_vm.__mo_id__).to eq(@original_stemcell_vm.__mo_id__)
      }.to_not change {
        @cpi.client.find_all_stemcell_replicas_in_datastore(
        @cpi.datacenter.mob,
        @orig_stemcell_id,
        original_datastore.name
        ).size
      }

      #Test:        replicate into another datastore
      #Expectation: creates replica stemcell vm and returns it
      replicated_stemcell_vm = nil
      expect {
        replicated_stemcell_vm = @cpi.replicate_stemcell(destination_cluster, other_datastore, @orig_stemcell_id)
        expect(replicated_stemcell_vm.__mo_id__).to_not eq(@original_stemcell_vm.__mo_id__)
      }.to change {
        @cpi.client.find_all_stemcell_replicas_in_datastore(
        @cpi.datacenter.mob,
        @orig_stemcell_id,
        other_datastore.name
        ).size
      }.by(1)

      #Test:        re-replicate into another datastore
      #Expectation: returns already created replica vm (and does not create new one)
      expect {
        same_replicated_stemcell_vm = @cpi.replicate_stemcell(destination_cluster, other_datastore, @orig_stemcell_id)
        expect(same_replicated_stemcell_vm.__mo_id__).to eq(replicated_stemcell_vm.__mo_id__)
      }.to_not change {
        @cpi.client.find_all_stemcell_replicas_in_datastore(
        @cpi.datacenter.mob,
        @orig_stemcell_id,
        other_datastore.name
        ).size
      }

      #Test:        re-replicate into another datastore using second_cpi
      #Expectation: returns already created replica vm (and does not create new one)
      expect {
        same_replicated_stemcell_vm = second_cpi.replicate_stemcell(destination_cluster, other_datastore, @orig_stemcell_id)
        expect(same_replicated_stemcell_vm.__mo_id__).to eq(replicated_stemcell_vm.__mo_id__)
      }.to_not change {
        second_cpi.client.find_all_stemcell_replicas_in_datastore(
        second_cpi.datacenter.mob,
        @orig_stemcell_id,
        other_datastore.name
        ).size
      }

      #Test:        deleting stemcell
      #Expectation: deletes all created stemcell vms (including replicas)
      expect {
        @cpi.delete_stemcell(@orig_stemcell_id)
      }.to change {
        @cpi.client.find_all_stemcell_replicas(@cpi.datacenter.mob, @orig_stemcell_id).size
      }.by(-1 * [@original_stemcell_vm, replicated_stemcell_vm].size)

      #Test:        re-deleting stemcell using second cpi
      #Expectation: does not delete anything since they should already be cleaned up
      expect {
        second_cpi.delete_stemcell(@orig_stemcell_id)
      }.to_not change {
        second_cpi.client.find_all_stemcell_replicas(@cpi.datacenter.mob, @orig_stemcell_id).size
      }
    end

    context 'when another thread is in the process of creating the replicated stemcell' do
      it 'waits for other thread to finish creating stemcell vm and returns it new' do
        destination_datastore = @cpi.datacenter.accessible_datastores[@second_datastore]

        t1_replicated_stemcell_vm = nil
        t1 = Thread.new {
          cpi = VSphereCloud::Cloud.new(cpi_options)
          t1_replicated_stemcell_vm = cpi.replicate_stemcell(destination_cluster, destination_datastore, @orig_stemcell_id)
        }

        t2_replicated_stemcell_vm = nil
        t2 = Thread.new {
          cpi = VSphereCloud::Cloud.new(cpi_options)
          t2_replicated_stemcell_vm = cpi.replicate_stemcell(destination_cluster, destination_datastore, @orig_stemcell_id)
        }

        t3_replicated_stemcell_vm = nil
        t3 = Thread.new {
          cpi = VSphereCloud::Cloud.new(cpi_options)
          t3_replicated_stemcell_vm = cpi.replicate_stemcell(destination_cluster, destination_datastore, @orig_stemcell_id)
        }

        t1.join
        expect(t1_replicated_stemcell_vm).to_not be_nil
        t2.join
        expect(t2_replicated_stemcell_vm.__mo_id__).to eq(t1_replicated_stemcell_vm.__mo_id__)
        t3.join
        expect(t3_replicated_stemcell_vm.__mo_id__).to eq(t1_replicated_stemcell_vm.__mo_id__)

        expect(
        @cpi.client.find_all_stemcell_replicas_in_datastore(
        @cpi.datacenter.mob,
        @orig_stemcell_id,
        destination_datastore.name
        ).size
        ).to eq(1)
      end
    end
  end
end
