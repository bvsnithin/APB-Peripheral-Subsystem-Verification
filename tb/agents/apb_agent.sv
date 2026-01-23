class apb_agent extends uvm_agent;


    `uvm_component_utils(apb_agent)

    apb_driver drv;
    apb_monitor mon;
    uvm_sequencer #(apb_seq_item) seqr;

    virtual apb_if vif;

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = apb_monitor::type_id::create("mon", this);

        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif)) begin
            `uvm_fatal("NO VIF","Virtual interface not found in APB Agent")
        end

        if(get_is_active()==UVM_ACTIVE)begin
            drv = apb_driver::type_id::create("drv", this);
            seqr = uvm_sequencer#(apb_seq_item)::type_id::create("seqr", this);
        end

    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        mon.vif = vif;

        if(get_is_active()==UVM_ACTIVE) begin
            drv.vif = vif;
            drv.seq_item_port.connect(seqr.seq_item_export);
        end

    endfunction
endclass: apb_agent