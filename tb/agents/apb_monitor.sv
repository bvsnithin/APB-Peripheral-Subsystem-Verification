
class apb_monitor extends uvm_monitor;

    `uvm_component_utils(apb_monitor)

    virtual apb_if vif;

    uvm_analysis_port #(apb_seq_item) item_collected_port;

    apb_seq_item trans_collected;

    function new(string name, uvm_component parent);
        super.new("apb_monitor",parent);
        item_collected_port = new("item_collected_port", this);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
            `uvm_fatal("NO VIF","Virtual interface not found in APB Monitor");
    endfunction: build_phase

    task run_phase(uvm_phase phase);

        `uvm_info("MON", "Monitor run_phase started", UVM_LOW)

        forever begin
            @(posedge vif.pclk);
            if(vif.psel && vif.penable && vif.pready) begin
                `uvm_info("MON", "Transaction Captured!", UVM_LOW)

                trans_collected = apb_seq_item::type_id::create("trans_collected");
                trans_collected.paddr = vif.paddr;
                trans_collected.pwrite = vif.pwrite;

                if (vif.pwrite) begin
                    // Write Operation: Capture pwdata
                    trans_collected.pwdata = vif.pwdata;
                end else begin
                    // Read Operation: Capture prdata
                    trans_collected.prdata = vif.prdata; 
                end
                
                item_collected_port.write(trans_collected);
            end

        end

    endtask: run_phase

endclass: apb_monitor